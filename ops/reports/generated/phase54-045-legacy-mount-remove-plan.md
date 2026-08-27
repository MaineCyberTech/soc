# Phase 54: Legacy Mount Removal Plan

**Prompt:** 045-legacy-mount-remove-plan
**Generated (UTC):** 2026-08-27T21:31:16Z
**Operator (EDT):** 2026-08-27T17:31:16-0400
**Verdict:** DONE

## Summary
Plan to remove the legacy `/shuffle-files` directory bind mount from `shuffle-tools` only AFTER the service-scoped secret is validated (050/051) and the service recreated (048). Recorded as analysis; the removal itself is orchestrator-performed (see 055).

## Evidence
- EV-COMPOSE — line 44 `/opt/mct-security-stack/data/shuffle/files:/shuffle-files` is the legacy mount to be retired.
- EV-RULE — overlay prefers service-scoped secrets over broad bind mounts.

## Backup / Rollback
Orchestrator snapshots compose; rollback = re-add bind mount.

## Stop conditions
Removal (055) gated on proof of service-scoped secret working.

## Limitations
Plan only; removal not executed.

## Verdict rationale
Plan artifact completed; removal deferred to orchestrator after validation.
