# Phase 55: Orborus Version

**Prompt:** 075-orborus-version
**Generated (UTC):** 2026-08-27T23:05:00Z
**Operator (EDT):** 2026-08-27T19:05:00-0400
**Verdict:** DONE

## Summary
Orborus is a digest-pinned standalone container (not a swarm service). Image digest matches compose.

## Evidence
- EV-1 (VERIFIED): container `shuffle-orborus` image `ghcr.io/shuffle/shuffle-orborus@sha256:5c300bcbfa4550d8915d01ba0e7c8dacfb6244a7566d5f685469ddd08fc84512` (digest-pinned, matches compose).
- EV-2 (VERIFIED): not present in `docker service ls` → Orborus runs as a standalone container, not swarm-managed.
- EV-3 (VERIFIED): env `SHUFFLE_SWARM_CONFIG=run` → Orborus creates app services (e.g., `shuffle-tools_1-2-0`) as swarm services.

## Backup-Rollback
n/a (read-only).

## Stop conditions
None.

## Limitations
Upstream registry digest verified against compose; no version drift observed.

## Verdict rationale
Orborus image pinned + role confirmed → DONE.
