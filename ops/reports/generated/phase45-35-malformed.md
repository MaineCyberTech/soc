# Phase 45: Malformed Event Proof

## Objective
Prove missing/invalid required fields → `MALFORMED` with bounded evidence, no routing.

## Test Cases

### 1. Missing SID (signature_id)
```bash
curl -X POST "http://127.0.0.1:5001/api/v1/hooks/p39-suricata-test" \
  -H "Content-Type: application/json" \
  -d '{
    "timestamp": "2026-08-27T04:04:00Z",
    "event_type": "alert",
    "alert": {
      "src_ip": "10.0.0.1",
      "dest_ip": "192.168.1.10",
      "dest_port": 443,
      "proto": "TCP"
    },
    "MCT_SYNTHETIC": false,
    "MCT_TEST": "malformed-missing-sid"
  }'
```

### 2. Missing Source IP
```bash
curl -X POST ... -d '{"alert":{"signature_id":2027967,"dest_ip":"192.168.1.10","dest_port":443,"proto":"TCP"},"MCT_TEST":"malformed-missing-src"}'
```

### 3. Missing Destination IP
```bash
curl -X POST ... -d '{"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_port":443,"proto":"TCP"},"MCT_TEST":"malformed-missing-dst"}'
```

### 4. Missing Port
```bash
curl -X POST ... -d '{"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_ip":"192.168.1.10","proto":"TCP"},"MCT_TEST":"malformed-missing-port"}'
```

### 5. Missing Protocol
```bash
curl -X POST ... -d '{"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_ip":"192.168.1.10","dest_port":443},"MCT_TEST":"malformed-missing-proto"}'
```

### 6. Invalid Port (non-numeric)
```bash
curl -X POST ... -d '{"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_ip":"192.168.1.10","dest_port":"abc","proto":"TCP"},"MCT_TEST":"malformed-invalid-port"}'
```

### 7. Empty Alert Object
```bash
curl -X POST ... -d '{"alert":{},"MCT_TEST":"malformed-empty-alert"}'
```

## Expected Behavior (All Cases)
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| **State** | `malformed` | [State] | [PASS/FAIL] |
| **IRIS called** | **NO** | [No call] | [PASS/FAIL] |
| **Dedup checked** | **NO** | N/A | N/A |
| **Allowlist checked** | **NO** | N/A | [PASS/FAIL] |
| **Counter** | `p44_packet_malformed` +1 | [Delta] | [PASS/FAIL] |
| **Bounded evidence** | Missing field identified | [Field] | [PASS/FAIL] |

## Policy Path
```
START
  → validate_fields: FAIL (missing/invalid required)
  → MALFORMED (dead-letter)
```

## Bounded Evidence Requirements
| Evidence | Required | Actual |
|-----------|----------|--------|
| Missing field identified | Yes (which field) | [Field] |
| No sensitive data leaked | No raw payload in logs | [Check] |
| No routing | IRIS not called | [Verify] |
| Counter incremented | `p44_packet_malformed` +1 | [Delta] |

## Verification
```bash
EXEC_ID=<from_hook>
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/$EXEC_ID"
```

## Expected for Each Test
| Test | Missing Field | Expected State | Counter Delta |
|------|---------------|----------------|---------------|
| Missing SID | signature_id | malformed | +1 |
| Missing Src | src_ip | malformed | +1 |
| Missing Dst | dest_ip | malformed | +1 |
| Missing Port | dest_port | malformed | +1 |
| Missing Proto | proto | malformed | +1 |
| Invalid Port | dest_port (type) | malformed | +1 |
| Empty Alert | All | malformed | +1 |

## Bounded Evidence
- **No raw payload** in logs (only field name)
- **No routing** to IRIS
- **Counter** incremented
- **Field name** logged for operator review

## Counter Verification
| Counter | Delta (per test) |
|---------|------------------|
| `p44_packet_malformed` | +1 each |

## Evidence Collection
- [ ] All 7 tests executed
- [ ] All return `malformed` state
- [ ] No IRIS calls
- [ ] Counter incremented each time
- [ ] Missing field identified in evidence
- [ ] No sensitive data in logs

---
*Generated: 2026-08-27T04:05:00Z (UTC) / 2026-08-27T00:05:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after synthetic test (Phase 45-34)*
