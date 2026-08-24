# Phase 27 v1.3.0 Tag and Release

Date: 2026-08-24
Status: **NOT EXECUTED - APPROVAL PENDING** (PAT memory-only when executed).

## Procedure (on approval)

1. Rebuild portable bundle (`build-release-bundle.sh --apply`) -> 0 sensitive files -> record
   sha256.
2. RELEASE-NOTES: add v1.3.0 Published; README release line update.
3. `git tag -a v1.3.0` -> push.
4. GitHub release + asset (PAT memory-only from .env; unset after).
5. Verify release object + asset (phase27-46).

## Rollback

- Delete tag (`git push origin :refs/tags/v1.3.0`) + discard release object.

## Current release

- v1.2.0 remains published until approval.

## No secrets