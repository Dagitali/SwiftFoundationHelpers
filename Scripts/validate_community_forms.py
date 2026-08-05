#!/usr/bin/env python3
"""Validate GitHub Issue and Discussion forms beyond basic YAML syntax."""

from __future__ import annotations

import re
import sys
from collections import Counter
from pathlib import Path
from typing import Any

import yaml

# SECTION: CONSTANTS ======================================================== #


ALLOWED_TYPES = {
    "checkboxes",
    "dropdown",
    "input",
    "markdown",
    "textarea",
    "upload",
}
ID_PATTERN = re.compile(r"^[A-Za-z0-9_-]+$")


# SECTION: FUNCTIONS ======================================================== #


def error(
    path: Path,
    message: str,
) -> str:
    """Return a consistently formatted validation failure."""
    return f"{path}: {message}"


def duplicate_values(
    values: list[str],
) -> list[str]:
    """Return sorted values that occur more than once."""
    return sorted(value for value, count in Counter(values).items() if count > 1)


def option_label(
    option: Any,
) -> str | None:
    """Return the user-facing label from a dropdown or checkbox option."""
    if isinstance(option, str):
        return option
    if isinstance(option, dict) and isinstance(option.get("label"), str):
        return option["label"]
    return None


def validate_form(
    path: Path,
) -> list[str]:
    """Validate one GitHub Issue or Discussion form."""
    failures: list[str] = []

    try:
        document = yaml.safe_load(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, yaml.YAMLError) as caught_error:
        return [error(path, f"could not parse YAML: {caught_error}")]

    if not isinstance(document, dict):
        return [error(path, "top level must be a mapping")]

    if "ISSUE_TEMPLATE" in path.parts:
        for key in ("name", "description", "body"):
            if not document.get(key):
                failures.append(error(path, f"missing required top-level key: {key}"))
    elif not document.get("body"):
        failures.append(error(path, "missing required top-level key: body"))

    body = document.get("body")
    if not isinstance(body, list) or not body:
        return failures + [error(path, "body must be a nonempty array")]

    identifiers: list[str] = []
    labels: list[str] = []
    has_input = False

    for index, item in enumerate(body):
        location = f"body[{index}]"
        if not isinstance(item, dict):
            failures.append(error(path, f"{location} must be a mapping"))
            continue

        item_type = item.get("type")
        if item_type not in ALLOWED_TYPES:
            failures.append(error(path, f"{location} has invalid type: {item_type!r}"))
            continue

        attributes = item.get("attributes")
        if not isinstance(attributes, dict):
            failures.append(error(path, f"{location} requires attributes"))
            continue

        if item_type == "markdown":
            if not attributes.get("value"):
                failures.append(error(path, f"{location} markdown requires a value"))
            continue

        has_input = True
        identifier = item.get("id")
        label = attributes.get("label")

        if not isinstance(identifier, str) or not ID_PATTERN.fullmatch(identifier):
            failures.append(error(path, f"{location} requires a valid id"))
        else:
            identifiers.append(identifier)

        if not isinstance(label, str) or not label.strip():
            failures.append(error(path, f"{location} requires a label"))
        else:
            labels.append(label)

        if item_type in {"checkboxes", "dropdown"}:
            options = attributes.get("options")
            if not isinstance(options, list) or not options:
                failures.append(error(path, f"{location} requires options"))
                continue

            option_labels = [option_label(option) for option in options]
            if any(option is None for option in option_labels):
                failures.append(error(path, f"{location} has an invalid option"))
            else:
                duplicates = duplicate_values(
                    [option for option in option_labels if option is not None]
                )
                if duplicates:
                    failures.append(
                        error(path, f"{location} has duplicate options: {duplicates}")
                    )

    if not has_input:
        failures.append(error(path, "body requires at least one non-Markdown field"))

    duplicate_ids = duplicate_values(identifiers)
    if duplicate_ids:
        failures.append(error(path, f"duplicate ids: {duplicate_ids}"))

    duplicate_labels = duplicate_values(labels)
    if duplicate_labels:
        failures.append(error(path, f"duplicate labels: {duplicate_labels}"))

    return failures


def main(
    arguments: list[str],
) -> int:
    """Validate provided forms, or discover repository forms when none are provided."""
    paths = [Path(argument) for argument in arguments]
    if not paths:
        paths = sorted(Path(".github/ISSUE_TEMPLATE").glob("*.y*ml"))
        paths += sorted(Path(".github/DISCUSSION_TEMPLATE").glob("*.y*ml"))

    paths = [path for path in paths if path.name != "config.yml"]
    failures = [failure for path in paths for failure in validate_form(path)]

    if failures:
        print("\n".join(failures), file=sys.stderr)
        return 1

    print(f"Validated {len(paths)} GitHub community form(s).")
    return 0


# SECTION: MAIN ENTRY POINT ================================================= #


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
