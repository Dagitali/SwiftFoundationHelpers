# Contributing Guidelines

Contributions to SwiftFoundationHelpers are welcome through GitHub pull requests. By submitting a
contribution, you agree that it may be distributed under the repository's [MIT License].

- [Ways To Contribute](#ways-to-contribute)
- [Before You Begin](#before-you-begin)
- [Development Setup](#development-setup)
- [Change Requirements](#change-requirements)
- [Pull Request Process](#pull-request-process)
- [Release Labels](#release-labels)
- [Branch Workflow](#branch-workflow)
- [Code Of Conduct](#code-of-conduct)
- [Local Quality Gates](#local-quality-gates)

## Ways To Contribute

Useful contributions include:

- Reproducible bug reports involving supported package versions and platforms.
- Focused fixes with regression tests.
- Broadly reusable Foundation helpers and source-compatible API improvements.
- Documentation corrections, examples, and DocC improvements.
- Cross-platform compatibility validation.
- Issue triage and constructive feedback on proposed API.

SwiftFoundationHelpers intentionally remains a focused Foundation companion. Application-specific
business logic and helpers that merely shorten one call without adding reusable behavior are
unlikely to be accepted.

## Before You Begin

Search existing issues, discussions, pull requests, Foundation API, and the Swift standard library
before proposing new public API. Open an issue or discussion before starting a substantial feature,
breaking change, new dependency, or platform-support change. Small corrections and focused bug fixes
do not require advance approval.

Read [AGENTS.md] for implementation and testing expectations and [RELEASE-POLICY.md] for public API
compatibility and versioning rules.

## Development Setup

1. Fork and clone the repository.
2. Create a topic branch from `develop`.
3. Confirm the package resolves and its tests pass:

   ```sh
   swift package resolve
   swift test
   ```

4. Install the repository's pre-commit hooks when contributing regularly:

   ```sh
   pre-commit install --install-hooks
   ```

The package requires the Swift tools version and minimum Apple platform versions declared in
`Package.swift`. Xcode is required for testing Apple-platform destinations not exercised by
`swift test` on the host.

## Change Requirements

- Keep changes focused and avoid unrelated refactoring.
- Preserve source compatibility unless the breaking change is authorized and versioned according
  to [RELEASE-POLICY.md].
- Add or update Swift Testing coverage for public behavior, error paths, and regressions.
- Keep tests isolated from the developer's locale, time zone, filesystem state, and shared
  `UserDefaults` state.
- Add DocC-parsable documentation to new or changed public API.
- Update the README when features, installation, supported platforms, or examples change.
- Update references and source attribution when an implementation derives from external guidance.
- Do not add a dependency unless its durable value, license, security posture, and platform support
  justify it.
- Do not commit credentials, private data, build products, package caches, or local Xcode state.

## Pull Request Process

1. Rebase or merge the current `develop` branch into your topic branch as appropriate.
2. Run the local quality gates relevant to the change.
3. Push the complete topic branch and open a pull request into `develop`.
4. Describe the problem, solution, public API and SemVer impact, test evidence, documentation
   changes, and known limitations.
5. Keep review follow-ups in the same focused scope.
6. Merge only after the repository's configured review and status-check requirements pass.

Do not increment a version in source files for an ordinary pull request. Swift Package Manager
release versions are established by immutable `vMAJOR.MINOR.PATCH` Git tags during the maintainer
release process.

## Release Labels

GitHub generates release-note categories from merged pull-request labels. Before merging, apply the
single `release-note:*` label that best describes the change:

- `release-note:breaking-change`
- `release-note:security`
- `release-note:deprecation`
- `release-note:feature`
- `release-note:fix`
- `release-note:compatibility` or `release-note:dependencies`
- `release-note:documentation`
- `release-note:testing` or `release-note:validation`
- `release-note:release-readiness`
- `release-note:maintenance`

Also apply `semver-major`, `semver-minor`, or `semver-patch` when the pull request establishes or
changes the intended release increment. Before 1.0, a breaking change may correctly carry both
`release-note:breaking-change` and `semver-minor` under [RELEASE-POLICY.md].

Use `no-release-notes` only for changes that provide no useful adopter-facing release information.
Do not use it to hide public API, behavior, platform, dependency, security, or migration impact. The
aliases retained in `.github/release.yml` support existing labels and automation, but new pull
requests should prefer the canonical labels above. Maintainers must create referenced labels in the
GitHub repository before relying on them for categorization.

## Branch Workflow

SwiftFoundationHelpers uses GitFlow-style branch roles:

- `feature/*` branches add backward-compatible capability and target `develop`.
- `bugfix/*` branches correct unreleased work or supported behavior and target `develop`.
- `release/*` branches prepare a planned release from `develop` and target `main`.
- `hotfix/*` branches correct the latest stable release from `main` and target `main`.

After a release or hotfix reaches `main`, maintainers synchronize it back into `develop`. Protected
branches remain authoritative; do not push directly to them or rely on a local GitFlow finish
command to bypass GitHub review and required checks.

## Code Of Conduct

All contributors must read and follow our [Code of Conduct] policy in repository interactions and
when representing the project.

## Local Quality Gates

Run the package tests before opening a pull request:

```sh
swift test
```

Run all configured pre-commit checks without modifying the commit history:

```sh
pre-commit run --all-files
```

Review and restage any safe formatting corrections made by autofix-capable hooks.

When a change affects availability or platform-sensitive Foundation behavior, also run the relevant
host and Xcode destinations represented by `.github/workflows/pr.yml` and
`.github/workflows/ci.yml`. Build DocC for public API or documentation changes and resolve
documentation warnings before requesting review.

[AGENTS.md]: AGENTS.md
[Code of Conduct]: CODE_OF_CONDUCT.md
[MIT License]: LICENSE
[RELEASE-POLICY.md]: RELEASE-POLICY.md
