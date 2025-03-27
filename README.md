# SwiftFoundationHelpers

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Dagitali/SwiftFoundationHelpers?sort=semver)
![Build Status](https://github.com/Dagitali/SwiftFoundationHelpers/actions/workflows/lint.yml/badge.svg)
![Build Status](https://github.com/Dagitali/SwiftFoundationHelpers/actions/workflows/test.yml/badge.svg)
![Build Status](https://github.com/Dagitali/SwiftFoundationHelpers/actions/workflows/release.yml/badge.svg)
![Build Status](https://github.com/Dagitali/SwiftFoundationHelpers/actions/workflows/document.yml/badge.svg)
![Build Status](https://github.com/Dagitali/SwiftFoundationHelpers/actions/workflows/publish.yml/badge.svg)
![Codecov](https://codecov.io/gh/Dagitali/SwiftFoundationHelpers/branch/main/graph/badge.svg)
![GitHub](https://img.shields.io/github/license/Dagitali/SwiftFoundationHelpers)
![GitHub issues](https://img.shields.io/github/issues/Dagitali/SwiftFoundationHelpers)
![GitHub pull requests](https://img.shields.io/github/issues-pr/Dagitali/SwiftFoundationHelpers)
![GitHub top language](https://img.shields.io/github/languages/top/Dagitali/SwiftFoundationHelpers)
![GitHub repo size](https://img.shields.io/github/repo-size/Dagitali/SwiftFoundationHelpers)
![GitHub contributors](https://img.shields.io/github/contributors/Dagitali/SwiftFoundationHelpers)

A Swift package that includes an integrated collection of Swift Foundation extensions and related
custom abstractions.

- [SwiftFoundationHelpers](#swiftfoundationhelpers)
  - [Overview](#overview)
  - [Features](#features)
  - [Installation](#installation)
    - [Using Swift Package Manager (SPM)](#using-swift-package-manager-spm)
  - [Documentation](#documentation)
    - [Community Health](#community-health)
    - [Project](#project)
  - [Contributing](#contributing)
  - [License](#license)
  - [Acknowledgments](#acknowledgments)

## Overview

SwiftFoundationHelpers is a Swift package designed to complement Swift Foundation, Apple’s native
framework for building Swift apps and packages.  It simplifies everyday coding tasks by extending
key Foundation types such as String, Date, Array, and more.

This package focuses on providing practical, reusable extensions and abstractions that:

* Simplify common patterns in Swift Foundation.
* Extend Swift Foundation’s capabilities without overriding or replacing its native functionality.

By integrating SwiftFoundationHelpers into your project, you can reduce boilerplate code, improve
readability, and adopt reusable patterns tailored for modern Swift apps and packages.

## Features

🔧 **Extensions**

Enhance your Foundation types with powerful, reusable extensions for these Swift Foundation types:

* `Array`
* `Bundle`
* `Date`
* `String`
* `URL`
* `UserDefaults`

## Installation

### Using Swift Package Manager (SPM)

To integrate SwiftFoundationHelpers into your project:

1. Open your project in **Xcode**.
2. Navigate to **File > Add Packages**.
3. Enter the URL for this repository:

   <https://github.com/Dagitali/SwiftFoundationHelpers>

4. Select the latest version and add it to your target.

## Documentation

For detailed API documentation and more usage examples, visit the [SwiftFoundationHelpers][docs]
documentation site.  For project documentation, refer to the files listed in the subsections that
follow.

### Community Health

* [Code of Conduct](CODE_OF_CONDUCT.md)
* [Contributing](CONTRIBUTING.md)

### Project

* [References](REFERENCES.md)

## Contributing

Contributions are welcome!  If you’d like to add a new feature, fix a bug, or improve the
documentation:

1. Fork this repository.
2. Create a new feature branch for your changes (`git checkout -b feature/feature-name`).
3. Commit your changes (`git commit -m "Add feature"`).
4. Push to your branch (`git push origin feature-name`).
5. Submit a pull request with a detailed description.

## License

SwiftFoundationHelpers is available under the [MIT License](LICENSE).

## Acknowledgments

SwiftFoundationHelpers is inspired by common patterns in Swift development, aiming to reduce
boilerplate code and increase productivity.  Feedback and contributions are always appreciated!

Special thanks to the Swift Foundation community for fostering creativity and collaboration.

[docs]: https://dagitali.github.io/SwiftFoundationHelpers/documentation/swiftfoundationhelpers/
