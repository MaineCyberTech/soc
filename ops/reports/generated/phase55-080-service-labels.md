# Phase 55: Governance Labels

**Prompt:** 080-service-labels
**Generated (UTC):** 2026-08-27T23:05:00Z
**Operator (EDT):** 2026-08-27T19:05:00-0400
**Verdict:** DONE

## Summary
Identified safe selectors for the live Swarm service. No governance/label selectors are applied at the service Spec level (Spec.Labels = `{}`). Selection today relies on the explicit service name `shuffle-tools_1-2-0`. No label-based targeting exists that could be safely used for reconciler/selection scopes.

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

Relevant: EV-SPEC-002 (Labels `{}`), EV-SVC-001.

## Backup-Rollback
Read-only; no mutation.

## Stop conditions
None reached (read-only inspection).

## Limitations
Label-selector safety cannot be demonstrated because no labels exist. Recommendation to add explicit governance labels (e.g., mct.stack, mct.orborus-managed) is deferred to orchestrator (080/097 allowlist design).

## Verdict rationale
Live Spec inspected; selector state established as name-only.
