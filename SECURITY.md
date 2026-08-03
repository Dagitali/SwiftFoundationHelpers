# Security Policy

Thank you for helping to keep SwiftFoundationHelpers and its consumers safe.

- [Supported Versions](#supported-versions)
- [Security Scope](#security-scope)
  - [In Scope](#in-scope)
  - [Consumer Responsibilities](#consumer-responsibilities)
- [Reporting A Vulnerability](#reporting-a-vulnerability)
  - [What To Include](#what-to-include)
  - [Protect Sensitive Information](#protect-sensitive-information)
- [Response And Coordination](#response-and-coordination)
- [Coordinated Disclosure](#coordinated-disclosure)
- [Security Releases](#security-releases)

## Supported Versions

The latest stable release line receives security support unless the repository explicitly documents
additional supported lines. Security fixes and backports for older releases are best effort and are
not guaranteed. Development branches and prerelease versions are provided for evaluation and are
not supported as stable production releases.

See [RELEASE-POLICY.md] for the complete release and compatibility policy.

## Security Scope

The supported security surface includes the current stable package source, its documented public
behavior, and repository infrastructure capable of compromising consumers or published releases.
Historical versions receive fixes only as described under Supported Versions, but a report involving
internal implementation is still relevant when it affects a supported release.

### In Scope

Security reports are appropriate for vulnerabilities in:

- Source distributed by the `SwiftFoundationHelpers` library product.
- Public helpers that validate or transform URLs, file paths, encoded data, or other potentially
  untrusted input.
- File, bundle, JSON, and `UserDefaults` helpers when package behavior could expose, overwrite, or
  mishandle consumer data unexpectedly.
- Package manifests, dependencies, or build and release automation when a weakness could compromise
  consumers, source tags, documentation, or published releases.
- Documentation that instructs consumers to use the package in a materially unsafe way.

The package has no hosted runtime service and does not independently collect analytics or consumer
data. Some APIs read or write files, URLs, bundles, or preferences when explicitly invoked by a
consumer.

Security defects in Swift, Foundation, supported operating systems, GitHub, or Swift Package Manager
should normally be reported to the responsible vendor. Please also notify the SwiftFoundationHelpers
maintainers privately when package behavior exposes or amplifies the issue.

### Consumer Responsibilities

Consumers remain responsible for applying platform security controls around package APIs. In
particular:

- Treat remote content, file paths, URLs, decoded data, and persisted values as untrusted when their
  origin is not controlled.
- Grant only the filesystem, network, sandbox, and process permissions required by the consuming
  application or tool.
- Do not store passwords, authentication tokens, cryptographic keys, or similarly sensitive values
  in `UserDefaults` merely because a convenience API is available.
- Use supported package and platform versions and review release notes before upgrading.

These responsibilities do not exclude a package defect from security consideration.

## Reporting A Vulnerability

If you discover a security vulnerability in SwiftFoundationHelpers, please report it responsibly:

- **Do not** open a public issue, discussion, or pull request for a suspected vulnerability.
- Report it privately by emailing [security@dagitali.com]. If that channel is unavailable, use
  another private maintainer contact published by the repository.

Ordinary bugs, feature requests, and usage questions that do not involve sensitive security details
may be reported through the repository's public [issue tracker].

### What To Include

Provide enough information to reproduce and assess the report when it is safe to do so:

- The affected package version, Git tag, commit, platform, and Swift version.
- The affected API, file, workflow, or documentation.
- Reproduction steps or a minimal proof of concept.
- The expected and observed behavior.
- The likely impact and any known prerequisites or mitigations.
- Relevant logs, stack traces, or test output after removing secrets and private data.
- Whether the vulnerability is already public or has been reported elsewhere.

### Protect Sensitive Information

Do not send production credentials, access tokens, private keys, signing material, personal data, or
unredacted consumer files. Use synthetic test data wherever possible. Maintainers will avoid asking
for information that is not necessary to reproduce or assess the report.

## Response And Coordination

Maintainers aim to acknowledge a report within three business days. This is a best-effort response
target, not a service-level agreement.

After acknowledging a report, maintainers will ordinarily:

1. Confirm a private communication channel and request only necessary follow-up information.
2. Reproduce and assess the affected versions, impact, severity, and exposure.
3. Develop and test a fix or document a mitigation.
4. Coordinate a release and disclosure timeline with the reporter when practical.
5. Publish an advisory and reporter credit when appropriate and authorized.

Response and release timing depends on reproducibility, severity, fix complexity, platform-vendor
coordination, and whether disclosure would increase risk before a fix is available.

## Coordinated Disclosure

Please allow maintainers a reasonable opportunity to investigate, remediate, and publish a safe
release before public disclosure. Do not publish exploit details, open a public pull request, or
announce an unpatched vulnerability while coordination is active.

Maintainers will not intentionally delay disclosure after a fix is available. If the project and
reporter cannot agree on timing, both parties should prioritize reducing harm to consumers and
clearly communicate their intended next steps.

## Security Releases

Security fixes follow [RELEASE-POLICY.md] and use the smallest compatible version increment that
fully resolves the vulnerability. Published release tags are immutable; a compromised or incomplete
release is corrected with a new version rather than by moving an existing tag.

When appropriate, a security release includes:

- A tested fix and regression coverage.
- A GitHub Security Advisory or equivalent public notice after coordinated disclosure.
- Affected and fixed version ranges.
- Upgrade or mitigation instructions.
- Impact details sufficient for consumers to assess exposure without unnecessarily enabling abuse.
- Reporter credit when requested and authorized.

[issue tracker]: https://github.com/Dagitali/SwiftFoundationHelpers/issues
[RELEASE-POLICY.md]: RELEASE-POLICY.md
[security@dagitali.com]: mailto:security@dagitali.com
