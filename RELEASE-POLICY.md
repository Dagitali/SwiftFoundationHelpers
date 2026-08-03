# Release Policy And Versioning

This document defines how SwiftFoundationHelpers versions, supports, and publishes its Swift
Package Manager source releases.

- [Supported Releases](#supported-releases)
- [Versioning](#versioning)
  - [Patch Releases](#patch-releases)
  - [Minor Releases](#minor-releases)
  - [Major Releases](#major-releases)
  - [Pre-1.0 And Prerelease Versions](#pre-10-and-prerelease-versions)
- [Compatibility](#compatibility)
  - [Public API](#public-api)
  - [Documented Behavior](#documented-behavior)
  - [Platforms And Swift Toolchains](#platforms-and-swift-toolchains)
  - [Dependencies](#dependencies)
- [Deprecation And Removal](#deprecation-and-removal)
- [Security Releases](#security-releases)
- [Release Branches And Tags](#release-branches-and-tags)
- [Distribution And Release Artifacts](#distribution-and-release-artifacts)
- [Release Notes](#release-notes)

## Supported Releases

The latest stable release line is the supported public line unless the repository explicitly
documents additional supported lines. Fixes and security backports to older lines are best effort
and are not guaranteed.

The supported contract consists of public API and documented behavior in a stable tagged release.
Internal implementation details, experimental code, historical files, and undocumented behavior
are not compatibility commitments.

## Versioning

SwiftFoundationHelpers follows [Semantic Versioning 2.0.0] for stable releases. A release version
has the form `MAJOR.MINOR.PATCH`, and its Git tag has the form `vMAJOR.MINOR.PATCH`, where:

- `MAJOR` releases are for intentionally breaking public changes
- `MINOR` releases add backward-compatible public capability
- `PATCH` releases are for backward-compatible fixes and release-hygiene corrections

### Patch Releases

A patch release may contain:

- Backward-compatible bug, correctness, performance, or security fixes.
- Documentation, test, CI, or release-automation corrections.
- Compatibility fixes that preserve supported public API and documented behavior.

A patch release must not intentionally add, remove, or incompatibly change public API. A fix may
correct broken or undocumented behavior, but release notes must identify any observable impact.

### Minor Releases

A minor release may contain:

- Backward-compatible public API additions.
- New documented capabilities or supported platforms.
- Deprecations that retain a working compatibility path.
- Additive configuration or behavior that preserves existing supported use.

New public API must include appropriate tests and DocC documentation.

### Major Releases

A major release is required after 1.0 for intentional source-incompatible or behaviorally
incompatible changes, including:

- Removing or renaming public API.
- Changing public signatures, generic constraints, conformances, or documented semantics in an
  incompatible way.
- Dropping a supported platform or raising a minimum platform or Swift tools version in a way that
  excludes supported clients.

Major releases must explain the breaking changes and provide migration guidance when a practical
migration path exists.

### Pre-1.0 And Prerelease Versions

Before 1.0, an increment to `MINOR` may contain breaking public API changes. Patch releases within
the same pre-1.0 minor line remain backward compatible under this policy. Breaking pre-1.0 changes
must still be intentional, documented, and accompanied by migration guidance when practical.

Prerelease versions use a Semantic Versioning suffix, such as `v1.0.0-beta.1`. They are intended
for evaluation, may change before the corresponding stable release, and do not replace the latest
stable supported line.

## Compatibility

### Public API

Public declarations exported by the `SwiftFoundationHelpers` library product are the package's
source-level API. Changes should remain source compatible within a stable release line unless the
versioning rules above explicitly permit otherwise.

The package is distributed as source through Swift Package Manager. It does not promise binary
framework compatibility or library-evolution compatibility unless a future release explicitly
introduces and documents such a distribution model.

### Documented Behavior

Documented results, error behavior, normalization rules, and side effects are part of the public
contract even when a function signature does not change. Fixes should remain deterministic across
supported platforms, locales, calendars, and time zones unless platform-specific behavior is
explicitly documented.

### Platforms And Swift Toolchains

`Package.swift` is the source of truth for supported platforms and the minimum Swift tools version.
Adding a supported platform is normally additive. Dropping a platform or raising a minimum version
is a compatibility change and must be versioned and documented accordingly.

A newer compiler or SDK may be used in CI without changing the declared minimums. Each release must
still build and test against the repository's declared support matrix.

### Dependencies

SwiftFoundationHelpers prefers Foundation and the standard library over third-party runtime
dependencies. Adding or materially changing a dependency requires an intentional release decision,
license and security review, supported-platform verification, and release-note disclosure. A new
runtime dependency is at least a minor change unless it also creates a breaking compatibility
change.

## Deprecation And Removal

When replacing public API, introduce the replacement and deprecate the old API in a compatible
release whenever practical. Deprecation messages should name the replacement or explain the
migration.

After 1.0, deprecated API remains available until a later major release. Before 1.0, deprecated API
should remain available through at least the remainder of its minor release line and should normally
be removed only in a later minor release. Tests should preserve deprecated compatibility paths while
they remain supported.

Immediate removal is reserved for exceptional security or legal requirements, or for unusable
accidental API. The release notes must explain the exception and its migration impact.

## Security Releases

Security reports and coordinated disclosure follow [SECURITY.md]. A security fix should use the
smallest compatible version increment that resolves the vulnerability. If a safe fix necessarily
breaks compatibility, the release may use the next version permitted by this policy and must explain
the migration without disclosing exploit details prematurely.

The project does not guarantee security backports beyond the supported release line.

## Release Branches And Tags

Planned releases use `release/vMAJOR.MINOR.PATCH` branches created from `develop`. Urgent fixes to
the latest stable release use `hotfix/vMAJOR.MINOR.PATCH` branches created from `main`. Release and
hotfix changes merge into `main` and then back into `develop` through the protected pull-request
workflow.

An annotated `vMAJOR.MINOR.PATCH` tag identifies the exact released commit and is the canonical
version selected by Swift Package Manager. Published tags are immutable: never move, delete, or
reuse a released version tag to correct a release. Publish a new version instead.

## Distribution And Release Artifacts

SwiftFoundationHelpers is distributed as tagged source through Swift Package Manager. A stable
release consists of:

- The immutable annotated version tag and its tagged source.
- A GitHub Release with accurate release notes.
- The package manifest, library sources, tests, license, and public documentation in the tagged
  commit.
- Published DocC documentation when the documentation workflow supports it.

Generated build output and local SwiftPM caches are not release artifacts.

## Release Notes

Release notes cover the complete change set since the previous stable tag, not only the final
release-preparation commit. They should identify:

- User-visible additions and fixes.
- Public API additions, deprecations, removals, and migration steps.
- Behavior, platform, Swift tools version, or dependency changes.
- Security fixes and reporter credit when coordinated disclosure permits it.
- Known compatibility limitations or follow-up work relevant to adopters.

[Semantic Versioning 2.0.0]: https://semver.org/spec/v2.0.0.html
[SECURITY.md]: SECURITY.md
