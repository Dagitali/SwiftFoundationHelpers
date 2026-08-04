# Release Notes Template

Use this template when drafting release notes for tagged SwiftFoundationHelpers releases. GitHub
Releases is the canonical release-history surface for the project when the repository is hosted on
GitHub.

- [Breaking Changes](#breaking-changes)
- [Highlights](#highlights)
- [Fixes](#fixes)
- [New Features](#new-features)
- [Compatibility And Dependencies](#compatibility-and-dependencies)
- [Deprecations](#deprecations)
- [Documentation](#documentation)
- [Validation And Testing](#validation-and-testing)
- [Release And Distribution](#release-and-distribution)
- [Maintenance](#maintenance)
- [Security](#security)
- [Upgrade Notes](#upgrade-notes)
- [Support Boundary](#support-boundary)
- [Notes For Maintainers](#notes-for-maintainers)

## Breaking Changes

- List any breaking change explicitly.
- Include migration guidance or link to it.
- If none, write `None.`

## Highlights

- Summarize the most important user-visible changes in 2-5 bullets.
- Focus on what users can now do, what became more reliable, or what changed in support
  expectations.

## Fixes

- Summarize the most important bug fixes.
- Prefer behavior-focused language over internal implementation detail.
- If none, write `None.`

## New Features

- Describe backward-compatible public API additions and new supported capabilities.
- Call out important availability constraints.
- If none, write `None.`

## Compatibility And Dependencies

- Identify changes to supported platforms, Swift tools, dependencies, or documented behavior.
- State whether downstream source changes are required.
- If none, write `None.`

## Deprecations

- List newly deprecated APIs or supported behaviors and name their replacements.
- If none, write `None.`

## Documentation

- Summarize meaningful README, DocC, example, or support-documentation changes.
- If none, write `None.`

## Validation And Testing

- Record meaningful coverage, cross-platform validation, or release-gate improvements.
- If none, write `None.`

## Release And Distribution

- Describe changes to tagging, publishing, artifacts, or release automation that affect adopters.
- If none, write `None.`

## Maintenance

- Summarize important CI, tooling, refactoring, or contributor-workflow changes.
- If none, write `None.`

## Security

- Summarize security fixes when coordinated disclosure permits it.
- Do not publish exploit details or reporter information prematurely.
- If none, write `None.`

## Upgrade Notes

- Mention any required user action, dependency change, migration step, or compatibility expectation.
- If nothing special is required, write `No special upgrade steps.`

## Support Boundary

- Re-state any release-specific support or stability caveats when needed.
- Keep the message aligned with [README] and [SUPPORT].

## Notes For Maintainers

- Cross-check generated GitHub release notes against this template.
- Ensure breaking changes, security considerations, deprecations, and migration guidance are never
  left only in generated summaries.
- Keep terminology consistent with the documented stable surface in the README.

[README]: ../README.md
[SUPPORT]: ../SUPPORT.md
