# SwiftFoundationHelpers

![Latest release](https://img.shields.io/github/v/release/Dagitali/SwiftFoundationHelpers?sort=semver)
![Lint](https://github.com/Dagitali/SwiftFoundationHelpers/actions/workflows/lint.yml/badge.svg)
![Tests](https://github.com/Dagitali/SwiftFoundationHelpers/actions/workflows/test.yml/badge.svg)
![Release](https://github.com/Dagitali/SwiftFoundationHelpers/actions/workflows/release.yml/badge.svg)
![Documentation](https://github.com/Dagitali/SwiftFoundationHelpers/actions/workflows/document.yml/badge.svg)
![Publish](https://github.com/Dagitali/SwiftFoundationHelpers/actions/workflows/publish.yml/badge.svg)
![Codecov](https://codecov.io/gh/Dagitali/SwiftFoundationHelpers/branch/main/graph/badge.svg)
![MIT license](https://img.shields.io/github/license/Dagitali/SwiftFoundationHelpers)

SwiftFoundationHelpers is a Swift package containing focused Foundation and standard-library
extensions for common collection, date, string, URL, bundle-resource, integer, and preference tasks.

- [Overview](#overview)
- [Requirements](#requirements)
- [Features](#features)
  - [Extensions](#extensions)
- [Installation](#installation)
  - [Xcode](#xcode)
  - [Package.swift](#packageswift)
- [Usage](#usage)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Overview

The package complements Foundation with small, reusable APIs that reduce repeated application code
without replacing native functionality. Public helpers favor explicit policy inputs, deterministic
results, source compatibility, and error propagation where practical.

SwiftFoundationHelpers is distributed as source through Swift Package Manager and has no third-party
runtime dependencies.

## Requirements

The current package manifest requires Swift tools 6.0 or newer and declares these minimum platforms:

| Platform | Minimum version |
| --- | --- |
| iOS | 18 |
| Mac Catalyst | 18 |
| macOS | 15 |
| tvOS | 18 |
| visionOS | 2 |
| watchOS | 11 |

`Package.swift` is the source of truth if these requirements change.

## Features

### Extensions

Enhance native Swift Foundation types with new properties and methods:

- `Array` duplicate removal that preserves first-occurrence ordering.
- `Bundle` JSON decoding and encoding, including throwing variants and `BundleResourceError`.
- `Date` arithmetic, comparison, calendar-aware queries, and formatting helpers.
- `Int` range and repeated-action conveniences.
- `String` validation, normalization, matching, ordering, and transformation helpers.
- `Optional<String>` normalization for trimmed, nonempty values.
- `URL` validation, JSON coding, query manipulation, HTTP checks, and homepage or favicon helpers.
- `UserDefaults.Key` constants for consistently named preference keys.

See the [DocC documentation] for complete signatures, availability, errors, and behavior.

## Installation

### Xcode

1. In Xcode, choose **File > Add Package Dependencies**.
2. Enter the repository URL:

   <https://github.com/Dagitali/SwiftFoundationHelpers>

3. Select an appropriate stable version rule.
4. Add the `SwiftFoundationHelpers` library product to the intended target.

### Package.swift

Add the package dependency and library product to the consuming target:

```swift
dependencies: [
    .package(
        url: "https://github.com/Dagitali/SwiftFoundationHelpers.git",
        from: "0.22.0"
    )
],
targets: [
    .target(
        name: "ExampleTarget",
        dependencies: ["SwiftFoundationHelpers"]
    )
]
```

Use the latest stable version appropriate for the consuming project. Review the [release policy]
before changing version requirements.

## Usage

Import Foundation and SwiftFoundationHelpers, then call the extensions on their native types:

```swift
import Foundation
import SwiftFoundationHelpers

let uniqueNumbers = [3, 1, 3, 2].removingDuplicates()
// [3, 1, 2]

let displayName = "  Dagitali  ".trimmedNonEmpty
// Optional("Dagitali")

let endpoint = try URL(validating: "https://example.com/resource.json")
let page = endpoint.homepage
// Optional(https://example.com/)
```

Prefer the throwing and policy-explicit overloads for new code when callers need actionable errors
or deterministic calendar, codec, matching, or file-writing behavior. Deprecated convenience
overloads remain available only for the compatibility period defined by the release policy.

## Documentation

- [DocC documentation] provides the public API reference.
- [SUPPORT.md] explains support channels and useful reproduction details.
- [SECURITY.md] defines private vulnerability reporting and coordinated disclosure.
- [RELEASE-POLICY.md] defines compatibility, versioning, deprecation, and release expectations.
- [REFERENCES.md] records implementation and repository-maintenance references.

## Contributing

Contributions are welcome. Read [CONTRIBUTING.md] for development setup, testing, branch, public
API, and pull-request requirements, and follow [CODE_OF_CONDUCT.md] in all project interactions.

## License

SwiftFoundationHelpers is available under the [MIT License](LICENSE).

## Acknowledgments

SwiftFoundationHelpers draws on common patterns from the Swift and Foundation communities. Thank
you to the maintainers, contributors, and documentation authors whose work improves the ecosystem.

[CODE_OF_CONDUCT.md]: CODE_OF_CONDUCT.md
[CONTRIBUTING.md]: CONTRIBUTING.md
[DocC documentation]: https://dagitali.github.io/SwiftFoundationHelpers/documentation/swiftfoundationhelpers/
[REFERENCES.md]: REFERENCES.md
[release policy]: RELEASE-POLICY.md
[RELEASE-POLICY.md]: RELEASE-POLICY.md
[SECURITY.md]: SECURITY.md
[SUPPORT.md]: SUPPORT.md
