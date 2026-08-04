---
name: SwiftFoundationHelpers Swift
description: Swift and Foundation practices for SwiftFoundationHelpers package sources.
applyTo: "Sources/**/*.swift"
---
# Swift Instructions

- [Swift](#swift)

## Swift

- Use Swift 6 syntax supported by `Package.swift` when it makes ownership, concurrency, or intent
  clearer.
- Preserve public API source compatibility and the package's declared platform availability unless
  a breaking change is explicitly authorized and documented.
- Prefer concrete value types for pure state and narrow protocols only at boundaries that require
  substitution in tests.
- Do not introduce a protocol for a single value calculation or use generics where one concrete type
  communicates the behavior more clearly.
- Avoid force unwraps and unchecked casts in production code.
- Make behavior deterministic by accepting calendars, locales, time zones, codecs, sorting rules,
  bundles, or defaults suites where appropriate.
- Propagate actionable errors instead of trapping, printing, or silently returning a fallback.
- Add DocC-compatible documentation to every public declaration.
