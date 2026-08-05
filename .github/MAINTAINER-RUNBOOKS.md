# Maintainer Runbooks

Maintainer-facing runbooks for working with protected branches, pull requests, and
tagged releases.

- [Operating Model](#operating-model)
- [Feature Work](#feature-work)
- [Release Work](#release-work)
- [Hotfix Work](#hotfix-work)
- [Sync Default Branch Back To Development](#sync-default-branch-back-to-development)
- [Tagging](#tagging)
- [Solo-Maintainer Notes](#solo-maintainer-notes)
- [Keep Private Elsewhere](#keep-private-elsewhere)

## Operating Model

SwiftFoundationHelpers uses GitFlow with protected integration branches.

The important consequence is:

- Working happens on `feature/*`, `release/*`, and `hotfix/*`
- Authoritative integration happens through pull requests
- Feature branches target `develop`
- Release and hotfix branches target `main`
- `develop` and `main` should be treated
  as hosted integration branches, not as branches that are finished locally and pushed afterward

Prefer `git flow ... start` for creating working branches. Do not treat `git flow ... finish` as a
cleanup step for this protected-branch workflow, because it performs local merges into integration
branches. After the authoritative pull request merge, prefer manual
local branch cleanup instead.

This file stays at the policy and high-level workflow layer. Sensitive operator details should live
outside the public repository.

## Feature Work

Use for normal development work.

1. Create a local feature branch from `develop`.
   Example: `git flow feature start my-change`
2. Commit focused changes locally on that feature branch.
3. Push the feature branch to the remote repository.
   Example: `git push -u origin feature/my-change`
4. Open a pull request from the remote `feature/*` branch into
   `develop`.
5. Let required checks run on the hosted repository.
6. Merge the pull request once required checks and review requirements
   pass.
7. Delete the remote feature branch after merge if it is no longer needed, and clean up your local
   branch when convenient.

## Release Work

Use for release stabilization and promotion.

1. Create a local `release/<version>` branch from `develop`.
   Example: `git flow release start 1.2.0`
2. Commit release-targeted stabilization changes locally on that release branch.
3. Push the release branch to the remote repository.
   Example: `git push -u origin release/1.2.0`
4. Open a pull request from the remote `release/*` branch into
   `main`.
5. Merge the pull request after required checks and review requirements
   pass.
6. Fetch the newly merged remote `main` commit into your local
   repository.
7. Create an annotated release tag that points at the fetched default-branch commit.
8. Push the annotated release tag to the remote repository.
9. Sync the resulting remote `main` state back into
   `develop` explicitly.

## Hotfix Work

Use for urgent fixes that must land on the released default branch first.

1. Create a local `hotfix/<version>` branch from `main`.
   Example: `git flow hotfix start 1.2.1`
2. Apply and validate the fix locally on that hotfix branch.
3. Push the hotfix branch to the remote repository.
   Example: `git push -u origin hotfix/1.2.1`
4. Open a pull request from the remote `hotfix/*` branch into
   `main`.
5. Merge the pull request after required checks and review requirements
   pass.
6. Create and push an annotated hotfix tag from the authoritative merged default-branch commit.
7. Sync the resulting remote `main` state back into
   `develop` explicitly.

## Sync Default Branch Back To Development

After a release or hotfix lands on `main`, update
`develop` deliberately rather than assuming both protected branches
are already aligned.

Preferred sequence:

1. Fetch the latest remote `main` and `develop`
   state.
2. Create a temporary sync branch from updated `develop`.
3. Merge the updated remote `main` state into the sync branch.
4. Push the sync branch and open a pull request into
   `develop`.
5. Merge on the hosted service once required checks pass.

## Tagging

- Use annotated tags for public releases.
- Tag the authoritative merged `main` commit.
- Use `vMAJOR.MINOR.PATCH` tag names.
- Keep the tag annotation concise, verb-oriented, and release-focused.

## Solo-Maintainer Notes

It is normal for a solo maintainer to use pull requests for both feature
and release branches once protected branches are enabled.

The pull request still provides value even without another human
reviewer:

- Required checks run on the proposed branch change before the protected branch moves
- The hosted Git service becomes the authoritative merge surface for protected branches
- Release and branch history stay aligned with the repository protection model

For a solo-maintainer repository, it is reasonable to keep the policy lightweight:

- One required approval on the development branch, or an intentionally documented exception path
- Stricter review on the default branch only if that is useful for release discipline
- Narrow admin bypass only when necessary and documented in `.github/BRANCH-PROTECTION.md`

## Keep Private Elsewhere

Sensitive operator documentation should live outside the public repository.

Examples that should live in a truly private location include:

- Secrets and credential recovery procedures
- Emergency branch-protection bypass procedures
- Security-incident response details
- Account recovery or succession notes
