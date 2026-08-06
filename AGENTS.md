# AGENTS.md

This document defines expectations for AI coding agents that generate or edit code and documentation
for the SwiftFoundationHelpers repository. It is written for OpenAI Codex, ChatGPT, and similar
agents working through Git and GitHub.

- [Project Summary](#project-summary)
- [Primary Goals For Agents](#primary-goals-for-agents)
- [Required Behavior](#required-behavior)
- [Package Compatibility](#package-compatibility)
  - [Supported Platforms And Toolchain](#supported-platforms-and-toolchain)
  - [Public API And Semantic Versioning](#public-api-and-semantic-versioning)
- [Swift Style](#swift-style)
  - [Foundation Extension Design](#foundation-extension-design)
  - [Swift Abstraction Grouping](#swift-abstraction-grouping)
- [Architecture Expectations](#architecture-expectations)
- [Determinism, Side Effects, And Security](#determinism-side-effects-and-security)
- [Testing Expectations](#testing-expectations)
  - [Cross-Platform Testing](#cross-platform-testing)
  - [Test Isolation And Determinism](#test-isolation-and-determinism)
- [Documentation Expectations](#documentation-expectations)
- [Git, CI, And Release Expectations](#git-ci-and-release-expectations)
- [Evaluation Checklist](#evaluation-checklist)
- [Preferred Agent Workflow](#preferred-agent-workflow)
- [Non-Goals](#non-goals)

## Project Summary

SwiftFoundationHelpers is a Swift package that complements Foundation with focused extensions and
related reusable abstractions. The package currently extends types such as `Array`, `Bundle`,
`Date`, `Int`, `String`, `URL`, and `UserDefaults`. It is a library, not an application, and uses
Swift Package Manager, Swift Testing, DocC, and GitHub Actions.

The package has no third-party runtime dependencies. Its public API is consumed by downstream apps
and packages, so source compatibility, deterministic behavior, documentation quality, and
cross-platform support are central design constraints.

## Primary Goals For Agents

- Produce clear, idiomatic Swift.
- Prefer small, reviewable commits.
- Keep helpers small, predictable, reusable, and broadly applicable.
- Preserve source compatibility unless a breaking change is explicitly authorized.
- Maintain the package's declared platform support.
- Prefer deterministic behavior over implicit process or device state.
- Add focused Swift Testing coverage for public behavior and error paths.
- Keep public DocC documentation and repository documentation synchronized with the implementation.

## Required Behavior

- Read `Package.swift`, `README.md`, and this file before making changes.
- Read `CONTRIBUTING.md` before changing contribution or branch conventions.
- Read `RELEASE-POLICY.md` before changing public API compatibility, supported platforms,
  versioning, or release automation.
- Add or update tests whenever behavior or the public API changes.
- Keep generated code focused on the requested change.
- Avoid unrelated refactors.
- Avoid unrelated dependencies, generated files, abstractions, and repository-wide rewrites.
- Update DocC comments and README examples when a public API changes.
- Explain material architectural, public-API, and compatibility choices in pull-request
  descriptions.
- Preserve copyright notices, licensing information, and relevant source references.

## Package Compatibility

### Supported Platforms And Toolchain

- Treat `Package.swift` as the source of truth for the Swift tools version, products, targets, and
  minimum platform versions.
- The package currently supports iOS 18, Mac Catalyst 18, macOS 15, tvOS 18, visionOS 2, and
  watchOS 11.
- Do not raise a minimum platform version or Swift tools version unless the change is intentional,
  documented, and tested.
- Use APIs available on every declared platform. When an API is genuinely platform-specific,
  isolate it with the narrowest appropriate availability annotation or conditional compilation.
- Keep public availability annotations aligned with `Package.swift`.
- Verify changes with `swift test`; use the relevant Xcode destinations when behavior or API
  availability may differ across Apple platforms.

### Public API And Semantic Versioning

- Treat every `public` declaration as a supported downstream contract.
- Prefer additive, source-compatible changes. Do not rename, remove, narrow, or change the semantics
  of public API without explicit authorization and an appropriate SemVer plan.
- When replacing a public API, prefer a documented deprecation and a migration path over immediate
  removal.
- Preserve compatibility overloads when they remain part of the supported release line, and add
  tests proving their signatures remain usable.
- Avoid adding public API for a single repository-specific use case; helpers should have clear,
  general Foundation value.
- Avoid names that shadow or conflict with Swift standard-library or Foundation API. If overlap is
  unavoidable, prefer the native API and deprecate the package helper when compatibility permits.
- Classify releases according to `RELEASE-POLICY.md`: fixes are patches, additive public capability
  is minor, and intentional breaking API is major.

## Swift Style

- Use Swift 6 language features supported by the package manifest when they improve clarity or
  safety.
- Use Swift Testing for tests.
- Prefer value types for pure logic.
- Prefer value semantics and pure functions for transformations.
- Prefer throwing APIs that preserve actionable errors over trapping, printing, or silently
  returning a fallback.
- Prefer actors for mutable async state.
- Prefer protocols for services that call Apple frameworks or networks.
- Avoid force unwraps except in tests where failure should be immediate.
- Avoid force casts except in tests where failure should be immediate.
- Keep generic constraints as narrow as the implementation requires.
- Use meaningful argument labels and names that read naturally at the call site.
- Keep lines reasonably short and follow the repository's formatting and lint configuration.
- Use `internal` or `private` by default; expose declarations publicly only when they are intended
  package API.
- Add explicit concurrency annotations only when they express a real isolation or sendability
  guarantee.

### Foundation Extension Design

- Extend a Foundation or standard-library type only when the behavior naturally belongs on that
  type and improves common call sites.
- Prefer methods that return transformed values rather than unexpectedly mutating shared state.
- Make policy inputs explicit when results depend on a `Calendar`, `Locale`, `TimeZone`, codec,
  sorting rule, matching threshold, or file-writing option.
- Preserve Foundation errors from decoding, encoding, URL, bundle-resource, and file operations
  whenever practical.
- Prefer deterministic ordering when converting unordered collections into serialized output,
  query items, or other user-visible results.
- Document complexity or scalability limits for algorithms whose costs are not obvious.
- Do not introduce an extension merely to shorten a single call or duplicate an existing native
  API.

### Swift Abstraction Grouping

Group declarations by API surface and responsibility rather than strict alphabetical order. A good
default order is:

1. Nested types and type aliases.
2. Stored properties, with constants before variables where practical.
3. Computed properties, with public or internal API before private helpers.
4. Initializers.
5. Public or internal methods grouped by behavior, with public or internal behavior before private
   helpers.
6. Static API when it is not clearer beside related instance API.
7. Private helpers.

For extension files, use `// MARK:` sections that reflect behavior, such as initialization,
validation, matching, formatting, queries, encoding, and decoding. Keep deprecated compatibility
overloads adjacent to their replacements when that makes the migration path clearer.

## Architecture Expectations

- Production sources live under `Sources/SwiftFoundationHelpers/`.
- Foundation-type extensions live under `Sources/SwiftFoundationHelpers/Extensions/`, normally one
  primary extended type per file.
- Tests live under `Tests/SwiftFoundationHelpersTests/` and should mirror the production source
  organization.
- Test-only fixtures and resources belong in the test target; do not expose them through the library
  product.
- Keep the production library free of third-party runtime dependencies. Build and documentation
  tooling dependencies require substantial, durable value and must not leak into the library API.
- Prefer a direct implementation over service layers, protocols, factories, or generic abstractions
  that have only one use and no meaningful substitution requirement.
- Add a new source folder or abstraction only when responsibility and reuse justify it.

## Determinism, Side Effects, And Security

- Do not make new APIs depend implicitly on the current date, locale, calendar, time zone, process
  environment, filesystem layout, or shared `UserDefaults` when callers may need deterministic
  results.
- Make file reads and writes explicit, propagate failures, and use atomic writes by default when
  replacing file contents.
- Do not print from new library APIs. Return values or throw errors so callers control diagnostics.
- Never log or expose secrets, authentication values, private file contents, or sensitive
  `UserDefaults` values.
- Do not add telemetry, networking, persistence services, or global mutable state without explicit
  scope and documentation.
- Validate untrusted strings, URLs, regular expressions, resource names, and decoded data at the
  narrowest useful boundary.
- Avoid APIs whose convenience obscures destructive file operations or unsafe storage behavior.

## Testing Expectations

- Use Swift Testing for new tests and preserve or improve existing coverage.
- Give each production extension a matching test suite and file.
- Test public behavior, boundary values, empty inputs, malformed inputs, thrown errors, and stable
  ordering where applicable.
- Add source-compatibility tests for retained deprecated overloads and function signatures.
- Use parameterized tests when one behavior should be exercised over a concise table of inputs.
- Prefer direct assertions over trivial wrapper helpers.
- Do not remove tests unless replacing them with equal or stronger coverage.
- Run `swift test` for every source or test change.

### Cross-Platform Testing

- Keep tests compatible with every platform declared in `Package.swift` unless a test covers a
  deliberately platform-specific API.
- Avoid assumptions about simulator device names, host paths, path separators, locale, time zone,
  or filesystem ordering.
- When availability or Foundation behavior may vary, run the relevant host and Xcode destinations
  represented by `.github/workflows/pr.yml` and `.github/workflows/ci.yml`.
- Do not weaken supported-platform coverage merely to make one hosted runner pass.

### Test Isolation And Determinism

- Inject fixed calendars, locales, time zones, dates, encoders, and decoders into tests when output
  depends on them.
- Use `Bundle.module` for SwiftPM test resources.
- Give temporary files unique names, clean them up, and avoid assumptions about the global temporary
  directory's prior contents.
- Use isolated `UserDefaults` suites for tests that read or write defaults, and remove the suite's
  persistent domain during cleanup.
- Avoid test ordering dependencies and shared mutable fixtures.
- Assert deterministic ordering explicitly for dictionary-derived query items and serialized data.

## Documentation Expectations

- Add DocC-parsable documentation to every public declaration.
- Document parameters, return values, thrown errors, availability, side effects, complexity, and
  important edge cases where applicable.
- Keep examples compilable, concise, deterministic, and consistent with the current API.
- Update `README.md` when installation, supported platforms, public features, or usage changes.
- Update `REFERENCES.md` or source reference comments when implementation guidance or attribution
  changes.
- Update `RELEASE-POLICY.md`, release notes, and migration guidance when compatibility policy or
  public API changes.
- Do not describe application-specific behavior, UI, distribution, or infrastructure concerns
  outside this package's actual scope.

## Git, CI, And Release Expectations

- Use descriptive GitFlow-aligned branch names: `feature/`, `bugfix/`, `release/`, or `hotfix/` as
  appropriate.
- Use concise conventional commit messages that describe the affected package behavior.
- Keep pull requests focused and include test evidence plus public-API compatibility notes.
- Keep active GitHub Actions workflows aligned with SwiftPM linting, testing, DocC publication,
  release preparation, and tag-based publishing.
- Do not commit secrets, credentials, signing material, build products, or local SwiftPM/Xcode
  state.
- Use SemVer tags in the form `v<MAJOR>.<MINOR>.<PATCH>`.
- Before release, verify the tag, release notes, supported-platform tests, documentation, and public
  API compatibility all describe the same source revision.

## Evaluation Checklist

Use this checklist when reviewing generated code or documentation:

- Does the package build and do its tests pass?
- Does the change compile for every affected supported platform?
- Is the API broadly useful and naturally located on the extended type?
- Is public API source-compatible, or is the SemVer impact explicit and authorized?
- Are availability annotations and minimum platforms preserved?
- Are locale, calendar, time-zone, ordering, and filesystem behaviors deterministic where needed?
- Are errors propagated without trapping, unsolicited printing, or silent data loss?
- Does every behavior change have focused Swift Testing coverage?
- Is every public declaration documented with accurate DocC comments?
- Does the change avoid unnecessary dependencies, abstractions, and side effects?
- Does it avoid secrets, sensitive output, and unsafe file or defaults behavior?
- Are README, references, release notes, and CI updated when applicable?

## Preferred Agent Workflow

1. Inspect `Package.swift`, the relevant source, its matching tests, and related documentation.
2. State the intended behavior and compatibility impact briefly.
3. Make the smallest viable implementation and documentation changes.
4. Add or update deterministic tests.
5. Run `swift test` and any affected platform, lint, or DocC validation.
6. Summarize the change, compatibility impact, verification evidence, and remaining work.

## Non-Goals

- Do not turn SwiftFoundationHelpers into an application or UI framework.
- Do not duplicate Foundation or Swift standard-library API without a clear compatibility reason.
- Do not add app-specific models, settings, workflows, or business rules.
- Do not introduce networking, telemetry, databases, or persistent background services as generic
  conveniences.
- Do not add speculative abstractions, dependencies, or helpers without demonstrated reusable
  value.
