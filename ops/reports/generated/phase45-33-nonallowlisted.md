# Phase 45: Non-Allowlisted SID Proof

## Objective
Prove non-allowlisted SID → `POLICY_SUPPRESSED` (not `MALFORMED`).

## Test
```bash
curl -X POST "http://127.0.0.1:5001/api/v1/hooks/p39-suricata-test" \
  -H "Content-Type: application/json" \
  -d '{
    "timestamp": "2026-08-27T04:01:00Z",
    "event_type": "alert",
    "alert": {
      "signature_id": 999999,
      "src_ip": "10.0.0.1",
      "dest_ip": "192.168.1.10",
      "dest_port": 443,
      "proto": "TCP"
    },
    "MCT_SYNTHETIC": false,
    "MCT_TEST": "nonallowlisted-999999"
  }'
```

## Expected Behavior
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| **State** | `not_allowed` (POLICY_SUPPRESSED) | [State] | [PASS/FAIL] |
| **Not MALFORMED** | State ≠ `malformed` | [Bool] | [PASS/FAIL] |
| **Structurally valid** | All fields present | [Bool] | [PASS/FAIL] |
| **SID parsed** | 999999 | [Value] | [PASS/FAIL] |
| **Fields parsed** | src/dst/port/proto all present | [Bool] | [PASS/FAIL] |
| **IRIS called** | **NO** | [No call] | [PASS/FAIL] |
| **Counter** | `p44_packet_suppressed` +1 | [Count] | [PASS/FAIL] |
| **Dedup** | Not checked (blocked earlier) | N/A | N/A |

## Policy Path
```
START
  → validate_fields: PASS (all fields present)
  → check_synthetic: FALSE
  → check_allowlist: FAIL (999999 ≠ 2027967)
  → POLICY_SUPPRESSED (not_allowed)
```

## Key Distinction: MALFORMED vs POLICY_SUPPRESSED
| Criteria | MALFORMED | POLICY_SUPPRESSED |
|----------|-----------|-------------------|
| Root cause | Missing/invalid fields | Valid fields, policy reject |
| SID parsed | May fail | Must succeed |
| Fields present | At least one missing | All present |
| Action | Dead-letter | Observe/suppress |
| Alerting | High (data quality) | Low (policy) |

## Verification
```bash
EXEC_ID=<from_hook>
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/$EXEC_ID"
```

## Verification Checklist
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| State | `not_allowed` | [State] | [PASS/FAIL] |
| State ≠ `malformed` | True | [Bool] | [PASS/FAIL] |
| SID parsed | 999999 | [Value] | [PASS/FAIL] |
| All fields parsed | True | [Bool] | [PASS/FAIL] |
| No IRIS call | True | [Bool] | [PASS/FAIL] |
| Counter `p44_packet_suppressed` | +1 | [Delta] | [PASS/FAIL] |

## Production Classification
- **Not an error** - valid event, policy decision
- **Observable** - counted in `packet.suppressed.count`
- **No alert fatigue** - not routed to IRIS
- **Audit trail** - available for policy review

## Multiple Non-Allowlisted SIDs
| SID | Expected |
|-----|----------|
| 999999 | POLICY_SUPPRESSED |
| 1000000 | POLICY_SUPPRESSED |
| 1 | POLICY_SUPPRESSED |
| 2027966 | POLICY_SUPPRESSED |
| 2027968 | POLICY_SUPPRESSED |

## Evidence
- [ ] State = `not_allowed`
- [ ] State ≠ `malformed`
- [ ] SID = 999999 parsed
- [ ] All fields parsed
- [ ] No IRIS call
- [ ] Counter incremented

---
*Generated: 2026-08-27T04:02:00Z (UTC) / 2026-08-27T00:02:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after key collision (Phase 45-32)*
