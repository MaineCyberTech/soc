# Phase 54: Mount Baseline

**Prompt:** 028-mount-before
**Generated (UTC):** 2026-08-27T21:28:41Z
**Operator (EDT):** 2026-08-27T17:28:41-0400
**Verdict:** DONE

## Summary
Baseline of the current credential mount (broad directory bind) before any narrowing to a service-scoped secret.

## Evidence
- E1-compose-mount — `docker-compose.shuffle.yml` backend: `- /opt/mct-security-stack/data/shuffle/files:/shuffle-files` (read-write bind, directory-level, NOT readonly, NOT a single file).
- E2-dir-listing — `/shuffle-files` (host `data/shuffle/files/`) contains: `iris-shuffle.env` (mode 600, 78 bytes) and a per-org subdirectory `264c0502-9136-4cfc-938b-390b97b861b8/` (org data, not the credential).
- E3-readonly — Bind is read-write; not marked `:ro`.
- E4-prop — Default propagation; not a Swarm secret mount.

## Backup / Rollback
Baseline captured in this report + compose hash (0a794710…). Orchestrator implements the narrow mount; rollback = revert compose to this baseline.

## Stop conditions
None for baseline capture.

## Limitations
Directory also carries org app-data subdir; narrowing must avoid clobbering that path.

## Verdict rationale
Broad bind-mount baseline documented; this is the exact surface the P54 secret-narrowing targets.
