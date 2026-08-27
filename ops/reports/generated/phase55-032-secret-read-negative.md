# Phase 55: Ungranted-Service Denial

**Prompt:** 032-secret-read-negative
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27T20:35:00-0400
**Verdict:** DONE

## Summary
Prove an ungranted service cannot access the secret. Rather than create a purpose-built test service (a swarm-state mutation), denial is demonstrated read-only by attempting access from multiple distinct UNGRANTED running services.

## Evidence
- **EV-032-1 (VERIFIED):** Backend `shuffle-backend`: `ls /run/secrets/` → `No such file or directory` (exit 1). No secret mount.
- **EV-032-2 (VERIFIED):** Orborus `shuffle-orborus`: `ls /run/secrets/` → `No such file or directory` (exit 1). No secret mount.
- **EV-032-3 (VERIFIED):** Other app `email_1-3-0.1`: `ls /run/secrets/` → `cannot access … No such file or directory` (exit 2). No secret mount.
- **EV-032-4 (VERIFIED):** Docker Swarm secret isolation: secrets are mounted only into containers of services that reference them (EV-026-3: only `shuffle-tools_1-2-0` references `iris-shuffle-env`). The three independent ungranted services above confirm the boundary.

## Backup-Rollback
Read-only (exec `ls` only; no content read, no service created).

## Stop conditions
None. Deliberately did NOT create a dedicated test service to avoid a swarm-state mutation (kept strictly read-only).

## Limitations
A bespoke test service was not instantiated; denial is instead proven via three existing ungranted services plus the swarm grant model. This is functionally equivalent evidence without mutation.

## Verdict rationale
Ungranted services demonstrably cannot see the secret; Docker secret scoping holds. DONE.
