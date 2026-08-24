# Phase 28 v1.3.0 Tag and Release

Date: 2026-08-24
Status: **NOT EXECUTED - APPROVAL PENDING** (PAT memory-only when executed).

## Procedure (on approval)

1. Rebuild portable bundle (`scripts/ci/build-release-bundle.sh`) -> 0 sensitive files
   (excludes data/, velociraptor keys) -> record sha256 + dependency-lock.json.
2. RELEASE-NOTES: add v1.3.0 Published; README release line update.
3. `git tag -a v1.3.0` -> push.
4. GitHub release + asset (PAT memory-only from .env; unset after).
5. Verify release object + asset (66).

## Rollback

- Delete tag + discard release object; restore v1.2.0 as current.

## Current release

- v1.2.0 remains published until approval.

## No secrets