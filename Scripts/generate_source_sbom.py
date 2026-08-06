#!/usr/bin/env python3
"""Generate an SPDX 2.3 inventory of committed Swift package sources."""

from __future__ import annotations

import argparse
import datetime
import hashlib
import json
import os
import pathlib
import subprocess

# SECTION: CONSTANTS ======================================================== #


DEFAULT_FILE_PATTERNS = """\
Package.swift
Package.resolved
Sources/**
Tests/**
LICENSE*
"""
DEFAULT_NAMESPACE_SLUG = "swift-package-sbom"
PACKAGE_ID = "SPDXRef-Package"


# SECTION: FUNCTIONS ======================================================== #


def git_bytes(*arguments: str) -> bytes:
    """Return byte output from a read-only Git command."""
    return subprocess.check_output(["git", *arguments])


def git_text(*arguments: str) -> str:
    """Return text output from a read-only Git command."""
    return subprocess.check_output(["git", *arguments], text=True)


def digest(algorithm: str, contents: bytes) -> str:
    """Return a content digest, allowing SPDX-required SHA-1 on FIPS hosts."""
    return hashlib.new(
        algorithm,
        contents,
        usedforsecurity=algorithm != "sha1",
    ).hexdigest()


def file_identifier(file_path: str) -> str:
    """Return a collision-resistant SPDX identifier for a repository path."""
    normalized_path = "".join(
        character if character.isalnum() or character == "." else "-"
        for character in file_path
    )
    path_digest = digest("sha256", file_path.encode("utf-8"))[:12]
    return f"SPDXRef-File-{normalized_path}-{path_digest}"


def tracked_files(patterns: list[str]) -> list[str]:
    """Return tracked files matching the supplied Git pathspecs."""
    files = git_text("ls-files", "--", *patterns).splitlines()
    if not files:
        raise ValueError("No tracked files matched the SBOM pathspecs.")
    return files


def source_file(file_path: str) -> tuple[dict[str, object], str]:
    """Return an SPDX file entry and its SHA-1 verification digest."""
    contents = git_bytes("show", f"HEAD:{file_path}")
    return (
        {
            "fileName": f"./{file_path}",
            "SPDXID": file_identifier(file_path),
            "checksums": [
                {
                    "algorithm": "SHA256",
                    "checksumValue": digest("sha256", contents),
                }
            ],
            "licenseConcluded": "NOASSERTION",
            "licenseInfoInFiles": ["NOASSERTION"],
            "copyrightText": "NOASSERTION",
        },
        digest("sha1", contents),
    )


def document(arguments: argparse.Namespace) -> dict[str, object]:
    """Build an SPDX document for the current committed revision."""
    repository = os.environ.get("GITHUB_REPOSITORY", "local/swift-package")
    document_name = arguments.document_name or repository.rsplit("/", 1)[-1]
    namespace_slug = arguments.namespace_slug or DEFAULT_NAMESPACE_SLUG
    revision = git_text("rev-parse", "HEAD").strip()
    created = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0)
    created_text = created.isoformat().replace("+00:00", "Z")
    run_id = os.environ.get(
        "GITHUB_RUN_ID",
        created.strftime("local-%Y%m%d%H%M%S"),
    )
    run_attempt = os.environ.get("GITHUB_RUN_ATTEMPT", "1")
    patterns = [
        pattern.strip()
        for pattern in (
            arguments.file_patterns or DEFAULT_FILE_PATTERNS
        ).splitlines()
        if pattern.strip()
    ]
    entries = [source_file(path) for path in tracked_files(patterns)]
    files = [entry for entry, _ in entries]
    verification_hashes = sorted(checksum for _, checksum in entries)
    verification_code = digest(
        "sha1",
        "".join(verification_hashes).encode("ascii"),
    )

    return {
        "spdxVersion": "SPDX-2.3",
        "dataLicense": "CC0-1.0",
        "SPDXID": "SPDXRef-DOCUMENT",
        "name": document_name,
        "documentNamespace": (
            f"https://github.com/{repository}/"
            f"{namespace_slug}-{revision}-{run_id}-{run_attempt}"
        ),
        "creationInfo": {
            "created": created_text,
            "creators": ["Tool: Swift package source inventory"],
        },
        "files": files,
        "packages": [
            {
                "name": document_name,
                "SPDXID": PACKAGE_ID,
                "downloadLocation": "NOASSERTION",
                "filesAnalyzed": True,
                "packageVerificationCode": {
                    "packageVerificationCodeValue": verification_code,
                },
                "licenseConcluded": "NOASSERTION",
                "licenseDeclared": "NOASSERTION",
                "licenseInfoFromFiles": ["NOASSERTION"],
                "copyrightText": "NOASSERTION",
            }
        ],
        "relationships": [
            {
                "spdxElementId": "SPDXRef-DOCUMENT",
                "relationshipType": "DESCRIBES",
                "relatedSpdxElement": PACKAGE_ID,
            },
            *[
                {
                    "spdxElementId": PACKAGE_ID,
                    "relationshipType": "CONTAINS",
                    "relatedSpdxElement": str(file_entry["SPDXID"]),
                }
                for file_entry in files
            ],
        ],
    }


def parse_arguments() -> argparse.Namespace:
    """Parse command-line configuration."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output-path", required=True, type=pathlib.Path)
    parser.add_argument("--document-name", default="")
    parser.add_argument("--namespace-slug", default="")
    parser.add_argument("--file-patterns", default="")
    return parser.parse_args()


def main() -> int:
    """Generate and write the configured source-inventory document."""
    arguments = parse_arguments()
    arguments.output_path.parent.mkdir(parents=True, exist_ok=True)
    arguments.output_path.write_text(
        json.dumps(document(arguments), indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    return 0


# SECTION: MAIN ENTRY POINT ================================================= #


if __name__ == "__main__":
    raise SystemExit(main())
