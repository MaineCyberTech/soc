# Phase 17 Docker Digest Hardening Continuation

Date: 2026-08-16

## Status: 6 IMAGES PINNED (P16) - 29 REMAIN UNPINNED

## Current state

- Pinned (P16): IRIS app, Shuffle frontend/backend/orborus, MISP core, gvmd.
- Unpinned: 29 refs - mostly versioned tags (alpine/mariadb/postgres/redis/
  valkey/opensearch) + greenbone feed images + opencanary latest.
- CI check: informational (reports violations, non-blocking).

## Assessment

- Versioned-tag images (opensearch 3.2.0, mariadb 10.11, etc.) are low-risk
  (semver-pinned).
- Greenbone feed/data images: updated regularly by design (feeds) - digest
  pinning would freeze feeds; keep tag-based.
- opencanary:latest + velociraptor:latest (deprecated compose) - candidates
  for pinning next.

## Exceptions (documented)

- ops/reports/phase17-unpinned-image-exceptions.md (created)

## No secrets
