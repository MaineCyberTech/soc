# Phase 29 v1.3.0 Tag and Release

Date: 2026-08-24
Status: **NOT EXECUTED - APPROVAL PENDING + P0 GATES OPEN** (65).

## Procedure (on approval + gate closure)

1. Apply image pin set (05) -> verify -> P0 closed.
2. Release notes v1.3.0 + README release line.
3. `git tag -a v1.3.0` -> push.
4. GitHub release + asset (bundle 66; PAT memory-only from ops/.env; unset after).
5. Verify release object + asset (68).

## Rollback

- Delete tag + discard release object; v1.2.0 remains current.

## No secrets