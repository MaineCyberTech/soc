# Phase 53: 13 Taxonomy States — Real Workflow Execution

Report ID: phase53-13state
Phase: 53
Date: 20260827
Timestamp: 20260827-1900Z
Classification: INTERNAL
Status: PARTIAL (12/13 TEST PROVEN via real execution; ROUTED live object blocked by Shuffle result-passing quirk)

## Method
Each state exercised by a real REST execute of workflow `e133a645` (no fabricated PASS).
Synthetic isolation + fault injection (synthetic-only) used to deterministically reach
failure branches with genuine exceptions / real 401 / real connection-refused.

## Results (real executions)
| state | emitted | match |
|---|---|---|
| MALFORMED | MALFORMED | OK |
| SYNTHETIC_TEST | SYNTHETIC_TEST | OK |
| POLICY_SUPPRESSED | POLICY_SUPPRESSED | OK |
| ROUTE_BRANCH_SELECTED | ROUTE_BRANCH_SELECTED | OK |
| ROUTE_ATTEMPTED | ROUTE_ATTEMPTED | OK |
| UNKNOWN | UNKNOWN | OK |
| AUTH_FAILED | AUTH_FAILED | OK |
| DATASTORE_READ_FAIL | DATASTORE_READ_FAIL | OK |
| COUNTER_FAIL | COUNTER_FAIL | OK |
| DATASTORE_WRITE_FAIL | DATASTORE_WRITE_FAIL | OK |
| TARGET_FAILED | TARGET_FAILED | OK |
| DUPLICATE | DUPLICATE | OK |
| ROUTED | (logic proven; live object blocked) | MISS |

## Validator (p53-state-validate.py)
Required 13 states present; ROUTED requires http_success + destination_object_id.
Result: all 13 states present; ROUTED live object_id BLOCKED by Shuffle result-passing
quirk (see phase53-iris-wiring.md). ROUTED logic proven (emits ROUTED with object_id
parsing); 12 other states are TEST PROVEN via real workflow runs.
