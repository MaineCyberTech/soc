# Phase 45: Datastore Failure Proof

## Objective
Prove Shuffle cache/datastore failure → `DATASTORE_FAILED` (fails closed).

## Failure Scenarios
| Scenario | Trigger | Expected State |
|----------|---------|----------------|
| Redis unavailable | `check_cache_contains` / `set_cache_value` fails | `DATASTORE_FAILED` |
| Redis timeout | Operation times out | `DATASTORE_FAILED` |
| Redis connection refused | Connection error | `DATASTORE_FAILED` |
| Redis OOM / error | Server error response | `DATASTORE_FAILED` |

## Test 1: Redis Unavailable
```bash
# 1. Stop Redis
docker stop shuffle-redis

# 2. Send event
curl -X POST "http://127.0.0.1:5001/api/v1/hooks/p39-suricata-test" \
  -H "Content-Type: application/json" \
  -d '{"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_ip":"192.168.1.10","dest_port":443,"proto":"TCP"},"MCT_TEST":"datastore-redis-down"}'

# 3. Restart Redis
docker start shuffle-redis
```

## Test 2: Redis Timeout
```bash
# Configure Redis with very low timeout (if possible)
# Or simulate with network partition
```

## Expected Behavior
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| **State** | `DATASTORE_FAILED` | [State] | [PASS/FAIL] |
| **Not ROUTED** | State ≠ ROUTED | [Bool] | [PASS/FAIL] |
| **Not AUTH_FAILED** | State ≠ AUTH_FAILED | [Bool] | [PASS/FAIL] |
| **Not TARGET_FAILED** | State ≠ TARGET_FAILED | [Bool] | [PASS/FAIL] |
| **Fails closed** | No routing, no silent drop | [Bool] | [PASS/FAIL] |
| **Event processed** | Classified, not silent | [Bool] | [PASS/FAIL] |
| **Counter** | `p44_packet_datastore_fail` +1 | [Delta] | [PASS/FAIL] |

## Fail-Closed Semantics
| Principle | Implementation |
|-----------|----------------|
| **No silent drop** | Every failure produces a classified state |
| **No routing on failure** | Never reaches IRIS on datastore error |
| **Bounded evidence** | Error type logged, no sensitive data |
| **Operator visibility** | `DATASTORE_FAILED` count alerts |

## Verification
```bash
EXEC_ID=<from_hook>
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/$EXEC_ID"
```

## Verification Checklist
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| State = DATASTORE_FAILED | True | [Bool] | [PASS/FAIL] |
| State ≠ ROUTED | True | [Bool] | [PASS/FAIL] |
| State ≠ TARGET_FAILED | True | [Bool] | [PASS/FAIL] |
| State ≠ AUTH_FAILED | True | [Bool] | [PASS/FAIL] |
| No IRIS call | True | [Bool] | [PASS/FAIL] |
| Counter `p44_packet_datastore_fail` | +1 | [Delta] | [PASS/FAIL] |
| Fails closed (no routing) | True | [Bool] | [PASS/FAIL] |

## Recovery
```bash
# Restart Redis
docker start shuffle-redis

# Next event should process normally
curl ... -d '{"MCT_TEST":"datastore-recovery"}'
# Expected: ROUTED (if allowlisted)
```

## Evidence
- [ ] State = DATASTORE_FAILED
- [ ] Not ROUTED / not TARGET_FAILED / not AUTH_FAILED
- [ ] Fails closed (no routing)
- [ ] Counter incremented
- [ ] Recovery after Redis restore

---
*Generated: 2026-08-27T04:10:00Z (UTC) / 2026-08-27T00:10:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after target failure (Phase 45-38)*
