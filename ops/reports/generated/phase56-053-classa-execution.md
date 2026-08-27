# Phase 56: Execution Proof

**Prompt:** 053-classa-execution
**Generated (UTC):** 2026-08-28T00:20:00Z
**Operator (EDT):** 2026-08-27T20:20:00-0400
**Verdict:** DONE

## Summary
Read-only proof of Class-A workflow executions via `GET /api/v1/workflows/eb937a37-…/executions`
(no hook invoked). 90 executions exist. The 3 most recent (7487d78d, 75e4be41, cc397d34) returned
**HTTP 401** to IRIS; many earlier executions returned HTTP 200 with real IRIS alert objects. The
path runs when triggered (manually), but IRIS auth has regressed.

## Evidence
- EV-EXE-01 (VERIFIED): `GET …/executions?limit=200` → 90 executions for workflow `eb937a37`. Source workflow id `eb937a37-5244-46dc-95ff-62ad4c681322`, revision embedded. (REST layer.)
- EV-EXE-02 (VERIFIED): Recent 401 executions — `7487d78d-bd21-434d-9a9b-a5b7081293e5` (started 1787871798 ≈ 2026-08-27T23:03Z), `75e4be41`, `cc397d34` — result `{"status":401,"body":{"status":"error","message":"Authentication required"…},"url":"https://iriswebapp_nginx:8443/alerts/add"}`. (REST/IRIS layer — destination failing.)
- EV-EXE-03 (VERIFIED): Earlier 200 executions — e.g. `b7efe812-8d74-4bd8-9850-b04999fd6690` (started 1787851069 ≈ 2026-08-27T17:17Z) result `{"status":200,"body":{"status":"success","data":{…"alert_id":58…}}}` (IRIS object created; see 054). (REST/IRIS layer.)
- EV-EXE-04 (PARTIAL): Execution `start`/trigger source not enumerated per-run (execution_argument empty for recent runs ⇒ likely manual/UI triggers, not Wazuh delivery, consistent with 040 group-skip + 045 webhook mismatch). The trigger-start provenance is inferred, not directly proven from execution metadata.

## Backup-Rollback
Read-only. No change. Execution history is immutable evidence; baseline hashes in 046.

## Stop conditions
None for inspection. Repair of the 401 (IRIS auth refresh) is approval-gated (047/048).

## Limitations
- Execution *detail* endpoint returned 404 for individual ids; list view provided sufficient result摘要. Did not re-pull full per-node traces.
- Provenance of trigger (manual vs Wazuh) inferred from empty argument + delivery gap.

## Verdict rationale
Execution history retrieved and classified read-only; current state = 401 regression, prior = 200.
DONE.
