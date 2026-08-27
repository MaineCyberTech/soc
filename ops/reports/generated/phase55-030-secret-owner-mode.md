# Phase 55: Secret Owner and Mode

**Prompt:** 030-secret-owner-mode
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27T20:35:00-0400
**Verdict:** DONE

## Summary
Verify the target UID/GID/mode of the mounted secret and the minimum required permission surface.

## Evidence
- **EV-030-1 (VERIFIED):** Swarm secret file mode = `292` decimal = octal `0444` (read-only for all, no write) with UID/GID `0/0`, per service spec (`docker service inspect -f '{{json ...Secrets}}'`).
- **EV-030-2 (VERIFIED):** Live mount confirms it: `/run/secrets/iris-shuffle.env` → `-r--r--r-- 1 root root 78` (from EV-031 positive test). Mode 0444 holds at runtime.
- **EV-030-3 (VERIFIED):** Host bind-source token file `data/shuffle/files/iris-shuffle.env` is mode `600` (`user:user`) — stricter than the in-container projection; only the host owner reads it, swarm projects a read-only 0444 copy into the container.
- **EV-030-4 (VERIFIED):** Minimum required: the granted service needs read-only access to the file; 0444 satisfies this with no write/execute, and the file is scoped to a single service (EV-026-3).

## Backup-Rollback
Read-only.

## Stop conditions
None. No mode change performed (gate: secret rotation/creation is owner-only; this was inspection only).

## Limitations
Mode is read-only (0444) which is appropriate; the container itself runs as root (EV-029) so the least-privilege posture is at the secret-access layer, not the process layer.

## Verdict rationale
Ownership and mode of the secret meet the minimum required (read-only, service-scoped). DONE.
