# Phase 55: Rotation Rollback

**Prompt:** 049-rotation-rollback
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** BLOCKED

## Summary
Prompt requires restoring the prior secret grant after a (hypothetical) rotation. Any grant change/restore is orchestrator-only per run-context §4/§6. No rollback performed. The mechanical path is documented from the live service spec.

## Evidence
- EV-01 (VERIFIED): `docker service inspect shuffle-tools_1-2-0` exposes `RollbackConfig` (`FailureAction=pause`, `Parallelism=1`, `Order=stop-first`) and the current `SecretID 4vpfvc92ice01x52qtc69yi2c`. A rollback to the prior grant would use `docker service update --secret-rm <bad> --secret-add source=<prior_id>,target=/run/secrets/iris-shuffle.env` (preserve unversioned target per 042).
- EV-06 (VERIFIED): Single consumer — rollback blast radius bounded to `shuffle-tools_1-2-0`.

## Backup-Rollback
N/A (no change). The documented restore path above is the backup/rollback for any future rotation. Orchestrator must snapshot the prior `SecretID` before rotation.

## Stop conditions
Restoring/prior-grant change requires **orchestrator/owner approval** and value-blind handling (gate: secret creation/rotation, run-context §4/§6). This agent must not mutate the grant.

## Limitations
Read-only. Cannot execute the rollback. Mechanical path recorded from live spec to support a future orchestrator operation.

## Verdict rationale
BLOCKED — grant restore is an explicit orchestrator-only gate. Legitimate stop, not a defect.
