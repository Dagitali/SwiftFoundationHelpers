"""Generate an SPDX 2.3 inventory of committed repository files."""

from __future__ import annotations

import argparse
import datetime
import hashlib
import json
import os
import pathlib
import subprocess
import urllib.parse

# SECTION: CONSTANTS ======================================================== #


DEFAULT_NAMESPACE_SLUG = "source-inventory-sbom"
PACKAGE_ID = "SPDXRef-Package"


# SECTION: FUNCTIONS ======================================================== #


# -- Git Operations -- #


def git_bytes(
    repository_root: pathlib.Path,
    *arguments: str,
) -> bytes:
    """Return byte output from a read-only Git command."""
    return subprocess.check_output(
        ["git", "-C", os.fspath(repository_root), *arguments]
    )


def git_text(
    repository_root: pathlib.Path,
    *arguments: str,
) -> str:
    """Return text output from a read-only Git command."""
    return subprocess.check_output(
        ["git", "-C", os.fspath(repository_root), *arguments],
        text=True,
    )


def tracked_files(
    repository_root: pathlib.Path,
    patterns: list[str],
) -> list[str]:
    """Return tracked files matching the supplied Git pathspecs."""
    arguments = ["ls-files", "-z", "--", *patterns]
    output = git_bytes(repository_root, *arguments)
    files = [os.fsdecode(path) for path in output.split(b"\0") if path]
    if not files:
        raise ValueError("No tracked files matched the SBOM pathspecs.")
    return files


# -- SPDX Content -- #


def digest(
    algorithm: str,
    contents: bytes,
) -> str:
    """Return a content digest, allowing SPDX-required SHA-1 on FIPS hosts."""
    return hashlib.new(
        algorithm,
        contents,
        usedforsecurity=algorithm != "sha1",
    ).hexdigest()


def file_identifier(
    file_path: str,
) -> str:
    """Return a collision-resistant SPDX identifier for a repository path."""
    normalized_path = "".join(
        character if character.isalnum() or character == "." else "-"
        for character in file_path
    )
    path_digest = digest("sha256", os.fsencode(file_path))[:12]
    return f"SPDXRef-File-{normalized_path}-{path_digest}"


def source_file(
    repository_root: pathlib.Path,
    revision: str,
    file_path: str,
) -> tuple[dict[str, object], str]:
    """Return an SPDX file entry and its SHA-1 verification digest."""
    contents = git_bytes(repository_root, "show", f"{revision}:{file_path}")
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


def document(
    arguments: argparse.Namespace,
) -> dict[str, object]:
    """Build an SPDX document for the configured committed revision."""
    repository_root = arguments.repository_root.resolve()
    repository = os.environ.get("GITHUB_REPOSITORY", "local/repository")
    server_url = os.environ.get(
        "GITHUB_SERVER_URL",
        "https://github.com",
    ).rstrip("/")
    document_name = arguments.document_name or repository.rsplit("/", 1)[-1]
    namespace_slug = urllib.parse.quote(
        arguments.namespace_slug or DEFAULT_NAMESPACE_SLUG,
        safe=".-_~",
    )
    revision = git_text(repository_root, "rev-parse", "HEAD").strip()
    created = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0)
    run_id = os.environ.get(
        "GITHUB_RUN_ID",
        created.strftime("local-%Y%m%d%H%M%S"),
    )
    run_attempt = os.environ.get("GITHUB_RUN_ATTEMPT", "1")
    patterns = [
        pattern.strip()
        for pattern in arguments.file_patterns.splitlines()
        if pattern.strip()
    ]
    entries = [
        source_file(repository_root, revision, path)
        for path in tracked_files(repository_root, patterns)
    ]
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
            f"{server_url}/{repository}/"
            f"{namespace_slug}-{revision}-{run_id}-{run_attempt}"
        ),
        "creationInfo": {
            "created": created.isoformat().replace("+00:00", "Z"),
            "creators": ["Tool: Source inventory SBOM generator"],
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


def validate(
    document_contents: dict[str, object],
) -> None:
    """Validate identifiers and references required by this SPDX profile."""
    files = document_contents["files"]
    packages = document_contents["packages"]
    relationships = document_contents["relationships"]
    if not all(isinstance(value, list) for value in (files, packages, relationships)):
        raise ValueError("SPDX files, packages, and relationships must be lists.")

    identifiers = {
        str(document_contents["SPDXID"]),
        *(str(entry["SPDXID"]) for entry in files),
        *(str(entry["SPDXID"]) for entry in packages),
    }
    expected_identifier_count = 1 + len(files) + len(packages)
    if len(identifiers) != expected_identifier_count:
        raise ValueError("SPDX identifiers must be unique.")

    for relationship in relationships:
        source = str(relationship["spdxElementId"])
        destination = str(relationship["relatedSpdxElement"])
        if source not in identifiers or destination not in identifiers:
            raise ValueError("SPDX relationships must reference known elements.")


# -- Command Line -- #


def parse_arguments() -> argparse.Namespace:
    """Parse command-line configuration."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output-path", required=True, type=pathlib.Path)
    parser.add_argument("--document-name", default="")
    parser.add_argument("--namespace-slug", default="")
    parser.add_argument("--file-patterns", default="")
    parser.add_argument(
        "--repository-root",
        default=pathlib.Path.cwd(),
        type=pathlib.Path,
    )
    return parser.parse_args()


def main() -> int:
    """Generate, validate, and write the configured source inventory."""
    arguments = parse_arguments()
    document_contents = document(arguments)
    validate(document_contents)
    arguments.output_path.parent.mkdir(parents=True, exist_ok=True)
    arguments.output_path.write_text(
        json.dumps(document_contents, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    return 0


# SECTION: MAIN ENTRY POINT ================================================= #


if __name__ == "__main__":
    raise SystemExit(main())
