# Phase 56: Regression Plan (live synthetic, reversible)

**Prompt:** 175-state-plan
**Generated (UTC):** 2026-08-28T00:25:00Z
**Operator (EDT):** 2026-08-27T20:25:00-0400
**Verdict:** DEFERRED

## Summary
A controlled, reversible synthetic test plan exists (force states via `MCT_SYNTHETIC`+`MCT_FORCE_STATE` which return BEFORE any IRIS POST, so no ROUTED/IRIS object is created). Executing the live plan = a controlled POST to the webhook, which is a state-mutating action (creates executions + cache entries). This read-only pack follows 'do not mutate'; the live reversible test is deferred to an owner-gated controlled run.

## Evidence
EV-175-1 (VERIFIED): Source honors `MCT_SYNTHETIC`+`MCT_FORCE_STATE` for {MALFORMED,SYNTHETIC_TEST,POLICY_SUPPRESSED,DUPLICATE,ROUTE_BRANCH_SELECTED,ROUTE_ATTEMPTED,UNKNOWN} and returns before IRIS POST → no new IRIS object (synthetic isolation preserved).
EV-175-2 (VERIFIED): `force_state=="ENV_PROBE"` path lists `/run/secrets` and checks token-file existence only (no secret value read/printed).
EV-175-3 (PARTIAL): Live POST not executed in this pack (do-not-mutate).

## Backup / Rollback
No mutation. If run later: synthetic POST to webhook `suricata-eve-in` (736b7410…), forced non-routing states only; replayable dead-letter exists for any failure.

## Stop conditions
Live synthetic POST to webhook is a state-mutating action; deferred per 'do not mutate' in this read-only pack (owner-gated controlled test).

## Limitations
None.

## Verdict rationale
DEFERRED: the reversible synthetic plan is designed and verified read-only, but its live execution is a mutation deferred to an owner-gated controlled run.
