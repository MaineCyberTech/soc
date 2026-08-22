# Phase 24 v1.2.0 Tag, Release, and Bundle

Date: 2026-08-22
Status: **NOT EXECUTED - APPROVAL PENDING** (C9; PAT memory-only when executed).

## Procedure (on approval)

1. Rebuild portable bundle: `bash scripts/ci/build-release-bundle.sh --apply` -> verify
   0 sensitive files; record sha256 from manifest.
2. Tag: `git tag -a v1.2.0 -m "MCT Security Stack v1.2.0 - Phase 24 baseline"` -> push.
3. GitHub release (PAT in-memory): release object + asset upload
   (P21 v1.1.0 process: API with `Authorization: token $PAT`, memory-only).
4. Verify release object + asset via API.
5. Rollback: delete tag (`git push origin :refs/tags/v1.2.0`), discard release object.

## Current release

- v1.1.0 remains the published release until this executes.

## No secrets