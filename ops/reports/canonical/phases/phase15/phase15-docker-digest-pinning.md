# Phase 15 Docker Digest Pinning Report

Date: 2026-08-16

## Status: DIGESTS CAPTURED (IRIS/Shuffle/cloudflared/elastiflow) - compose edits pending

## What was done

- Captured running digests for: IRIS (app/db/nginx), Shuffle (backend/frontend/
  orborus/worker), cloudflared, elastiflow.
- Documented in docs/DEPENDENCY-HARDENING.md with pinning procedure.

## What remains

1. Capture MISP + Greenbone digests (VM103, next window).
2. Apply @sha256 edits to compose files (approval + recreate).
3. CI check: image refs must include digest.

## Risk

- `latest` tags = non-reproducible; digest pinning restores reproducibility.
- No service interruption required for capture (read-only inspect).

## No secrets
