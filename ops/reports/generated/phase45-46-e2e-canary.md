# Phase 45: Full Live Packet Canary

## Objective
Generate marked sensor event → capture IDs at every hop → verify end-to-end.

## Canary Marker
| Marker | Value |
|--------|-------|
| `MCT_CANARY_ID` | `e2e-canary-20260827-001` |
| `signature_id` | 2027967 |
| `src_ip` | `198.51.100.99` |
| `dest_ip` | `203.0.113.55` |
| `dest_port` | `443` |
| `proto` | `TCP` |

## Canary Event
```json
{
  "timestamp": "2026-08-27T04:18:00Z",
  "event_type": "alert",
  "alert": {
    "signature_id": 2027967,
    "src_ip": "198.51.100.99",
    "dest_ip": "203.0.113.55",
    "dest_port": 443,
    "proto": "TCP"
  },
  "MCT_SYNTHETIC": false,
  "MCT_CANARY_ID": "e2e-canary-20260827-001"
}
```

## ID Capture Points
| Hop | Component | ID Captured | Method |
|-----|-----------|-------------|--------|
| 1 | Suricata Sensor | `event_id` / `flow_id` | Suricata eve.json |
| 2 | Wazuh Agent | `agent_id`, `event_id` | Wazuh agent log |
| 3 | Wazuh Manager | `event_id`, `rule_id` | Manager log / alert |
| 4 | Wazuh Integration | `integration_id` | Manager log |
| 4 | Shuffle Webhook | `hook_execution_id` | Shuffle hook response |
| 5 | Shuffle Workflow | `execution_id` | Shuffle execution API |
| 6 | Shuffle Action | `action_execution_id` | Shuffle execution details |
| 7 | IRIS | `alert_id` | IRIS API response |
| 8 | Delivery Monitor | `monitor_event_id` | Monitor dashboard |

## Execution
```bash
# Inject canary at Suricata sensor
# Method 1: Trigger rule 2027967 on sensor
# Method 2: Inject via Wazuh (if supported)

# Capture all IDs
```

## ID Correlation Matrix
| ID Type | Sensor | Wazuh Agent | Wazuh Manager | Shuffle Hook | Shuffle Workflow | Shuffle Action | IRIS | Monitor |
|---------|--------|-------------|---------------|--------------|------------------|----------------|------|---------|
| Value | [Val] | [Val] | [Val] | [Val] | [Val] | [Val] | [Val] | [Val] |
| Correlated | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

## Verification
```bash
# 1. Suricata
grep "e2e-canary-20260827-001" /var/log/suricata/eve.json

# 2. Wazuh Agent
grep "e2e-canary-20260827-001" /var/ossec/logs/ossec.log

# 3. Wazuh Manager
grep "e2e-canary-20260827-001" /var/ossec/logs/alerts/alerts.json

# 4. Shuffle Hook
# From hook response: execution_id

# 5. Shuffle Workflow
EXEC_ID=<from_hook>
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/$EXEC_ID"

# 6. IRIS
curl -X GET "https://iriswebapp_nginx:8443/alerts/<ALERT_ID>" \
  -H "Authorization: Bearer <IRIS_ADMIN_TOKEN>"
```

## Verification Checklist
| Hop | ID Captured | Correlated | Pass/Fail |
|-----|-------------|------------|-----------|
| Suricata Sensor | [Y/N] | [Y/N] | [PASS/FAIL] |
| Wazuh Agent | [Y/N] | [Y/N] | [PASS/FAIL] |
| Wazuh Manager | [Y/N] | [Y/N] | [PASS/FAIL] |
| Wazuh Integration | [Y/N] | [Y/N] | [PASS/FAIL] |
| Shuffle Hook | [Y/N] | [Y/N] | [PASS/FAIL] |
| Shuffle Workflow | [Y/N] | [Y/N] | [PASS/FAIL] |
| Shuffle Action | [Y/N] | [Y/N] | [PASS/FAIL] |
| IRIS | [Y/N] | [Y/N] | [PASS/FAIL] |
| Delivery Monitor | [Y/N] | [Y/N] | [PASS/FAIL] |

## Full Path Verification
- [ ] All 9 hops have IDs
- [ ] All IDs correlate to `MCT_CANARY_ID`
- [ ] No ID loss at any hop
- [ ] IRIS alert created with canary marker
- [ ] Delivery monitor records event

## Latency Measurements
| Segment | Latency (ms) |
|---------|--------------|
| Sensor → Wazuh Agent | [ms] |
| Wazuh Agent → Manager | [ms] |
| Manager → Shuffle Hook | [ms] |
| Hook → Workflow Start | [ms] |
| Workflow → IRIS | [ms] |
| **Total End-to-End** | **[ms]** |

## Evidence
- [ ] All 9 IDs captured
- [ ] All IDs correlate
- [ ] IRIS alert created
- [ ] Delivery monitor records
- [ ] Latency within SLA (< 5s total)

## Class-A Impact
- Workflow status: `test`
- IRIS tag: `class:test,phase:45,canary:true`
- No production impact

---
*Generated: 2026-08-27T04:19:00Z (UTC) / 2026-08-27T00:19:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after Wazuh bind (Phase 45-45)*
