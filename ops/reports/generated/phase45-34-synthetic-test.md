# Phase 45: Synthetic Isolation Proof

## Objective
Prove `MCT_SYNTHETIC: true` → isolated sink, no real counters/production/billing/scorecard impact.

## Test
```bash
curl -X POST "http://127.0.0.1:5001/api/v1/hooks/p39-suricata-test" \
  -H "Content-Type: application/json" \
  -d '{
    "timestamp": "2026-08-27T04:02:00Z",
    "event_type": "alert",
    "alert": {
      "signature_id": 2027967,
      "src_ip": "10.0.0.1",
      "dest_ip": "192.168.1.10",
      "dest_port": 443,
      "proto": "TCP"
    },
    "MCT_SYNTHETIC": true,
    "MCT_TEST": "synthetic-isolation-20260827"
  }'
```

## Expected Behavior
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| **State** | `synthetic` | [State] | [PASS/FAIL] |
| **Real counters unchanged** | `p44_packet_routed`, `duplicate`, `suppressed`, `malformed` all unchanged | [Counts] | [PASS/FAIL] |
| **Synthetic counter** | `p44_packet_synthetic` +1 | [Delta] | [PASS/FAIL] |
| **IRIS called** | **NO** | [No call] | [PASS/FAIL] |
| **Dedup checked** | **NO** (blocked earlier) | N/A | N/A |
| **Allowlist checked** | **NO** (blocked earlier) | N/A | N/A |

## Policy Path
```
START
  → validate_fields: PASS
  → check_synthetic: TRUE
  → SYNTHETIC_TEST (sink/log-only)
```

## Isolation Guarantees
| System | Impact | Verification |
|--------|--------|--------------|
| **Production routing** | None | No IRIS call |
| **Real counters** | None | `routed`, `duplicate`, `suppressed`, `malformed` unchanged |
| **Billing** | None | No IRIS object → no billing event |
| **Scorecards** | None | No production alert → no scorecard impact |
| **Dedup cache** | None | Not checked |
| **IRIS** | None | No API call |

## Synthetic Counter
| Counter | Purpose |
|---------|---------|
| `p44_packet_synthetic` | Count synthetic events for test tracking |

## Verification
```bash
EXEC_ID=<from_hook>
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/$EXEC_ID"

# Check all counters
```

## Counter Verification
| Counter | Before | After | Delta |
|---------|--------|-------|-------|
| `p44_packet_routed` | [N] | [N] | 0 |
| `p44_packet_duplicate` | [M] | [M] | 0 |
| `p44_packet_suppressed` | [K] | [K] | 0 |
| `p44_packet_malformed` | [L] | [L] | 0 |
| `p44_packet_synthetic` | [S] | [S+1] | +1 |

## Sink Verification
- Synthetic events logged to isolated sink (print/log)
- No external system contacted
- No persistent state modified except synthetic counter

## Evidence
- [ ] State = `synthetic`
- [ ] All real counters unchanged
- [ ] Synthetic counter incremented
- [ ] No IRIS call
- [ ] No dedup/allowlist check
- [ ] No production system touched

## Production Safety
- **Zero risk** - synthetic events fully isolated
- **Test-safe** - can run unlimited synthetic tests
- **Observable** - synthetic counter tracks test volume

---
*Generated: 2026-08-27T04:03:00Z (UTC) / 2026-08-27T00:03:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after non-allowlisted (Phase 45-33)*
