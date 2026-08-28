# Phase 45: Target Failure Proof

## Objective
Prove IRIS delivery failure (non-auth) → `TARGET_FAILED`, not delivered, no duplicate storm, safe recovery.

## Failure Scenarios
| Scenario | HTTP Status | Expected State |
|---------|-------------|----------------|
| IRIS down | Connection refused / timeout | `TARGET_FAILED` |
| IRIS returns 5xx | 500/502/503/504 | `TARGET_FAILED` |
| IRIS returns 4xx (non-auth) | 400/404/429 | `TARGET_FAILED` |
| Network partition | Timeout | `TARGET_FAILED` |

## Test 1: IRIS Down
```bash
# 1. Stop IRIS container
docker stop iriswebapp_nginx

# 2. Send normal event
curl -X POST "http://127.0.0.1:5001/api/v1/hooks/p39-suricata-test" \
  -H "Content-Type: application/json" \
  -d '{"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_ip":"192.168.1.10","dest_port":443,"proto":"TCP"},"MCT_TEST":"target-down-1"}'

# 3. Restart IRIS
docker start iriswebapp_nginx
```

## Test 2: IRIS 500 Error
```bash
# Configure IRIS to return 500 (if possible)
# Or test with invalid endpoint
curl ... -d '{"MCT_TEST":"target-500"}'
```

## Expected Behavior
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| **State** | `TARGET_FAILED` | [State] | [PASS/FAIL] |
| **Not ROUTED** | State ≠ ROUTED | [Bool] | [PASS/FAIL] |
| **Not AUTH_FAILED** | State ≠ AUTH_FAILED | [Bool] | [PASS/FAIL] |
| **IRIS alert created** | **NO** | [No ID] | [PASS/FAIL] |
| **Counter `p44_packet_routed`** | Unchanged | [Count] | [PASS/FAIL] |
| **Counter `p44_packet_target_fail`** | +1 | [Delta] | [PASS/FAIL] |
| **Dedup key** | Created (event processed) | [Exists] | [PASS/FAIL] |
| **Duplicate storm** | No repeat on retry | [Check] | [PASS/FAIL] |

## Duplicate Storm Prevention
| Mechanism | Behavior |
|-----------|----------|
| Dedup key created before IRIS call | Yes (after allowlist, before IRIS) |
| Retry on failure | **No automatic retry** (single attempt) |
| Repeat event | Dedup key exists → DUPLICATE (no storm) |

## Recovery Behavior
| Scenario | Behavior |
|----------|----------|
| IRIS recovers | Next event → ROUTED (dedup key expired/new) |
| Manual retry | Not needed (dedup prevents storm) |
| Operator intervention | Monitor `packet.target_fail.count` |

## Verification
```bash
EXEC_ID=<from_hook>
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/$EXEC_ID"
```

## Verification Checklist
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| State = TARGET_FAILED | True | [Bool] | [PASS/FAIL] |
| State ≠ ROUTED | True | [Bool] | [PASS/FAIL] |
| State ≠ AUTH_FAILED | True | [Bool] | [PASS/FAIL] |
| No IRIS alert created | True | [Bool] | [PASS/FAIL] |
| Counter `p44_packet_target_fail` | +1 | [Delta] | [PASS/FAIL] |
| Counter `p44_packet_routed` | Unchanged | [Count] | [PASS/FAIL] |
| Dedup key created | Yes | [Exists] | [PASS/FAIL] |
| No duplicate storm | No repeat calls | [Log check] | [PASS/FAIL] |

## Recovery Test
1. Restore IRIS (if stopped)
2. Wait for dedup TTL expiry (300s) or new event
3. Send event → should ROUTED

## Evidence
- [ ] State = TARGET_FAILED
- [ ] Not ROUTED / not AUTH_FAILED
- [ ] No IRIS alert
- [ ] Counters correct
- [ ] Dedup key created
- [ ] No duplicate storm
- [ ] Recovery verified after IRIS restore

---
*Generated: 2026-08-27T04:08:00Z (UTC) / 2026-08-27T00:08:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after cache persistence (Phase 45-37)*
