# Phase 55: Container Runtime User

**Prompt:** 029-process-user
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27T20:35:00-0400
**Verdict:** DONE

## Summary
Determine the container runtime UID/GID and process tree of the execution service, and relate it to the mounted secret's ownership.

## Evidence
- **EV-029-1 (VERIFIED):** Inside `shuffle-tools_1-2-0.1` (`id`) → `uid=0(root) gid=0(root)` with standard root groups. Container process runs as root.
- **EV-029-2 (VERIFIED):** The mounted secret `/run/secrets/iris-shuffle.env` is `root:root` mode 0444 (from EV-026-2 / EV-031). Root ownership is consistent with the container running as root.
- **EV-029-3 (VERIFIED):** Host-side token file `data/shuffle/files/iris-shuffle.env` is `user:user` (UID/GID non-root) mode 600 — only the bind source owner can read it on the host; the container sees the swarm-projected 0444 copy.

## Backup-Rollback
Read-only (exec `id` only; no content read).

## Stop conditions
None.

## Limitations
Process-tree enumeration was constrained to `id` + `ps` header (the container `ps` rejected the `uid` field); root-user runtime is confirmed but a full least-privilege (non-root) hardening is NOT applied and is a separate owner-gated work item (see 037/038).

## Verdict rationale
Runtime user and secret ownership are evidenced and consistent. DONE (with noted least-privilege limitation, carried to 037/038).
