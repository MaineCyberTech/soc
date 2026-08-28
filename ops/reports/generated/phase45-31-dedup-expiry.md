# Phase 45: Dedup TTL Expiry Proof

## Objective
Prove 300-second TTL expiry works: key expires → event rerouted as new.

## Test Design
| Phase | Action | Time | Expected |
|-------|--------|------|----------|
| 1 | Send event | T0 | ROUTED (key created) |
| 2 | Repeat immediately | T0+1s | DUPLICATE (key hit) |
| 3 | Wait 300s | T0+300s | Key expires |
| 4 | Repeat after expiry | T0+301s | ROUTED (key expired) |

## Execution
```bash
# Phase 1: Initial event
curl -X POST "http://127.0.0.1:5001/api/v1/hooks/p39-suricata-test" \
  -H "Content-Type: application/json" \
  -d '{"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_ip":"192.168.1.10","dest_port":443,"proto":"TCP"},"MCT_SYNTHETIC":false,"MCT_TEST":"ttl-test-1"}'

# Phase 2: Immediate repeat (should DUPLICATE)
curl -X POST ... -d '{"MCT_TEST":"ttl-test-2",...}'

# Phase 3: Wait 300 seconds
sleep 300

# Phase 4: After expiry (should ROUTED)
curl -X POST ... -d '{"MCT_TEST":"ttl-test-3",...}'
```

## Verification
| Phase | Test | Expected State | Dedup Key | Counter |
|-------|------|----------------|-----------|---------|
| 1 | Initial | ROUTED | Created | +1 |
| 2 | Immediate | DUPLICATE | Hit | Unchanged |
| 3 | Wait | - | Expired | - |
| 4 | After expiry | ROUTED | Miss (new) | +1 |

## Verification
```bash
# Check cache directly (if Shuffle exposes)
# Or infer from state transitions
```

## Verification Checklist
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| Phase 1 | ROUTED | [State] | [PASS/FAIL] |
| Phase 2 | DUPLICATE | [State] | [PASS/FAIL] |
| Phase 4 (after 300s) | ROUTED | [State] | [PASS/FAIL] |
| Phase 4 counter | +1 from Phase 1 | [Delta] | [PASS/FAIL] |
| No production contamination | Test markers only | [Clean] | [PASS/FAIL] |

## Production Safety
- All events tagged `MCT_TEST: ttl-test-*`
- Workflow status: `test`
- IRIS auth: valid but test classification
- No Class-A impact

## Reroute Behavior
- Key expired → cache miss → treated as NEW event
- Full policy path executed (validate → synthetic → allowlist → dedup MISS → counter → IRIS)
- **Not** silently dropped or misclassified

## Evidence
- [ ] Phase 1: ROUTED, counter +1, key created
- [ ] Phase 2: DUPLICATE, counter unchanged, key hit
- [ ] Phase 4: ROUTED, counter +1, key miss
- [ ] TTL measured ≈ 300s
- [ ] No production alerts contaminated

## Evidence Collection
- [ ] All 4 execution IDs recorded
- [ ] States match expected
- [ ] Counter deltas correct
- [ ] TTL measured ≈ 300s ± 5s

---
*Generated: 2026-08-27T03:59:00Z (UTC) / 2026-08-26T23:59:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after live repeat (Phase 45-30)*
