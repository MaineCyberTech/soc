# Phase 53: Frontend Version

**Prompt:** 045-frontend-version
**Generated (UTC):** 2026-08-27T20:07:40Z
**Operator (EDT):** 2026-08-27T16:07:40-0400
**Verdict:** DONE

## Summary
Identify the Shuffle frontend build/hash/assets. The Shuffle frontend is bundled inside the
backend image; no public version/build-hash API exists (GET /api/v1/version and /api/v1/ return
404). Version evidence gathered from the running image only.

## Evidence
- E1: backend image = ghcr.io/shuffle/shuffle-backend:latest, image id e5a9c7b0a7f0, Created 2026-05-14T16:30:55Z (docker inspect).
- E2: api /api/v1/version -> 404; /api/v1/ -> 404 (no build-hash endpoint exposed).
- E3: frontend is served by shuffle-backend container on :3443 (TLS) and returns 200 (verified stack fact).

## Backup / Rollback
N/A.

## Stop conditions (BLOCKED only)
None.

## Limitations
Exact frontend build hash / asset revision not exposed by any read-only API or image label
(labels empty). Only the backend image tag + build date are verifiable. Marked PARTIAL, not
fabricated.

## Verdict rationale
Image tag/dates confirmed; precise frontend build hash unobtainable read-only. Verdict PARTIAL.

## Owner approval (2026-08-27)
Residual limitation accepted by owner. The constraint is inherent (see Limitations) and not fixable
within authorized read-only scope; no mutating or secret-exposing action is required.
Verdict changed PARTIAL -> ACCEPT.

## Live remediation (2026-08-27)
Shuffle pins images by digest. Verified: frontend `ghcr.io/shuffle/shuffle-frontend@sha256:4d700a6f0822cb081822bd2fa6c633080553bdd4313aed2c4bdce75b87e82836`;
backend `ghcr.io/shuffle/shuffle-backend@sha256:d4a5d2bf1f956955b68b099ba1c38997e4b257b2518215e0427f433515bea5c8`. `backend_version` is empty in this
build (`/api/v1/health`), so the digest is the authoritative version anchor. No semver tag is published by the image.
