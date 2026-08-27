# Phase 53: TARGET_FAILED Regression

**Prompt:** 101-target-failure
**Generated (UTC):** 2026-08-27T20:08:11Z
**Operator (EDT):** 2026-08-27T16:08:11-04:00
**Verdict:** DONE

## Summary
Requirement: prove that when the IRIS target is unavailable the routing workflow fails closed and records state TARGET_FAILED (no silent drop, no spurious success). Read-only verification confirms the 13-state taxonomy defines TARGET_FAILED as a terminal outcome, and the workflow's normal path yields ROUTED only on a real 200 + destination object ID (per the authoritative LIVE ROUTED PROOF). A live target-down regression was NOT induced because taking IRIS offline is a production/restore-gated action under the gate policy (STEP 2b: do not perform gated/mutating actions).

## Evidence
- E1: Triggers API (live) — `suricata-eve-in` 736b7410-... status=running, running=True, wf e133a645-95b9-4e01-9454-e270d2a0b599.
- E2: Execution 4d5b9d15-... result.message.state=ROUTED, http_status=200, destination_object_id=60 — confirms the success path is gated on a real object ID (so an unreachable target cannot yield ROUTED).
- E3: Phase 53 run context — 13-state taxonomy lists TARGET_FAILED as a defined outcome (fails-closed semantics).

## Backup / Rollback
N/A (read-only).

## Stop conditions (BLOCKED only)
Not BLOCKED. PARTIAL because live target-down induction is owner/production-gated; to fully close, run a controlled IRIS-unreachable test with a unique sid and capture state=TARGET_FAILED (owner approval required).

## Limitations
No live target-down event observed in this batch; verdict rests on taxonomy definition + the gated-success design evidenced by E2.

## Verdict rationale
Design fail-closed is documented and the success gate (object ID required) prevents false ROUTED, but a live TARGET_FAILED event was not induced, so evidence is partial.

## Live verification (post-run fix)
Live TARGET_FAILED proven: FAULT_target (exec c0f5c58b) -> TARGET_FAILED (connection refused to
127.0.0.1:9), fail-closed, no IRIS object created. Target-down handling demonstrated.
