# Phase 55: Bind Mount Risk

**Prompt:** 055-bind-risk
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** DONE

## Summary
Assess the risk that "read-only bind access" is mistaken for "service secrecy." Read-only access is NOT secrecy: the bind exposes the entire `data/shuffle/files` directory tree (ReadOnly) to the container, whereas the Swarm secret mounts a single file at a fixed 0444 path scoped only to `shuffle-tools_1-2-0`. The bind is broader than necessary and should be retired once the secret is proven sufficient (gated).

## Evidence
- EV-01 (VERIFIED): Bind = whole-directory mount `Source=/opt/mct-security-stack/data/shuffle/files → /shuffle-files` (ReadOnly). Any file dropped in that host dir becomes container-visible.
- EV-03 (VERIFIED): Secret mount is a single file `/run/secrets/iris-shuffle.env` (0444, root) vs bind file `/shuffle-files/iris-shuffle.env` (0600). The secret is narrower (one file, fixed name, service-scoped) and read-only-by-permission; the bind is read-only-by-flag but directory-wide.
- EV-04 (VERIFIED): `load_iris_token` prefers the secret path and uses the bind only as fallback — so the bind is redundant for normal operation but adds attack surface.

## Backup-Rollback
Risk mitigation = remove the bind (gated, see 056/057) keeping the secret as the sole carrier. Rollback = re-add bind (058).

## Stop conditions
Bind removal is a service-update change requiring approval (gate). This report documents risk only; no mutation performed.

## Limitations
Risk is assessed from container/spec evidence; it does not assert a live compromise. Read-only: the bind remains present (intentionally retained as fallback per Phase 54, DEFERRED removal).

## Verdict rationale
DONE — risk clearly characterized and VERIFIED: read-only bind ≠ secrecy; the secret is the least-privilege carrier and the bind is broader-surface, to be retired under approval.
