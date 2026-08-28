# Phase 45: Counter Failure Proof

## Objective
Prove `set_cache_value` failure → `COUNTER_FAILED`, fails closed, preserves evidence.

## Failure Scenarios
| Scenario | Trigger | Expected State |
|----------|---------|----------------|
| Redis unavailable | `set_cache_value` fails | `COUNTER_FAILED` |
| Redis timeout | Operation times out | `COUNTER_FAILED` |
| Redis OOM | Server error | `COUNTER_FAILED` |
| Key/value too large | Validation error | `COUNTER_FAILED` |

## Test: Redis Unavailable During Counter Increment
```bash
# 1. Stop Redis
docker stop shuffle-redis

# 2. Send normal event (will hit counter increment after dedup)
curl -X POST "http://127.0.0.1:5001/api/v1/hooks/p39-suricata-test" \
  -H "Content-Type: application/json" \
  -d '{"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_ip":"192.168.1.10","dest_port":443,"proto":"TCP"},"MCT_TEST":"counter-redis-down"}'

# 3. Restart Redis
docker start shuffle-redis
```

## Expected Behavior
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| **State** | `COUNTER_FAILED` | [State] | [PASS/FAIL] |
| **Not ROUTED** | State ≠ ROUTED | [Bool] | [PASS/FAIL] |
| **Not TARGET_FAILED** | State ≠ TARGET_FAILED | [Bool] | [PASS/FAIL] |
| **Not DATASTORE_FAILED** | State ≠ DATASTORE_FAILED | [Bool] | [PASS/FAIL] |
| **Fails closed** | No routing, event classified | [Bool] | [PASS/FAIL] |
| **Counter** | `p44_packet_counter_fail` +1 | [Delta] | [PASS/FAIL] |

## Fail-Closed Semantics
| Principle | Implementation |
|-----------|----------------|
| **No silent drop** | Event classified, not lost |
| **No routing on counter fail** | Never reaches IRIS |
| **Bounded evidence** | Error type logged |
| **Operator visibility** | `COUNTER_FAILED` count alerts |

## Counter vs Datastore Failure
| Aspect | `DATASTORE_FAILED` | `COUNTER_FAILED` |
|--------|-------------------|------------------|
| Trigger | Dedup lookup (`check_cache_contains`) | Counter increment (`set_cache_value`) |
| Phase | Before routing | After dedup, before IRIS |
| Recovery | Redis restore | Redis restore |
| Severity | High (blocks all) | Medium (blocks routing) |

## Verification
```bash
EXEC_ID=<from_hook>
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/$EXEC_ID"
```

## Verification Checklist
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| State = COUNTER_FAILED | True | [Bool] | [PASS/FAIL] |
| State ≠ ROUTED | True | [Bool] | [PASS/FAIL] |
| State ≠ TARGET_FAILED | True | [Bool] | [PASS/FAIL] |
| State ≠ DATASTORE_FAILED | True | [Bool] | [PASS/FAIL] |
| No IRIS call | True | [Bool] | [PASS/FAIL] |
| Counter `p44_packet_counter_fail` | +1 | [Delta] | [PASS/FAIL] |
| Fails closed | True | [Bool] | [PASS/FAIL] |

## Recovery
```bash
docker start shuffle-redis

# Next event should process normally
curl ... -d '{"MCT_TEST":"counter-recovery"}'
# Expected: ROUTED
```

## Evidence
- [ ] State = COUNTER_FAILED
- [ ] Not ROUTED / not TARGET_FAILED / not DATASTORE_FAILED
- [ ] Fails closed
- [ ] Counter incremented
- [ ] Recovery after Redis restore

---
*Generated: 2026-08-27T04:11:00Z (UTC) / 2026-08-27T00:11:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after datastore failure (Phase 45-39)*
