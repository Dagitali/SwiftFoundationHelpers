#!/usr/bin/env python3
"""Validate GitHub's automatically generated release-note configuration."""

from __future__ import annotations

import sys
from collections import Counter
from pathlib import Path
from typing import Any

import yaml

# SECTION: FUNCTIONS ======================================================== #


def error(
    path: Path, message: str,
) -> str:
    """Return a consistently formatted validation failure."""
    return f"{path}: {message}"


def duplicate_values(
    values: list[str],
) -> list[str]:
    """Return sorted values that occur more than once."""
    return sorted(value for value, count in Counter(values).items() if count > 1)


def string_list(
    path: Path,
    value: Any,
    location: str,
    *,
    allow_empty: bool = False,
) -> tuple[list[str], list[str]]:
    """Return validated strings and failures for one YAML sequence."""
    if not isinstance(value, list) or (not value and not allow_empty):
        requirement = "an array" if allow_empty else "a nonempty array"
        return [], [error(path, f"{location} must be {requirement}")]

    values = [item for item in value if isinstance(item, str) and item.strip()]
    if len(values) != len(value):
        return values, [error(path, f"{location} must contain nonempty strings")]

    duplicates = duplicate_values(values)
    if duplicates:
        return values, [error(path, f"{location} contains duplicates: {duplicates}")]

    return values, []


def validate_release_config(
    path: Path,
) -> list[str]:
    """Validate one `.github/release.yml` document."""
    try:
        document = yaml.safe_load(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, yaml.YAMLError) as caught_error:
        return [error(path, f"could not parse YAML: {caught_error}")]

    if not isinstance(document, dict):
        return [error(path, "top level must be a mapping")]

    changelog = document.get("changelog")
    if not isinstance(changelog, dict):
        return [error(path, "changelog must be a mapping")]

    failures: list[str] = []
    exclusion = changelog.get("exclude", {})
    if not isinstance(exclusion, dict):
        failures.append(error(path, "changelog.exclude must be a mapping"))
    else:
        _, exclusion_failures = string_list(
            path,
            exclusion.get("labels", []),
            "changelog.exclude.labels",
            allow_empty=True,
        )
        failures.extend(exclusion_failures)

    categories = changelog.get("categories")
    if not isinstance(categories, list) or not categories:
        return failures + [error(path, "changelog.categories must be a nonempty array")]

    titles: list[str] = []
    categorized_labels: dict[str, str] = {}

    for index, category in enumerate(categories):
        location = f"changelog.categories[{index}]"
        if not isinstance(category, dict):
            failures.append(error(path, f"{location} must be a mapping"))
            continue

        title = category.get("title")
        if not isinstance(title, str) or not title.strip():
            failures.append(error(path, f"{location}.title must be a nonempty string"))
        else:
            titles.append(title)

        labels, label_failures = string_list(
            path,
            category.get("labels"),
            f"{location}.labels",
        )
        failures.extend(label_failures)

        for label in labels:
            previous_title = categorized_labels.get(label)
            if previous_title is not None:
                failures.append(
                    error(
                        path,
                        f"label {label!r} appears in {previous_title!r} and {title!r}",
                    )
                )
            else:
                categorized_labels[label] = title

    duplicate_titles = duplicate_values(titles)
    if duplicate_titles:
        failures.append(error(path, f"duplicate category titles: {duplicate_titles}"))

    final_category = categories[-1]
    if not isinstance(final_category, dict):
        return failures
    if final_category.get("title") != "Other Changes":
        failures.append(error(path, "Other Changes must be the final category"))
    if final_category.get("labels") != ["*"]:
        failures.append(error(path, "Other Changes must use only the '*' label"))

    return failures


def main(
    arguments: list[str],
) -> int:
    """Validate provided files, or `.github/release.yml` by default."""
    paths = [Path(argument) for argument in arguments]
    if not paths:
        paths = [Path(".github/release.yml")]

    failures = [
        failure
        for path in paths
        for failure in validate_release_config(path)
    ]
    if failures:
        print("\n".join(failures), file=sys.stderr)
        return 1

    print(f"Validated {len(paths)} release-note configuration file(s).")
    return 0


# SECTION: MAIN ENTRY POINT ================================================= #


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
