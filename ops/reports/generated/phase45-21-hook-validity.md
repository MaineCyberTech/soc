# Phase 45: Hook Validity Proof

## Pre-conditions
- Trigger `suricata-eve-in` started via Shuffle UI (Phase 45-20)
- Trigger status: `running` in UI and workflow JSON
- Hook endpoint: `/api/v1/hooks/p39-suricata-test`

## Probe Request
```bash
curl -X POST "http://127.0.0.1:5001/api/v1/hooks/p39-suricata-test" \
  -H "Content-Type: application/json" \
  -d '{
    "timestamp": "2026-08-27T03:46:00Z",
    "event_type": "alert",
    "alert": {
      "signature_id": 2027967,
      "src_ip": "10.0.0.1",
      "dest_ip": "192.168.1.10",
      "dest_port": 443,
      "proto": "TCP"
    },
    "MCT_SYNTHETIC": false,
    "MCT_PROBE": "hook-validity-20260827"
  }'
```

## Expected Response
| Field | Expected Value |
|-------|----------------|
| **HTTP Status** | 200 OK (or 202 Accepted) |
| **Response Body** | `{"success": true, "execution_id": "...", "authorization": "..."}` |
| **Source** | `webhook` (in execution metadata) |

## Execution Verification
```bash
# Check latest execution for this workflow
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/executions" | jq '.[-1]'
```

## Verification Checklist
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| Hook responds | HTTP 200/202 | [Code] | [PASS/FAIL] |
| Execution created | Yes | [Yes/No + ID] | [PASS/FAIL] |
| Execution source | `webhook` | [Source] | [PASS/FAIL] |
| Workflow revision | Current (edited 2026-08-26T20:57:45Z) | [Rev] | [PASS/FAIL] |
| Execution argument | Contains probe payload | [Arg] | [PASS/FAIL] |
| Execution status | EXECUTING/COMPLETED | [Status] | [PASS/FAIL] |

## Execution Result Verification
```bash
# Get execution details
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/<EXECUTION_ID>"
```

| State | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| Parse step | SUCCESS | [Status] | [PASS/FAIL] |
| State | SYNTHETIC_TEST/ROUTED/DUPLICATE/etc | [State] | [PASS/FAIL] |
| IRIS call | Attempted (401 expected) | [Status] | [PASS/FAIL] |
| Terminal state | One of schema states | [State] | [PASS/FAIL] |

## Failure Criteria
- Hook returns 404/400/500 → **HOOK INVALID**
- No execution created → **TRIGGER NOT REGISTERED**
- Source != webhook → **WRONG TRIGGER PATH**
- Workflow revision mismatch → **STALE REVISION**

## Evidence Collection
- [ ] Hook response captured
- [ ] Execution ID recorded
- [ ] Execution source = webhook confirmed
- [ ] Workflow revision matches current
- [ ] Terminal state matches schema

## Next Step
If hook valid: Proceed to Phase 45-22 Live Input Probe
If hook invalid: Revert trigger start, investigate registration

---
*Generated: 2026-08-27T03:46:00Z (UTC) / 2026-08-26T23:46:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after trigger start (Phase 45-20)*
