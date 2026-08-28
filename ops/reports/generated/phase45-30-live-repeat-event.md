# Phase 45: Live Duplicate Proof

## Pre-conditions
- [ ] Phase 45-29 Live Normal Event completed (dedup key exists)
- [ ] Dedup key `p44_dedup_2027967_10.0.0.1_192.168.1.10_443` in cache (TTL 300s)

## Test: Repeat Identical Event
```bash
curl -X POST "http://127.0.0.1:5001/api/v1/hooks/p39-suricata-test" \
  -H "Content-Type: application/json" \
  -d '{
    "timestamp": "2026-08-27T03:57:00Z",
    "event_type": "alert",
    "alert": {
      "signature_id": 2027967,
      "src_ip": "10.0.0.1",
      "dest_ip": "192.168.1.10",
      "dest_port": 443,
      "proto": "TCP"
    },
    "MCT_SYNTHETIC": false,
    "MCT_TEST": "live-repeat-20260827"
  }'
```

## Verification
```bash
EXEC_ID=<from_hook_response>
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/$EXEC_ID"
```

## Required Proofs
| Proof | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| **Cache lookup** | Dedup key HIT | [Hit/Miss] | [PASS/FAIL] |
| **Duplicate suppression** | No second IRIS call | [No call] | [PASS/FAIL] |
| **State** | DUPLICATE | [State] | [PASS/FAIL] |
| **Metric** | `packet.duplicate.count` +1 | [Count] | [PASS/FAIL] |
| **Counter** | `p44_packet_routed` unchanged | [Count] | [PASS/FAIL] |
| **IRIS object** | No second object | [No new ID] | [PASS/FAIL] |

## Policy Path Trace
```
START
  → validate_fields: PASS
  → check_synthetic: FALSE
  → check_allowlist: PASS
  → check_dedup: HIT (key exists)
  → DUPLICATE
```

## Verification Checklist
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| Dedup key exists | Yes (from Phase 45-29) | [Yes] | [PASS/FAIL] |
| Execution state | DUPLICATE | [State] | [PASS/FAIL] |
| IRIS API called | **NO** | [No call in logs] | [PASS/FAIL] |
| `p44_packet_routed` | Unchanged | [Count] | [PASS/FAIL] |
| `p44_packet_duplicate` | +1 | [Count] | [PASS/FAIL] |
| Dedup key TTL | Still valid (<300s) | [TTL] | [PASS/FAIL] |

## IRIS Verification
```bash
# Confirm no new alert
curl -X GET "https://iriswebapp_nginx:8443/alerts?tag=source:suricata&limit=10" \
  -H "Authorization: Bearer <IRIS_ADMIN_TOKEN>"
# Should show same count as after Phase 45-29
```

## Metric Verification
| Counter | Phase 45-29 | Phase 45-30 | Delta |
|---------|-------------|-------------|-------|
| `p44_packet_routed` | [N] | [N] | 0 |
| `p44_packet_duplicate` | [M] | [M+1] | +1 |

## Evidence
- [ ] Hook response captured
- [ ] Execution state = DUPLICATE
- [ ] No IRIS API call in logs
- [ ] `p44_packet_routed` unchanged
- [ ] `p44_packet_duplicate` incremented
- [ ] Dedup key still valid (TTL > 0)

## TTL Edge Case
If >300s elapsed since Phase 45-29:
- Dedup key expired → event treated as NEW → ROUTED
- Document actual TTL at time of repeat

---
*Generated: 2026-08-27T03:58:00Z (UTC) / 2026-08-26T23:58:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after live normal event (Phase 45-29)*
