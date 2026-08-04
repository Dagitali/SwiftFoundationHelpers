# SwiftFoundationHelpers Copilot Instructions

Treat `AGENTS.md` as the canonical repository-wide engineering policy. Read the relevant sections of
`Package.swift`, `README.md`, and package documentation before changing behavior.

SwiftFoundationHelpers is a Swift 6 package of focused Foundation and standard-library extensions.
It uses Swift Package Manager, Swift Testing, and DocC and supports the Apple platforms declared in
`Package.swift`.

- [Repository-Wide Expectations](#repository-wide-expectations)
- [Mermaid Diagrams](#mermaid-diagrams)
- [Swift Instructions](#swift-instructions)
|- [Swift Testing Instructions](#swift-testing-instructions)

## Repository-Wide Expectations

- Make the smallest cohesive change that satisfies the request; avoid unrelated refactoring.
- Preserve user-owned changes and never commit secrets, credentials, build products, or local
  SwiftPM or Xcode state.
- Preserve public API source compatibility unless a breaking change and its SemVer impact are
  explicitly authorized.
- Keep helpers deterministic, dependency-free, and broadly useful; make policy inputs such as
  calendars, locales, time zones, codecs, and sorting rules explicit when practical.
- Prefer value types for pure state and protocols only at meaningful service or framework
  boundaries.
- Add or update tests when behavior changes. Do not remove coverage without an equal or stronger
  replacement.
- Update public DocC comments, README examples, release guidance, or CI documentation when the
  corresponding API or behavior changes.
- Preserve file-level and API-level DocC-compatible documentation and existing `// MARK:` structure.
- Keep implementation and tests compatible with every platform declared in `Package.swift`.
- Follow the declaration ordering documented in `AGENTS.md`; do not alphabetize mixed API surfaces
  mechanically.

Path-specific skill guidance lives in `.github/instructions/`.

<!-- mermaid-ai-skills:start -->
## Mermaid Diagrams

When the user asks to create, edit, or visualize a diagram, follow the instructions in
`.github/instructions/mermaid.instructions.md`.
<!-- mermaid-ai-skills:end -->

<!-- swift-ai-skills:start -->
## Swift Instructions

When the user asks to create, edit, or refactor Swift code, follow the instructions in
`.github/instructions/swift.instructions.md`.
<!-- swift-ai-skills:end -->

<!-- swift-testing-ai-skills:start -->
## Swift Testing Instructions

When the user asks to create, edit, or refactor Swift tests, follow the instructions in
`.github/instructions/swift-testing.instructions.md`.
<!-- swift-testing-ai-skills:end -->
