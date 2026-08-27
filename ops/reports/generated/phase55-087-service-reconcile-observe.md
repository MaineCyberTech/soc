# Phase 55: Observe Orborus Reconciliation

**Prompt:** 087-service-reconcile-observe
**Generated (UTC):** 2026-08-27T23:05:00Z
**Operator (EDT):** 2026-08-27T19:05:00-0400
**Verdict:** PARTIAL

## Summary
Does Orborus reconciliation preserve the secret grant? Evidence: the live service Spec carries the secret grant (EV-SPEC-002), and BOTH running replicas have `/run/secrets/iris-shuffle.env` mounted mode 0444 (EV-MOUNT-005). The secret is Orborus-managed and only granted to this service (EV-GRANT-004). A reconcile reapplies the Spec as-is, so the grant is preserved by construction. A live reconcile event was not triggered (mutation/orchestrator).

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

Relevant: EV-SPEC-002, EV-MOUNT-005, EV-GRANT-004, EV-SECRET-003.

## Separate layer
Orborus-recreation vs service-recreation vs task-recreation vs host-recovery vs full-restore kept distinct.

## Backup-Rollback
Read-only; reconcile is declarative (reapply spec).

## Stop conditions
Did not force a reconcile (orchestrator-bounded); assessed from live state.

## Limitations
Actual reconcile event not induced; preservation inferred from spec + grant topology.

## Verdict rationale
Grant verified in spec and on both tasks; live reconcile not induced.
