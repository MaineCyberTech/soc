# Phase 45: Cache Persistence Proof

## Cache Types
| Cache | Purpose | Backend | Persistence |
|-------|---------|---------|-------------|
| Dedup (`p44_dedup`) | 300s TTL duplicate detection | Shuffle cache (Redis) | In-memory |
| Counters (`p44_counters`) | Packet routing metrics | Shuffle cache (Redis) | In-memory |

## Persistence Matrix
| Event | Dedup Cache | Counters Cache |
|-------|-------------|----------------|
| Workflow restart (UI) | **Preserved** | **Preserved** |
| Shuffle backend restart | **Lost** | **Lost** |
| Host reboot | **Lost** | **Lost** |
| Redis flush | **Lost** | **Lost** |
| Network partition | **Unavailable** | **Unavailable** |

## Test 1: Workflow Restart
```bash
# 1. Create dedup key
curl -X POST ... -d '{"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_ip":"192.168.1.10","dest_port":443,"proto":"TCP"},"MCT_TEST":"cache-restart-1"}'
# Expected: ROUTED, key created

# 2. Restart workflow via Shuffle UI
# (Settings → Workflows → suricata-packet-routing → Restart)

# 3. Repeat same event
curl -X POST ... -d '{"MCT_TEST":"cache-restart-2",...}'
# Expected: DUPLICATE (key survived restart)
```

### Verification
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| Dedup key survives workflow restart | Yes | [Hit/Miss] | [PASS/FAIL] |
| Repeat event after restart | DUPLICATE | [State] | [PASS/FAIL] |

## Test 2: Shuffle Backend Restart
```bash
# 1. Create dedup key
curl ... -d '{"MCT_TEST":"cache-backend-1"}'
# Expected: ROUTED

# 2. Restart Shuffle backend
docker restart shuffle-backend

# 3. Wait for backend ready
sleep 10

# 4. Repeat same event
curl ... -d '{"MCT_TEST":"cache-backend-2",...}'
# Expected: ROUTED (key lost, treated as new)
```

### Verification
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| Dedup key survives backend restart | **No** | [Hit/Miss] | [PASS/FAIL] |
| Repeat event after backend restart | ROUTED | [State] | [PASS/FAIL] |

## Test 3: Host Reboot
```bash
# 1. Create dedup key
curl ... -d '{"MCT_TEST":"cache-reboot-1"}'

# 2. Reboot host
sudo reboot

# 3. After reboot, repeat
curl ... -d '{"MCT_TEST":"cache-reboot-2",...}'
# Expected: ROUTED (key lost)
```

## Persistence Semantics
| Cache | Survives Workflow Restart | Survives Backend Restart | Survives Host Reboot |
|-------|---------------------------|--------------------------|----------------------|
| Dedup | ✅ Yes | ❌ No | ❌ No |
| Counters | ✅ Yes | ❌ No | ❌ No |

## Risk Assessment
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Backend restart clears dedup | Medium (updates, crashes) | Duplicate alerts for 300s | Acceptable (short window) |
| Counter loss on restart | Medium | Metrics gap until next reset | Daily reset covers |
| Network partition | Low | Cache unavailable → events may route as new | Circuit breaker |

## Expected Behavior on Cache Miss
| Scenario | Behavior |
|----------|----------|
| Cache unavailable | Event processed as NEW (no dedup) → ROUTED if allowed |
| Redis flush | All keys lost → fresh start |
| Network partition | Graceful degradation → route as new |

## Verification
| Test | Expected | Actual | Pass/Fail |
|------|----------|--------|-----------|
| Workflow restart preserves dedup | DUPLICATE | [State] | [PASS/FAIL] |
| Backend restart loses dedup | ROUTED (new) | [State] | [PASS/FAIL] |
| Counters survive workflow restart | Preserved | [Counts] | [PASS/FAIL] |
| Counters lost on backend restart | Reset to 0 | [Counts] | [PASS/FAIL] |

## Risk Acceptance
| Risk | Accepted | Reason |
|------|----------|--------|
| 300s duplicate window after restart | ✅ Yes | Short window, low volume |
| Counter reset on backend restart | ✅ Yes | Daily reset covers |
| No persistent external store | ✅ Yes | Not required for Phase 45 |

## External Store (Future)
| Option | Pros | Cons |
|--------|------|------|
| Redis persistence (AOF/RDB) | Survives restart | Config complexity |
| PostgreSQL | Full durability | Overhead |
| External Redis cluster | HA | Infrastructure cost |

## Evidence
- [ ] Workflow restart: Dedup preserved → DUPLICATE
- [ ] Backend restart: Dedup lost → ROUTED
- [ ] Counters: Survive workflow restart
- [ ] Counters: Lost on backend restart

---
*Generated: 2026-08-27T04:07:00Z (UTC) / 2026-08-27T00:07:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after counter persistence (Phase 45-36)*
