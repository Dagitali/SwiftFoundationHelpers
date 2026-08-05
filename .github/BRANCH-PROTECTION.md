# Branch Protection

This document defines the recommended GitHub branch protection configuration for protected
integration branches when SwiftFoundationHelpers is operated with GitFlow.

- [Purpose](#purpose)
- [GitFlow Branch Rules](#gitflow-branch-rules)
- [Recommended Required Checks](#recommended-required-checks)
  - [Pull Request Baseline](#pull-request-baseline)
    - [Policy Categories](#policy-categories)
    - [Current Required Check Names To Select In GitHub](#current-required-check-names-to-select-in-github)
  - [Advisory Categories](#advisory-categories)
  - [Current Advisory Examples](#current-advisory-examples)
- [Shared Protection Baseline](#shared-protection-baseline)
- [Default Branch](#default-branch)
- [Development Branch](#development-branch)
- [How To Disallow Direct Pushes](#how-to-disallow-direct-pushes)
- [How To Update Required Checks](#how-to-update-required-checks)
- [Maintenance Notes](#maintenance-notes)

## Purpose

Branch protections exist to enforce three repository policies:

- No direct pushes to protected integration branches
- No merge into protected branches without review
- No merge into protected branches unless required validation checks pass

Local hooks can complement this policy, but GitHub branch protection is the authoritative enforcement
layer when this repository is hosted on GitHub.

## GitFlow Branch Rules

SwiftFoundationHelpers uses GitFlow with hosted pull requests as the authoritative integration path.

Allowed branch roles:

- `feature/*`: Normal feature, enhancement, documentation, and release-readiness work. Target
  `develop`.
- `bugfix/*`: Non-emergency fixes and patch-level hardening before release. Target `develop`.
- `release/*`: Release stabilization and version promotion. Branch from `develop` and target
  `main`.
- `hotfix/*`: Urgent fixes for the currently released line. Branch from `main` and target `main`.

Rules:

- Do not push directly to `main` or `develop`.
- Do not use `git flow finish` to merge local work into protected integration branches.
- Merge working branches through GitHub pull requests after required checks and review requirements
  pass.
- After a `release/*` or `hotfix/*` branch lands on `main`, sync `main` back into `develop` through
  a pull request.

## Recommended Required Checks

Use this required-check baseline for protected branches that accept pull requests.

If workflow jobs use a matrix, GitHub exposes expanded matrix job names in branch protection
settings rather than the template names shown in workflow YAML. Select those expanded names when
configuring required checks.

The current workflow model is staged:

- `.github/workflows/pr.yml` provides the required pull-request baseline and `merge_group` coverage
  used by merge queue.
- `.github/workflows/ci.yml` provides broader macOS and iOS Simulator build validation.
- `.github/workflows/sbom.yml` provides release-review source and asset inventory artifacts.

That means branch protection should distinguish between the minimum merge gate that always runs and
broader validation jobs that may remain advisory until the team chooses to require them.

### Pull Request Baseline

Use this baseline for protected-branch merge gates. It covers the checks that should always run for
pull request validation.

#### Policy Categories

- GitFlow target-branch enforcement for pull requests
- Repository hygiene checks through pre-commit
- Swift formatting checks for changed Swift files
- Static analysis through `xcodebuild analyze`
- Unsigned macOS and iOS Simulator source builds and tests through `xcodebuild`
- Test result and coverage artifact upload

These categories define the minimum merge gate for protected branches.

#### Current Required Check Names To Select In GitHub

When configuring `main` or `develop` branch protection rules in the GitHub UI, select these PR-gate
job names as the minimum required checks:

- `Guard PR target branch`: The GitHub Actions job in `.github/workflows/pr.yml` that enforces
  GitFlow pull request target rules.
- `Repository Hygiene`: The GitHub Actions job in `.github/workflows/pr.yml` that runs repository
  hygiene checks through pre-commit.
- `Swift Format`: The GitHub Actions job in `.github/workflows/pr.yml` that runs `swift-format`
  against changed Swift files with the repository's `.swift-format` configuration.
- `Platform Build And Test (macOS)`: The GitHub Actions matrix job in
  `.github/workflows/pr.yml` that builds and tests the macOS destination without code signing.
- `Platform Build And Test (iOS Simulator)`: The GitHub Actions matrix job in
  `.github/workflows/pr.yml` that builds and tests the iOS Simulator destination without code
  signing.
- `Static Analysis`: The GitHub Actions job in `.github/workflows/pr.yml` that runs `xcodebuild
  analyze` on a macOS runner.

Recommended local evidence for pull request descriptions:

- Target-branch policy checks
- Repository hygiene, linting, or formatting checks
  - `pre-commit run --all-files` when workflow, YAML, Markdown, repository metadata, or hook-covered
  files change.
- Tests for changed behavior
  - Relevant `xcodebuild build` or `xcodebuild test` command output.
  - Manual validation notes for release-readiness checks that cannot run in CI, such as App Store
  Connect, CloudKit production, or real-device privacy flows.
- Documentation checks when documentation is part of the supported surface

### Advisory Categories

Additional checks are still useful, and they can be made required when their signal is strong enough
to block protected-branch updates.

Common advisory categories include:

- Full-tree Swift formatting checks, until existing source-formatting drift is cleaned up enough to
  make them protected-branch gates.
- Additional platform build destinations beyond macOS and iOS Simulator
- Release-review source and asset inventory artifacts
- Additional runtime or platform test jobs
- Expanded documentation validation
- Release or packaging validation
- Security scanning

### Current Advisory Examples

The current advisory checks include:

- `Build macOS`
- `Build iOS Simulator`
- `Generate source inventory SBOM`

The `CI` and `SBOM` workflow jobs can be made required later if the team wants broader build and
release-inventory validation to block protected-branch merges.

## Shared Protection Baseline

Apply this baseline to protected branches:

- Require a pull request before merging
- Require at least one approval
- Require Code Owners review for owned paths when GitHub can assign it
- Dismiss stale approvals when new commits are pushed
- Require conversation resolution before merging
- Require status checks to pass before merging
- Require branches to be up to date before merging
- If merge queue is enabled, keep workflow triggers aligned so the same checks run for queued merges
- Block force pushes
- Block branch deletion
- Keep bypass actors empty if possible; restrict it to a very small maintainer/admin set if
  necessary

In GitHub, these controls are typically split across rulesets or branch protection settings for
pull requests, status checks, force pushes, deletions, and bypass actors.

## Default Branch

Target branch: `main`

Purpose:

- Authoritative released history.
- Release and hotfix pull request target.
- Source for annotated public release tags.

Required protections:

- Require pull requests; release and hotfix changes should come from `release/*` or `hotfix/*`
  branches.
- Require at least one approval before merge.
- Require Code Owners review for governance, workflow, security, release, and App Store metadata
  paths when practical.
- Require the current Pull Request (PR) Gates baseline checks.
- Require branch to be up to date before merge.
- Require conversation resolution before merge.
- Block direct pushes, force pushes, and branch deletion.
- Keep bypass actors empty unless a narrowly documented maintainer/admin exception is necessary.

Recommended review expectations:

- Release pull requests should include version, tag annotation, test evidence, and release-readiness
  notes.
- Hotfix pull requests should explain user impact, affected release line, validation evidence, and
  the follow-up sync plan back to `develop`.

Recommended additions:

- Consider requiring signed commits
- Consider requiring merge queue when concurrent release updates are common

## Development Branch

Target branch: `develop`

Purpose:

- Protected integration branch for work that is not yet released.
- Default target for `feature/*` and `bugfix/*` pull requests.
- Source branch for `release/*` branches.

Required protections:

- Require pull requests; feature, bugfix, and sync changes should come from topic branches.
- Require at least one approval, or document and configure a solo-maintainer exception deliberately.
- Require Code Owners review for sensitive paths when practical.
- Require the current Pull Request (PR) Gates baseline checks.
- Require branch to be up to date before merge.
- Require conversation resolution before merge.
- Block direct pushes, force pushes, and branch deletion.

Recommended review expectations:

- Feature and bugfix pull requests should stay small enough to review.
- Pull requests should include test evidence and note intentional gaps.
- UI changes should include screenshots when practical.
- Documentation, workflow, privacy, licensing, and release-readiness changes should update the
  relevant repository docs in the same pull request.

Recommended additions:

- Consider requiring merge queue when concurrent integration work makes merge-order conflicts common


## How To Disallow Direct Pushes

The reliable way to disallow direct pushes is to protect the branch and require
pull requests. CI alone cannot block a normal direct push after the fact,
because GitHub Actions runs only after the push exists.

In GitHub:

1. Open repository `Settings`.
2. Open `Branches`.
3. Open the branch protection rule for the protected branch.
4. Enable `Require a pull request before merging`.
5. Enable `Require status checks to pass before merging`.
6. Enable `Require branches to be up to date before merging`.
7. Enable `Block force pushes`.
8. Enable `Block deletions`.
9. Remove bypass actors unless there is a strict operational need.

## How To Update Required Checks

After workflow job names change, update protected-branch rules so required checks match the current
workflow job names.

In GitHub:

1. Open repository `Settings`.
2. Open `Branches`.
3. Open the branch protection rule for the protected branch.
4. Under `Require status checks to pass`, remove stale check names.
5. Add the current required checks:
   - `Guard PR target branch`
   - `Repository Hygiene`
   - `Swift Format`
   - `Platform Build And Test (macOS)`
   - `Platform Build And Test (iOS Simulator)`
   - `Static Analysis`
6. Optionally add advisory checks if they should block protected-branch merges:
   - `Build macOS`
   - `Build iOS Simulator`
   - `Generate source inventory SBOM`
7. Save the branch protection rule.
8. Repeat the same status-check set for other protected branches unless they intentionally use a
   different policy.

## Maintenance Notes

- Keep this file aligned with the repository workflow files.
- Keep branch-target guidance aligned with `.github/MAINTAINER-RUNBOOKS.md` and `CONTRIBUTING.md`.
- Update required check names whenever workflow job names change.
- Treat version-specific and platform-specific check names as current examples, not permanent
  policy.
- Keep `merge_group` triggers aligned with required checks if merge queue is enabled.
