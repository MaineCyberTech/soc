# Phase 45: IRIS Direct Authenticated Proof

## Pre-conditions
- [ ] Phase 45-25: IRIS auth object `IRIS_API_TOKEN` created
- [ ] Phase 45-26: Auth header regression test passed
- [ ] Workflow references `{{IRIS_API_TOKEN}}` template
- [ ] Workflow status: `test` (Class-A routing disabled)

## Test Execution
```bash
# Execute workflow with normal event
curl -X POST "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execute" \
  -H "Authorization: Bearer $NT" \
  -H "Content-Type: application/json" \
  -d '{"data": "{\"timestamp\":\"2026-08-27T03:52:00Z\",\"event_type\":\"alert\",\"alert\":{\"signature_id\":2027967,\"src_ip\":\"10.0.0.1\",\"dest_ip\":\"192.168.1.10\",\"dest_port\":443,\"proto\":\"TCP\"},\"MCT_SYNTHETIC\":false}"}'
```

## Verification
```bash
# Get execution ID from response
EXEC_ID=<from_response>

# Get execution details
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/$EXEC_ID"
```

## Success Criteria
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| HTTP status from IRIS | 200 or 201 | [Code] | [PASS/FAIL] |
| IRIS response contains alert ID | Yes (object ID) | [ID] | [PASS/FAIL] |
| Execution state | ROUTED | [State] | [PASS/FAIL] |
| Counter incremented | `p44_packet_routed` +1 | [Count] | [PASS/FAIL] |
| Dedup key created | `p44_dedup_2027967_10.0.0.1_192.168.1.10_443` | [Exists] | [PASS/FAIL] |

## IRIS Object Verification
```bash
# On IRIS side (if accessible)
# Check alert was created
curl -X GET "https://iriswebapp_nginx:8443/alerts/<ALERT_ID>" \
  -H "Authorization: Bearer <IRIS_ADMIN_TOKEN>"
```

| IRIS Field | Expected | Actual |
|-----------|----------|---------|
| `alert_title` | "Suricata Packet Alert" | [Value] |
| `alert_source` | "suricata" | [Value] |
| `alert_source_ref` | "2027967-10.0.0.1" | [Value] |
| `alert_source_content.sid` | 2027967 | [Value] |
| `alert_source_content.src` | "10.0.0.1" | [Value] |
| `alert_source_content.dst` | "192.168.1.10" | [Value] |
| `alert_source_content.port` | 443 | [Value] |
| `alert_source_content.proto` | "TCP" | [Value] |
| `alert_tags` | Contains "source:suricata" | [Value] |

## Isolated Test Classification
- **Alert Tag:** `class:test,phase:45,proof:direct`
- **IRIS Filter:** `tag:class:test AND tag:phase:45`
- **Cleanup:** Delete test alerts after proof

## Counter Verification
```bash
# Check counter
curl -X POST "http://127.0.0.1:5001/api/v1/workflows/<daily-counter-workflow>/execute" \
  -H "Authorization: Bearer $NT" \
  -d '{"action": "get", "key": "p44_packet_routed", "category": "p44_counters"}'
```

| Counter | Before | After | Delta |
|---------|--------|-------|-------|
| `p44_packet_routed` | [N] | [N+1] | +1 |

## Failure Criteria
- HTTP != 200/201 → **FAIL** (auth, network, IRIS config)
- No alert ID in response → **FAIL**
- Counter not incremented → **FAIL**

## Cleanup
- Delete test alert from IRIS
- Record alert ID for audit

## Evidence
- [ ] HTTP 200/201 captured
- [ ] IRIS alert ID captured
- [ ] Execution state = ROUTED
- [ ] Counter incremented
- [ ] Dedup key created

## Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Engineer | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

---
*Generated: 2026-08-27T03:53:00Z (UTC) / 2026-08-26T23:53:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after auth header regression (Phase 45-26)*
