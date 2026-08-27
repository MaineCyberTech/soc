# Phase 55: Bind Rollback

**Prompt:** 058-bind-rollback
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** DEFERRED

## Summary
Define the rollback to re-add the `/shuffle-files` bind if a future removal proves problematic. The re-add is itself a service-update mutation and approval-gated, so it is not executed here; the mechanical path is documented from the live spec.

## Evidence
- EV-01 (VERIFIED): Current spec mount entry `Source=/opt/mct-security-stack/data/shuffle/files, Target=/shuffle-files, ReadOnly=true` is the exact definition to restore.
- EV-06 (VERIFIED): Single consumer `shuffle-tools_1-2-0`; re-add affects only this service.
- EV-04 (VERIFIED): Workflow `load_iris_token` already references `/shuffle-files/iris-shuffle.env` as fallback — re-adding the bind immediately restores that path with no code change.

## Backup-Rollback
Rollback command (orchestrator, post-approval): `docker service update shuffle-tools_1-2-0 --mount-add type=bind,source=/opt/mct-security-stack/data/shuffle/files,target=/shuffle-files,readonly`. Pre-removal snapshot of the spec is the backup. Not executed in this run.

## Stop conditions
Re-adding the bind is a service-update change requiring **orchestrator/owner approval** (gate, run-context §4/§6). This agent must not mutate the live service spec.

## Limitations
Read-only. The rollback path is documented but not exercised (executing it would mutate the grant).

## Verdict rationale
DEFERRED — the rollback action is approval-gated; only the mechanical path is provided. Legitimate deferral, not a defect.
