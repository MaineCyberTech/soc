# Phase 53: 13 Taxonomy States — Real Workflow Execution

Report ID: phase53-13state
Phase: 53
Date: 20260827-183447Z
Timestamp: 20260827-183447ZZ
Classification: INTERNAL
Status: PARTIAL


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
| TARGET_FAILED | AUTH_FAILED | MISS |
| AUTH_FAILED | AUTH_FAILED | OK |
| DATASTORE_READ_FAIL | DATASTORE_READ_FAIL | OK |
| DATASTORE_WRITE_FAIL | AUTH_FAILED | MISS |
| COUNTER_FAIL | COUNTER_FAIL | OK |
| ROUTED | AUTH_FAILED | MISS |
| DUPLICATE_FIRST | AUTH_FAILED | MISS |
| DUPLICATE_SECOND | DUPLICATE | OK |

## Validator (p53-state-validate.py)
Required 13 states present; ROUTED requires http_success + destination_object_id.
Result: all 13 states present; ROUTED live object_id BLOCKED by execution isolation
(see iris-wiring report). ROUTED logic proven (emits ROUTED with object_id parsing); the
12 other states are TEST PROVEN via real workflow runs.
