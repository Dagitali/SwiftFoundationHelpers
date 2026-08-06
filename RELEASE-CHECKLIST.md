# SwiftFoundationHelpers Release Checklist And Stable-Line Maintenance

Use this checklist to prepare, publish, and maintain SwiftFoundationHelpers releases distributed as
tagged source through Swift Package Manager.

- [Release Scope](#release-scope)
- [Pre-Release](#pre-release)
  - [Version And Compatibility](#version-and-compatibility)
  - [Package Structure And Public API](#package-structure-and-public-api)
  - [Tests And Quality](#tests-and-quality)
  - [Documentation And Security](#documentation-and-security)
- [GitFlow Release Branch](#gitflow-release-branch)
- [Release Candidate Verification](#release-candidate-verification)
- [Release](#release)
- [Post-Release](#post-release)
- [Stable-Line Maintenance](#stable-line-maintenance)

## Release Scope

- [ ] Confirm the intended release scope and SemVer version.
- [ ] Confirm the release is patch, minor, or major according to [RELEASE-POLICY.md].
- [ ] Review every commit since the latest stable tag and ensure the release notes cover the full
  change set.
- [ ] Identify all public API additions, deprecations, semantic changes, removals, and platform or
  toolchain changes.
- [ ] Confirm no unrelated or unfinished work is included in the candidate.
- [ ] Record known limitations and intentionally deferred work in the release notes or tracking
  issues.

## Pre-Release

### Version And Compatibility

- [ ] Confirm the candidate version is greater than the latest `v<MAJOR>.<MINOR>.<PATCH>` tag and
  has not already been used.
- [ ] Verify patch releases contain no intentional public API additions or breaking changes.
- [ ] For releases at or after 1.0, verify minor releases are backward compatible and document all
  additive public capability.
- [ ] During pre-1.0 development, verify patch releases remain compatible within their minor line;
  document any breaking minor-release change and provide practical migration guidance.
- [ ] For major releases, document every breaking change and provide practical migration
  guidance.
- [ ] Preserve supported deprecated API for at least the period described in [RELEASE-POLICY.md]
  unless an approved security, legal, or correctness exception applies.
- [ ] Compare the candidate's public API with the latest stable tag and investigate every reported
  breaking change.
- [ ] Confirm retained compatibility overloads still compile through their source-compatibility
  tests.

### Package Structure And Public API

- [ ] Confirm `Package.swift` declares the intended Swift tools version, package name, library
  product, targets, resources, and minimum platforms.
- [ ] Confirm the package still supports iOS 18, Mac Catalyst 18, macOS 15, tvOS 18, visionOS 2,
  and watchOS 11 unless the release intentionally and explicitly changes support.
- [ ] Confirm public availability annotations agree with the platform declarations in
  `Package.swift`.
- [ ] Run `swift package describe` and verify the package graph contains only the intended product,
  targets, dependencies, and resources.
- [ ] Confirm production sources remain under `Sources/SwiftFoundationHelpers/` and tests remain
  under `Tests/SwiftFoundationHelpersTests/`.
- [ ] Confirm each new production extension has an appropriately named matching test suite.
- [ ] Confirm no test fixture or test resource is exposed through the library product.
- [ ] Confirm no unnecessary runtime dependency, generated artifact, or local SwiftPM/Xcode state
  is included.
- [ ] Review new public names against Swift's API Design Guidelines and existing Foundation and
  standard-library APIs to avoid conflicts or duplication.
- [ ] Confirm every public declaration has accurate DocC-parsable documentation.

### Tests And Quality

- [ ] Run `swift test` from a clean package checkout.
- [ ] Run the active pre-commit hooks or the equivalent lint workflow over all tracked files.
- [ ] Confirm all required GitHub Actions checks pass for the immutable candidate commit.
- [ ] Run the host-test and Apple-platform build-and-test matrices represented by
  `.github/workflows/pr.yml` and `.github/workflows/ci.yml` when the release changes source,
  availability, the package manifest, or platform-sensitive behavior.
- [ ] Confirm every host and Apple-platform test destination publishes a nonempty coverage report.
- [ ] Confirm tests cover normal behavior, boundaries, empty input, malformed input, thrown errors,
  and deterministic ordering where applicable.
- [ ] Confirm date and formatting tests use explicit calendars, locales, and time zones.
- [ ] Confirm file tests use isolated temporary files and clean up their artifacts.
- [ ] Confirm `UserDefaults` tests use isolated suites and do not depend on process-wide state.
- [ ] Confirm tests do not depend on execution order, host paths, filesystem ordering, or the
  developer's locale or time zone.
- [ ] Review code coverage for material regressions and add focused tests where public behavior is
  insufficiently exercised.
- [ ] Confirm the build and test logs contain no new warnings.

### Documentation And Security

- [ ] Verify `README.md` accurately describes the package, supported features, installation, and
  current public API.
- [ ] Confirm the README SwiftPM dependency example names the candidate stable version.
- [ ] Verify all README and DocC examples compile conceptually against the candidate API and use no
  removed or renamed symbols.
- [ ] Build the DocC archive and resolve documentation warnings or broken symbol links.
- [ ] Update `REFERENCES.md` and source attribution comments when references or derived
  implementations change.
- [ ] Review [SECURITY.md] and confirm no unresolved security report blocks the release.
- [ ] Confirm source, tests, examples, workflow files, and documentation contain no credentials,
  private keys, tokens, sensitive paths, or private data.
- [ ] Confirm new file, URL, bundle, codec, regular-expression, or `UserDefaults` behavior validates
  untrusted input and does not log sensitive values.
- [ ] Confirm license and copyright notices remain accurate.
- [ ] Draft complete release notes using the categories configured in `.github/release.yml`, and
  review the generated notes before treating the GitHub Release as complete.

## GitFlow Release Branch

- [ ] Create `release/v<MAJOR>.<MINOR>.<PATCH>` from `develop` for a planned release.
- [ ] Create `hotfix/v<MAJOR>.<MINOR>.<PATCH>` from `main` only for an urgent fix to the latest
  stable line.
- [ ] Keep feature and bugfix work out of the release branch unless required to stabilize the
  candidate.
- [ ] Open the release or hotfix pull request into `main`.
- [ ] Include the version, one-sentence tag annotation, release notes, public API compatibility
  assessment, supported-platform evidence, and known follow-ups in the pull request.
- [ ] Require the configured review and status checks before merging.
- [ ] If an active workflow does not trigger automatically for the release or hotfix pull request,
  dispatch it manually against the candidate commit and retain the result.
- [ ] Merge only through the protected GitHub pull-request flow.

## Release Candidate Verification

- [ ] Verify the candidate commit is immutable, pushed, reviewable, and free of uncommitted changes.
- [ ] Record the candidate commit SHA and the latest stable baseline tag.
- [ ] Confirm lint, tests, documentation, and public API review all used the same candidate commit.
- [ ] Confirm `swift package resolve` succeeds without introducing an unexpected `Package.resolved`
  or dependency change.
- [ ] Build the library with `swift build` in a clean checkout.
- [ ] Resolve the candidate from a small downstream Swift package or application and compile a
  representative import and public API call.
- [ ] Verify the proposed tag annotation and release notes summarize the complete release scope,
  not only the most recent commit.
- [ ] Confirm release notes clearly identify deprecations, compatibility considerations, minimum
  platform changes, and migration steps when applicable.
- [ ] Confirm the intended tag will point to the exact commit approved for release.

## Release

- [ ] Merge the approved release or hotfix branch into `main`.
- [ ] Create or verify the annotated `v<MAJOR>.<MINOR>.<PATCH>` tag on the released commit using the
  repository's release workflow.
- [ ] Push the tag once and confirm it resolves to the intended commit.
- [ ] Confirm the tag-triggered publication jobs in `.github/workflows/cd.yml` complete
  successfully.
- [ ] Confirm the GitHub Release uses the correct tag, title, complete release notes, and prerelease
  status; revise incomplete generated notes before declaring the release complete.
- [ ] Confirm the tagged source contains the intended `Package.swift`, sources, tests,
  documentation, and license.
- [ ] Confirm the DocC deployment in `.github/workflows/cd.yml` completes successfully for `main`.

## Post-Release

- [ ] Resolve the public repository URL at the new exact version from a clean downstream package.
- [ ] Build and run a representative downstream use of the released library product.
- [ ] Verify the GitHub Release and tag both point to the released commit.
- [ ] Verify the published DocC site loads and documents the released public API.
- [ ] Verify README workflow, release, documentation, and coverage badges report the expected state.
- [ ] Merge `main` back into `develop` through a pull request after the release or hotfix lands.
- [ ] Close or update release-tracking issues and milestones.
- [ ] Record release follow-ups without rewriting historical tag or release evidence.

## Stable-Line Maintenance

- [ ] Treat the latest stable release line as supported unless project documentation states
  otherwise.
- [ ] Keep public documentation aligned with supported behavior and availability.
- [ ] Review deprecated API before every minor or major release and retain it for the documented
  compatibility period.
- [ ] Reassess minimum platforms and Swift tools versions only as intentional release decisions.
- [ ] Keep PR, CI, CD, release, and SBOM workflows current and mutually consistent.
- [ ] Monitor dependency and GitHub Actions advisories even while the runtime library remains
  dependency-free.
- [ ] Triage security reports according to [SECURITY.md].
- [ ] Never move, recreate, or retag an existing stable version; publish a new patch release for
  corrections.
- [ ] Keep maintainer documentation free of credentials and sensitive operator details.

[RELEASE-POLICY.md]: RELEASE-POLICY.md
[SECURITY.md]: SECURITY.md
