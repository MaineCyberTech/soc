# Phase 55: Bind Retirement Certificate

**Prompt:** 073-bind-cert
**Generated (UTC):** 2026-08-27T23:05:00Z
**Operator (EDT):** 2026-08-27T19:05:00-0400
**Verdict:** DEFERRED

## Summary
Bind mount `/shuffle-files` is retained as an explicit fallback (Phase 54, 055 DEFERRED removal). Current status = RETAINED.

## Evidence
- EV-1 (VERIFIED): service inspect `shuffle-tools_1-2-0` Mounts includes bind `/opt/mct-security-stack/data/shuffle/files` → `/shuffle-files` (ReadOnly).
- EV-2 (VERIFIED): Phase 54 carryover fact — legacy bind retained as explicit fallback; removal DEFERRED (owner).

## Backup-Rollback
Bind removal would be via service update (gated); reversible.

## Stop conditions
Removing the bind = service edit → owner approval (BLOCKED if attempted).

## Limitations
Secret `/run/secrets/iris-shuffle.env` is now primary; bind remains fallback-only. Service-recreation / task-recreation layers are separate.

## Verdict rationale
Bind currently RETAINED by design; retirement DEFERRED per Phase 54 → DEFERRED.
