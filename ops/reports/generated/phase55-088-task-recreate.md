# Phase 55: Task Recreation

**Prompt:** 088-task-recreate
**Generated (UTC):** 2026-08-27T23:05:00Z
**Operator (EDT):** 2026-08-27T19:05:00-0400
**Verdict:** PARTIAL

## Summary
Reprove secret and route after task recreation. Read-only proof: both running replicas carry `/run/secrets/iris-shuffle.env` (0444) (EV-MOUNT-005) -> secret grant confirmed per task. ROUTED already VERIFIED in Phase 54 (EV-ROUTED-010: exec 2ce46d4a -> ROUTED, IRIS object 67). Recreating a task (kill) was not executed (disruptive/bounded — orchestrator).

## Evidence
## Shared Evidence (VERIFIED unless noted)
- EV-SVC-001: `docker service ls` — 7 Shuffle app services; `shuffle-tools_1-2-0` replicated 2/2, image `frikky/shuffle:shuffle-tools_1.2.0`, published 33334/tcp. VERIFIED.
- EV-SPEC-002: `docker service inspect shuffle-tools_1-2-0` — Spec.Labels `{}`; Placement `{}`; Image tag (no digest pin); Mounts `/shuffle-files` bind (RO, fallback); Secrets `[{File: iris-shuffle.env, Mode 292(=0444), SecretID 4vpfvc92ice01x52qtc69yi2c, SecretName iris-shuffle-env}]`; UpdateConfig (Parallelism 1, OnFailure pause, Monitor 5s, MaxFailureRatio 0, Order stop-first); RollbackConfig identical; RestartPolicy (Condition any, Delay 5s, MaxAttempts 0); Resources `{}` (no limits). VERIFIED.
- EV-SECRET-003: `docker secret ls` — `iris-shuffle-env` ID `4vpfvc92ice01x52qtc69yi2c`. VERIFIED.
- EV-GRANT-004: per-service secret scan across all 7 services — ONLY `shuffle-tools_1-2-0` references `iris-shuffle-env`; least-privilege isolation VERIFIED.
- EV-MOUNT-005: `docker exec` on both running replicas — `/run/secrets/iris-shuffle.env` present, mode 0444. Per-task grant VERIFIED.
- EV-NODE-006: `docker node ls` — single node `docker` (Leader, Active, Engine 29.7.2). VERIFIED.
- EV-FILE-007: `stat` source file mode 600 (content NOT read). VERIFIED.
- EV-TASKS-008: `docker service ps` — 2 running replicas on node `docker`. VERIFIED.
- EV-IMG-009: `docker images --digests` — `shuffle-tools_1.2.0` DIGEST `<none>` (image ID `d8872cda6701`); `shuffle-workers` digest-pinned. VERIFIED.
- EV-ROUTED-010: Phase 54 ROUTED — exec `2ce46d4a-...` -> ROUTED, http_status 200, IRIS object 67. VERIFIED (carryover).

Relevant: EV-MOUNT-005, EV-ROUTED-010, EV-GRANT-004.

## Separate layers
Task-recreation vs service-recreation vs Orborus-recreation vs full-restore kept distinct.

## Backup-Rollback
Read-only; recreate would be self-healing via restart policy (085).

## Stop conditions
Task kill/recreate not performed (orchestrator-bounded).

## Limitations
Recreation not induced; grant + route confirmed on currently running tasks and via P54.

## Verdict rationale
Per-task grant + ROUTED confirmed on live state; recreate not executed.
