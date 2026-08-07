"""Print an available simulator UDID for the latest requested runtime."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from typing import Any

# SECTION: CONSTANTS ======================================================== #


RUNTIME_NAMES = {
    "iOS": "iOS",
    "tvOS": "tvOS",
    "visionOS": "xrOS",
    "watchOS": "watchOS",
}

PREFERRED_DEVICE_PREFIXES = {
    "iOS": "iPhone",
    "tvOS": "Apple TV",
    "visionOS": "Apple Vision Pro",
    "watchOS": "Apple Watch",
}


# SECTION: FUNCTIONS ======================================================== #


# -- Simulator Selection -- #


def runtime_version(
    identifier: str,
) -> tuple[int, ...]:
    """Return the numeric version encoded in a simulator runtime identifier."""
    match = re.search(r"-(\d+(?:-\d+)*)$", identifier)
    if match is None:
        return ()
    return tuple(int(component) for component in match.group(1).split("-"))


def select_device(
    platform: str,
    document: dict[str, Any],
) -> str:
    """Return a deterministic device UDID from the latest available runtime."""
    runtime_name = RUNTIME_NAMES[platform]
    runtime_marker = f".SimRuntime.{runtime_name}-"
    candidates = [
        (runtime_version(identifier), identifier, devices)
        for identifier, devices in document.get("devices", {}).items()
        if runtime_marker in identifier and devices
    ]
    if not candidates:
        raise ValueError(f"No available {platform} Simulator runtime was found")

    _, _, devices = max(candidates, key=lambda candidate: candidate[:2])
    preferred_prefix = PREFERRED_DEVICE_PREFIXES[platform]
    selected = min(
        devices,
        key=lambda device: (
            not device.get("name", "").startswith(preferred_prefix),
            device.get("name", ""),
            device.get("udid", ""),
        ),
    )
    return str(selected["udid"])


# -- Command Line -- #


def main() -> int:
    """Load available simulators and print the selected destination identifier."""
    parser = argparse.ArgumentParser()
    parser.add_argument("platform", choices=RUNTIME_NAMES)
    arguments = parser.parse_args()
    completed = subprocess.run(
        ["xcrun", "simctl", "list", "devices", "available", "--json"],
        check=True,
        capture_output=True,
        text=True,
    )
    document = json.loads(completed.stdout)
    print(select_device(arguments.platform, document))
    return 0


# SECTION: MAIN ENTRY POINT ================================================= #


if __name__ == "__main__":
    raise SystemExit(main())
