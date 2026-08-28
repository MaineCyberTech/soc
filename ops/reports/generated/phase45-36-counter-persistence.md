# Phase 45: Counter Persistence Proof

## Counters Under Test
| Counter | Key | Category | Type |
|---------|-----|----------|------|
| Packet Routed | `p44_packet_routed` | `p44_counters` | Real |
| Packet Synthetic | `p44_packet_synthetic` | `p44_counters` | Synthetic |
| Packet Suppressed | `p44_packet_suppressed` | `p44_counters` | Policy |
| Packet Duplicate | `p44_packet_duplicate` | `p44_counters` | Dedup |
| Packet Malformed | `p44_packet_malformed` | `p44_counters` | Error |

## Test 1: Atomic Increment
```bash
# Send 10 rapid normal events
for i in {1..10}; do
  curl -X POST "http://127.0.0.1:5001/api/v1/hooks/p39-suricata-test" \
    -H "Content-Type: application/json" \
    -d "{\"alert\":{\"signature_id\":2027967,\"src_ip\":\"10.0.0.$i\",\"dest_ip\":\"192.168.1.10\",\"dest_port\":443,\"proto\":\"TCP\"},\"MCT_TEST\":\"atomic-$i\"}" &
done
wait
```

### Verification
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| Counter value | 10 (exact) | [Value] | [PASS/FAIL] |
| No lost increments | 10 events → +10 | [Delta] | [PASS/FAIL] |

## Test 2: Real/Synthetic Separation
```bash
# Record baseline
C_ROUTED_BEFORE=<value>
C_SYNTHETIC_BEFORE=<value>

# Send 5 real events
for i in {1..5}; do curl ... -d '{"MCT_SYNTHETIC":false,"MCT_TEST":"sep-real-$i"}' & done

# Send 5 synthetic events
for i in {1..5}; do curl ... -d '{"MCT_SYNTHETIC":true,"MCT_TEST":"sep-synth-$i"}' & done
wait
```

### Verification
| Counter | Before | After | Delta | Expected |
|---------|--------|-------|-------|----------|
| `p44_packet_routed` | [N] | [N+5] | +5 | Real only |
| `p44_packet_synthetic` | [M] | [M+5] | +5 | Synthetic only |
| Cross-contamination | N/A | N/A | 0 | None |

## Test 3: Restart Durability
| Event | Expected Counter State |
|-------|------------------------|
| Workflow restart (UI) | **Preserved** (cache external) |
| Shuffle backend restart | **Lost** (Redis flush) |
| Host reboot | **Lost** (Redis flush) |

### Test Procedure
1. Record counter values
2. Restart workflow via UI
3. Verify counters preserved
4. (Optional) Restart Shuffle backend → verify lost

## Test 4: Daily Reset Behavior
| Schedule | Method | Verification |
|----------|--------|--------------|
| 00:00 UTC | Cron/scheduled workflow | Counters → 0 |
| On-demand | Manual API call | Counters → 0 |

```bash
# Manual reset test
curl -X POST "http://127.0.0.1:5001/api/v1/workflows/<reset-workflow>/execute" \
  -H "Authorization: Bearer $NT" \
  -d '{"action": "reset_all_counters"}'

# Verify all counters = 0
```

## Test 5: Visible Monitoring State
```bash
# Read all counters
for counter in p44_packet_routed p44_packet_synthetic p44_packet_suppressed p44_packet_duplicate p44_packet_malformed; do
  curl -X POST ... -d '{"action":"get","key":"'$counter'","category":"p44_counters"}'
done
```

### Monitoring Requirements
| Requirement | Implementation |
|-------------|----------------|
| Real-time visibility | Shuffle cache readable via API |
| Historical trend | Daily snapshots + reset |
| Alert thresholds | >1000/hr routed, >10/hr target_fail |
| Dashboard | Grafana/Prometheus scraping cache API |

## Evidence Collection
- [ ] Atomic increment: 10 events = +10 exact
- [ ] Real/synthetic: No cross-contamination
- [ ] Workflow restart: Counters preserved
- [ ] Daily reset: Counters → 0 at 00:00 UTC
- [ ] Monitoring: All counters readable via API

## Counter State API
```bash
# Get single counter
curl -X POST "http://127.0.0.1:5001/api/v1/workflows/<counter-workflow>/execute" \
  -H "Authorization: Bearer $NT" \
  -d '{"action":"get","key":"p44_packet_routed","category":"p44_counters"}'

# Get all counters (batch)
curl -X POST ... -d '{"action":"get_all","category":"p44_counters"}'
```

## Evidence Collection
- [ ] Atomic increment: 10 rapid = +10 exact
- [ ] Real/synthetic: Zero cross-contamination
- [ ] Workflow restart: Counters survive
- [ ] Daily reset: Verified at 00:00 UTC
- [ ] API readable: All counters queryable

---
*Generated: 2026-08-27T04:06:00Z (UTC) / 2026-08-27T00:06:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after malformed (Phase 45-35)*
