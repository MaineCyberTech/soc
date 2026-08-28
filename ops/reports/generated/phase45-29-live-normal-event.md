# Phase 45: Live Normal Event Proof

## Pre-conditions
- [ ] Trigger running (Phase 45-20)
- [ ] Hook valid (Phase 45-21)
- [ ] Live input probe passed (Phase 45-22)
- [ ] Capability decision = PROCEED (Phase 45-23)
- [ ] IRIS auth object created (Phase 45-25)
- [ ] Auth header regression passed (Phase 45-26)
- [ ] IRIS direct proof passed (Phase 45-27)

## Test: Live Normal Event via Real Webhook
```bash
curl -X POST "http://127.0.0.1:5001/api/v1/hooks/p39-suricata-test" \
  -H "Content-Type: application/json" \
  -d '{
    "timestamp": "2026-08-27T03:56:00Z",
    "event_type": "alert",
    "alert": {
      "signature_id": 2027967,
      "src_ip": "10.0.0.1",
      "dest_ip": "192.168.1.10",
      "dest_port": 443,
      "proto": "TCP"
    },
    "MCT_SYNTHETIC": false,
    "MCT_TEST": "live-normal-20260827"
  }'
```

## Verification
```bash
# Get execution ID
EXEC_ID=<from_hook_response>

# Get execution details
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/$EXEC_ID"
```

## Required Proofs
| Proof | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| **Parsed live fields** | sid=2027967, src=10.0.0.1, dst=192.168.1.10, port=443, proto=TCP | [Values] | [PASS/FAIL] |
| **Policy path** | validate → synthetic_check(FAIL) → allowlist(PASS) → dedup(MISS) → counter+1 → IRIS | [Path] | [PASS/FAIL] |
| **Destination result** | HTTP 200/201 from IRIS | [Code] | [PASS/FAIL] |
| **IRIS object ID** | Valid alert ID returned | [ID] | [PASS/FAIL] |
| **State** | ROUTED | [State] | [PASS/FAIL] |

## Live Field Verification
| Field | Sent | Parsed | Match |
|-------|------|--------|-------|
| signature_id | 2027967 | [Value] | [PASS/FAIL] |
| src_ip | 10.0.0.1 | [Value] | [PASS/FAIL] |
| dest_ip | 192.168.1.10 | [Value] | [PASS/FAIL] |
| dest_port | 443 | [Value] | [PASS/FAIL] |
| proto | TCP | [Value] | [PASS/FAIL] |
| MCT_SYNTHETIC | false | [Value] | [PASS/FAIL] |

## Policy Path Trace
```
START
  → validate_fields: PASS (sid exists)
  → check_synthetic: FALSE (not synthetic)
  → check_allowlist: PASS (sid == 2027967)
  → check_dedup: MISS (first event)
  → increment_counter: p44_packet_routed +1
  → route_to_iris: HTTP 200/201
  → ROUTED
```

## Counter & Dedup Verification
| Metric | Before | After | Delta |
|--------|--------|-------|-------|
| `p44_packet_routed` | [N] | [N+1] | +1 |
| Dedup key `p44_dedup_2027967_10.0.0.1_192.168.1.10_443` | Not exist | Exists | Created |

## IRIS Object Verification
```bash
# On IRIS
curl -X GET "https://iriswebapp_nginx:8443/alerts/<ALERT_ID>" \
  -H "Authorization: Bearer <IRIS_ADMIN_TOKEN>"
```

| IRIS Field | Expected |
|------------|----------|
| alert_source | suricata |
| alert_source_ref | 2027967-10.0.0.1 |
| alert_source_content.sid | 2027967 |
| alert_tags | Contains source:suricata |

## Evidence
- [ ] Hook response captured
- [ ] Execution ID recorded
- [ ] Parsed fields match sent values
- [ ] Policy path matches expected
- [ ] IRIS HTTP 200/201
- [ ] IRIS alert ID captured
- [ ] State = ROUTED
- [ ] Counter incremented
- [ ] Dedup key created

## Class-A Impact
- Workflow status: `test`
- No production routing enabled
- **NO IMPACT** to Class-A

---
*Generated: 2026-08-27T03:57:00Z (UTC) / 2026-08-26T23:57:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after IRIS direct proof (Phase 45-27)*
