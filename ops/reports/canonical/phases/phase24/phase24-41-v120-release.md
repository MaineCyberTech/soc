# Phase 24 v1.2.0 Tag, Release, and Bundle

Date: 2026-08-22
Status: **EXECUTED - v1.2.0 PUBLISHED** (2026-08-22 06:14 UTC; PAT memory-only from .env, unset after).

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
## Published result (verified via public API)

- Release: id 374836261, https://github.com/MaineCyberTech/soc/releases/tag/v1.2.0, published 2026-08-22T06:14:12Z.
- Asset: `mct-security-stack-release-20260822-061237.tar.gz` (3,909,144 bytes, state uploaded).
- Tag: v1.2.0 -> 62d7457 (pushed).
- Rollback retained: tag delete + release object discard if ever needed.
