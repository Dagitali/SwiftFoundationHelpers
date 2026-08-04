---
name: SwiftFoundationHelpers Swift Testing
description: Swift Testing practices for the SwiftFoundationHelpers package.
applyTo: "Tests/**/*.swift"
---
# Swift Testing Instructions

- Use Swift Testing for package tests.
- Name tests as grammatical descriptions of behavior. Avoid repeating the test-suite domain when
  the surrounding suite already supplies that context.
- Prefer parameterized tests for the same behavior across compact input/output cases.
- Inject dates, calendars, locales, time zones, codecs, bundles, and defaults suites when behavior
  otherwise depends on process or device state.
- Test successful behavior, boundary values, malformed input, thrown errors, and deterministic
  ordering where relevant.
- Add source-compatibility coverage for retained deprecated overloads and public signatures.
- Keep tests compatible with every platform declared in `Package.swift` unless they exercise
  deliberately platform-specific behavior.
- Use `Bundle.module` for test resources and isolated suites for `UserDefaults` tests.
- Do not weaken assertions merely to reduce flakiness; remove the race or expose a deterministic
  synchronization boundary.
- Keep temporary-file fixtures isolated and clean them up after each test.
