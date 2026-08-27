# Phase 55: Rotation v1 to v2

**Prompt:** 043-rotation-v1-v2
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** BLOCKED

## Summary
Prompt requires adding a new secret version and removing the old one in a single governed rolling update. Per run-context gate rules §4 and §6, secret rotation (new/remove) is orchestrator-only. No rotation was performed. Read-only state captured as the baseline for a future orchestrator rotation.

## Evidence
- EV-01 (VERIFIED): Current secret `iris-shuffle-env` (`4vpfvc92ice01x52qtc69yi2c`) mounts unversioned (`/run/secrets/iris-shuffle.env`, 0444) to the single consumer `shuffle-tools_1-2-0`.
- EV-06 (VERIFIED): Exactly one consumer; a rolling update would touch only `shuffle-tools_1-2-0` (Replicas=2, `UpdateConfig.Parallelism=1`, `FailureAction=pause`) — rotation blast radius is bounded to this service.
- EV-03 (VERIFIED): Runtime confirms both the secret mount (0444) and the bind fallback (`/shuffle-files/iris-shuffle.env`, 0600) currently coexist.

## Backup-Rollback
N/A (no change). Future orchestrator rotation rollback path: `--secret-rm` the v2 grant and `--secret-add` the prior `SecretID` back; service `RollbackConfig` (`FailureAction=pause`) supports pause-on-failure.

## Stop conditions
Secret rotation (add new / remove old) requires **orchestrator/owner approval** and value-blind handling (gate: secret creation/rotation, run-context §4/§6). This agent must not rotate secrets.

## Limitations
Read-only. Cannot perform the v1→v2 swap. Blast-radius and update-config facts recorded to support a future governed rolling update.

## Verdict rationale
BLOCKED — secret rotation is an explicit orchestrator-only gate. Legitimate stop, not a defect.
