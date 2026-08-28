# Phase 45: IRIS Authentication Failure Proof

## Objective
Prove invalid auth → `AUTH_FAILED` state (not `TARGET_FAILED`), no delivery, bounded evidence.

## Test Setup
Temporarily invalidate auth object:
1. Rename `IRIS_API_TOKEN` → `IRIS_API_TOKEN_INVALID`
2. Or set empty value
3. Or use malformed token

## Test Execution
```bash
# With invalid auth object reference
curl -X POST "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execute" \
  -H "Authorization: Bearer $NT" \
  -H "Content-Type: application/json" \
  -d '{"data": "{\"timestamp\":\"2026-08-27T03:54:00Z\",\"event_type\":\"alert\",\"alert\":{\"signature_id\":2027967,\"src_ip\":\"10.0.0.1\",\"dest_ip\":\"192.168.1.10\",\"dest_port\":443,\"proto\":\"TCP\"},\"MCT_SYNTHETIC\":false}"}'
```

## Expected Behavior
| Component | Expected |
|-----------|----------|
| Shuffle renders header | `Authorization: Bearer ` (empty or malformed) |
| IRIS responds | HTTP 401 "Authentication required" |
| Workflow classifies | `AUTH_FAILED` (not `TARGET_FAILED`) |
| IRIS alert created | **NO** |
| Counter `p44_packet_routed` | **NOT incremented** |
| Dedup key | **NOT created** |
| State | `AUTH_FAILED` |

## Verification
```bash
# Get execution details
EXEC_ID=<from_response>
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/$EXEC_ID"
```

## Verification Checklist
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| Execution state | `AUTH_FAILED` | [State] | [PASS/FAIL] |
| IRIS HTTP status | 401 | [Code] | [PASS/FAIL] |
| State ≠ TARGET_FAILED | True | [Bool] | [PASS/FAIL] |
| IRIS alert created | **NO** | [Yes/No] | [PASS/FAIL] |
| Counter `p44_packet_routed` | Unchanged | [Count] | [PASS/FAIL] |
| Dedup key created | **NO** | [Exists] | [PASS/FAIL] |
| Bounded evidence | No token leaked | [Check logs] | [PASS/FAIL] |

## Bounded Evidence Rules
- **NO** token values in logs/execution results
- **NO** full Authorization header in logs
- **YES** Error classification (`AUTH_FAILED`)
- **YES** HTTP status code (401)
- **YES** State machine path taken

## Restore Valid Auth
1. Rename `IRIS_API_TOKEN_INVALID` → `IRIS_API_TOKEN`
2. Or restore valid token value
3. Verify Phase 45-27 still passes

## Evidence Collection
- [ ] Execution state = AUTH_FAILED
- [ ] IRIS HTTP 401 captured
- [ ] No alert created in IRIS
- [ ] Counter not incremented
- [ ] No token/secret in any log/output
- [ ] State machine path: route_to_iris → auth_error → AUTH_FAILED

## Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Engineer | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

---
*Generated: 2026-08-27T03:55:00Z (UTC) / 2026-08-26T23:55:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after direct proof (Phase 45-27)*
