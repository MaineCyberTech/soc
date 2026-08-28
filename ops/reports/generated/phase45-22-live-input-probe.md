# Phase 45: Live Webhook-to-Action Input Probe

## Objective
Prove `execute_python` receives **exact live webhook values** (not static fixtures) using unique markers.

## Probe Design

### Unique Markers
| Marker | Value | Purpose |
|--------|-------|---------|
| `MCT_PROBE_ID` | `live-probe-20260827-001` | Trace request through pipeline |
| `src_ip` | `198.51.100.42` | Unique non-RFC1918 source |
| `dest_ip` | `203.0.113.17` | Unique non-RFC1918 destination |
| `dest_port` | `31337` | Unique high port |
| `signature_id` | `2027967` | Allowlisted SID |

### Probe Payload
```json
{
  "timestamp": "2026-08-27T03:47:00Z",
  "event_type": "alert",
  "alert": {
    "signature_id": 2027967,
    "src_ip": "198.51.100.42",
    "dest_ip": "203.0.113.17",
    "dest_port": 31337,
    "proto": "TCP"
  },
  "MCT_SYNTHETIC": false,
  "MCT_PROBE_ID": "live-probe-20260827-001"
}
```

## Execution via Live Hook
```bash
curl -X POST "http://127.0.0.1:5001/api/v1/hooks/p39-suricata-test" \
  -H "Content-Type: application/json" \
  -d '<PROBE_PAYLOAD_ABOVE>'
```

## Capture Action Input/Output
```bash
# Get execution ID from hook response
EXEC_ID=<from_hook_response>

# Get execution details
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/$EXEC_ID"
```

## Verification: Action Received Exact Values
| Field | Sent | Received in execute_python | Match |
|-------|------|----------------------------|-------|
| `MCT_PROBE_ID` | `live-probe-20260827-001` | [Value from print] | [PASS/FAIL] |
| `src_ip` | `198.51.100.42` | [Value from print] | [PASS/FAIL] |
| `dest_ip` | `203.0.113.17` | [Value from print] | [PASS/FAIL] |
| `dest_port` | `31337` | [Value from print] | [PASS/FAIL] |
| `signature_id` | `2027967` | [Value from print] | [PASS/FAIL] |
| `MCT_SYNTHETIC` | `false` | [Value from print] | [PASS/FAIL] |
| Full payload | Exact JSON match | [SHA256 compare] | [PASS/FAIL] |

## Capture Method
Add to `execute_python` code (temporary for probe):
```python
print(f"PROBE_MARKER: {json.dumps({
    'probe_id': webhook_data.get('MCT_PROBE_ID'),
    'src_ip': alert.get('src_ip'),
    'dest_ip': alert.get('dest_ip'),
    'dest_port': alert.get('dest_port'),
    'sid': alert.get('signature_id'),
    'synthetic': webhook_data.get('MCT_SYNTHETIC'),
    'full_payload_hash': hashlib.sha256(json.dumps(webhook_data, sort_keys=True).encode()).hexdigest()
})}")
```

## Safety Constraints
- **No static fixtures** - all values from live hook
- **Unique markers** - prevent collision with real events
- **No production IRIS** - workflow has placeholder auth
- **Class-A routing disabled** - workflow in `test` status

## Verification Checklist
| Check | Method | Pass/Fail |
|-------|--------|-----------|
| `MCT_PROBE_ID` in action output | Print capture | [PASS/FAIL] |
| `src_ip` exact match | `198.51.100.42` | [PASS/FAIL] |
| `dest_ip` exact match | `203.0.113.17` | [PASS/FAIL] |
| `dest_port` exact match | `31337` | [PASS/FAIL] |
| `signature_id` exact match | `2027967` | [PASS/FAIL] |
| `MCT_SYNTHETIC` exact match | `false` | [PASS/FAIL] |
| Payload hash match | SHA256 compare | [PASS/FAIL] |

## Pass Criteria
- **ALL** fields match exactly
- No transformation/loss between hook → execute_python
- Unique probe ID traces full path

## Next Step
If probe passes: Proceed to Phase 45-23 Capability Decision
If probe fails: Investigate input transformation/loss

---
*Generated: 2026-08-27T03:47:00Z (UTC) / 2026-08-26T23:47:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after hook validity proof (Phase 45-21)*
