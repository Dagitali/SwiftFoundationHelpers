# Support

This document explains the community support available for SwiftFoundationHelpers and the
information maintainers need to investigate package issues effectively.

- [Support Policy](#support-policy)
- [Supported Versions And Platforms](#supported-versions-and-platforms)
- [Maintenance Expectations](#maintenance-expectations)
- [Where To Get Help](#where-to-get-help)
- [Before Reporting A Problem](#before-reporting-a-problem)
- [What To Include](#what-to-include)
- [Maintenance Priorities](#maintenance-priorities)
- [Response Targets](#response-targets)
- [Compatibility And Deprecation](#compatibility-and-deprecation)
- [Security And Sensitive Information](#security-and-sensitive-information)

## Support Policy

SwiftFoundationHelpers is an open-source Swift package distributed under the [MIT License].
Community support is provided on a best-effort basis unless a separate written agreement states
otherwise. The project does not provide a guaranteed response time or service-level agreement.

## Supported Versions And Platforms

The latest stable release line is the supported public line unless [RELEASE-POLICY.md] explicitly
documents otherwise. Older releases, development branches, and prerelease versions may receive
help, but fixes and backports are not guaranteed.

`Package.swift` is the source of truth for supported Apple platforms and the minimum Swift tools
version. A problem on an undeclared platform, an older toolchain, or an unsupported package version
may still be useful feedback, but it is not necessarily eligible for a compatibility fix.

## Maintenance Expectations

Maintainers prioritize:

- Security reports
- Reproducible defects in supported releases
- Documentation fixes that reduce support load
- Compatibility issues on documented supported platforms

Feature requests and broad design discussions are welcome, but they may not receive the same
response priority as security or correctness issues.

## Where To Get Help

- **API documentation and examples:** Start with the [README] and published [DocC].
- **Usage and design questions:** Use [GitHub Discussions] to ask questions and share examples.
- **Reproducible bugs:** Open a [bug report] using the repository issue form.
- **Feature requests:** Open a [feature request][feature] describing the use case and expected
  public API.
- **Security vulnerabilities:** Follow [SECURITY.md] and use its private reporting channel.

Use a public issue only when the report contains no vulnerability details, credentials, personal
data, or other sensitive information.

## Before Reporting A Problem

Before opening an issue:

1. Review the README, DocC documentation, release notes, and existing issues or discussions.
2. Confirm the problem occurs with the latest stable SwiftFoundationHelpers release.
3. Confirm the consuming package satisfies the platform and Swift tools requirements in
   `Package.swift`.
4. Reproduce the problem after resolving dependencies from a clean package state when practical.
5. Reduce the problem to a small package, test, or code sample that imports
   `SwiftFoundationHelpers` directly.
6. Determine whether the same behavior occurs when using the corresponding Foundation API without
   the package helper.
7. Run `swift test` or the relevant Xcode test destination and retain the complete failure output.

Do not delete a consumer's lockfile or caches without first preserving any dependency state needed
to reproduce the problem.

## What To Include

A useful support request includes:

- The SwiftFoundationHelpers version or Git revision.
- The relevant public API and a minimal reproducible example.
- The expected behavior and the observed behavior.
- The complete compiler, runtime, or test error after removing sensitive information.
- The Swift and Swift tools versions.
- The Xcode version when Xcode is involved.
- The operating system and target platform, including their versions.
- The relevant dependency declaration from `Package.swift`.
- Whether the issue reproduces on another supported platform or package version.
- Whether the behavior is a regression and, if known, the last working version.

Prefer text, source snippets, or a small reproduction repository over screenshots of compiler or
test output. Format code and logs so they remain searchable.

## Maintenance Priorities

Maintainers generally prioritize:

1. Privately reported security vulnerabilities.
2. Reproducible correctness defects in supported releases.
3. Build failures and source-compatibility regressions on supported platforms.
4. Documentation defects that could cause incorrect or unsafe use.
5. Feature requests and broader API design discussions.

Priority does not guarantee acceptance or a delivery date. A proposed feature may be declined when
it duplicates Foundation, expands the package beyond its intended scope, or cannot be supported
consistently across declared platforms.

## Response Targets

These are best-effort targets, not service-level guarantees:

- Security reports: acknowledgement within three business days when submitted through the private
  channel in [SECURITY.md].
- Reproducible bugs and feature requests: initial triage within ten business days.
- Usage questions and documentation discussions: a response within ten business days when
  maintainer availability permits.

Complex reports, upstream platform defects, and cross-platform compatibility investigations may
take longer to resolve.

## Compatibility And Deprecation

Public API compatibility, Semantic Versioning, supported release lines, deprecation periods, and
removal rules are defined in [RELEASE-POLICY.md]. Support responses should not create compatibility
promises that conflict with that policy or with the public API documented for a tagged release.

## Security And Sensitive Information

Suspected vulnerabilities must be reported privately according to [SECURITY.md], not through a
public issue, discussion, or pull request.

Never include credentials, access tokens, private keys, signing material, proprietary source,
personal data, or unredacted consumer files in a support request. Use synthetic inputs and redact
paths, hostnames, account identifiers, and persisted values that are not required to reproduce the
problem.

[bug report]: https://github.com/Dagitali/SwiftFoundationHelpers/issues/new?template=bug_report.yml
[DocC]: https://dagitali.github.io/SwiftFoundationHelpers/documentation/swiftfoundationhelpers/
[feature]: https://github.com/Dagitali/SwiftFoundationHelpers/issues/new?template=feature_request.yml
[GitHub Discussions]: https://github.com/Dagitali/SwiftFoundationHelpers/discussions
[MIT License]: LICENSE
[README]: README.md
[RELEASE-POLICY.md]: RELEASE-POLICY.md
[SECURITY.md]: SECURITY.md
