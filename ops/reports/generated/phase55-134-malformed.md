# Phase 55: MALFORMED (webhook test)

**Report ID:** phase55-134-malformed
**Phase:** 55
**Prompt:** 134-malformed
**Title:** MALFORMED (webhook test)
**Generated (UTC):** 2026-08-27T23:40:00Z
**Operator (EDT):** 2026-08-27T19:40:00-0400
**Verdict:** DONE
**Classification:** INTERNAL

## Summary
Malformed input handled fail-closed: a bad inner-JSON payload returned success:false with no IRIS object and no uncaught crash. The MALFORMED state is also reproducible via synthetic force-state (exec f1a0f529, isolated).

## Evidence
- **EV-INPUT-001 (VERIFIED):** Malformed input test: outer JSON valid but inner `data` not valid JSON -> execute_python returned `success:false` with exception, execution `FINISHED`, NO IRIS object, no uncaught crash => fail-closed.
- **EV-FORCE-001..006 (VERIFIED):** Synthetic force-state tests (MCT_SYNTHETIC=True) reproduced exact states with NO IRIS `destination_object_id`: MALFORMED(`f1a0f529`), SYNTHETIC_TEST(`b7d07053`), POLICY_SUPPRESSED(`d90f2190`), DUPLICATE(`f04c5c30`), ROUTE_BRANCH_SELECTED(`b7f2d125`), ROUTE_ATTEMPTED(`8f173df0`). Isolation confirmed (no destination object).

## Backup / Rollback
No mutation of stack configuration, secrets, services, or data performed. Reversible webhook replays posted to the existing (running) test trigger only; synthetic executions isolated. Any erroneous dead-letter/notification cache writes are guarded (try/except, never raises) and reversible via workflow revision. Restored-by-design from live Swarm spec + compose; no backup taken because no write occurred.

## Stop conditions
None (reversible synthetic POST).

## Limitations
Raw-bad-JSON path returns a generic exception (success:false) rather than the structured MALFORMED emit; structured MALFORMED only via synthetic force-state. Both are fail-closed.

## Verdict rationale
Malformed fail-closed VERIFIED; MALFORMED state reproducible and isolated.
