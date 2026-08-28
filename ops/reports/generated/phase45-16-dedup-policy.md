# Phase 45: Deduplication Policy Decision

## Policy Summary
| Parameter | Value | Rationale |
|-----------|-------|-----------|
| **TTL** | 300 seconds (5 minutes) | Balances alert fatigue reduction with detection sensitivity; Suricata can burst similar alerts within minutes |
| **Key Format** | `p44_dedup_{sid}_{src}_{dst}_{port}` | Unique per alert signature + 5-tuple; excludes protocol to catch protocol-agnostic duplicates |
| **Category** | `p44_dedup` | Isolated namespace |
| **Value** | `1` (presence) | Minimal storage |
| **Restart Durability** | **No** | Shuffle cache is in-memory; restart clears dedup state |
| **Concurrency** | Single-threaded per workflow execution | Shuffle serializes workflow runs |

## Key Components
| Component | Included | Reason |
|-----------|----------|--------|
| Signature ID (sid) | ✅ | Core alert identifier |
| Source IP (src) | ✅ | Attack origin |
| Destination IP (dst) | ✅ | Target |
| Destination Port (port) | ✅ | Service target |
| Protocol (proto) | ❌ | Excluded: same attack over TCP/UDP should dedup |
| Agent ID | ❌ | Excluded: same alert from multiple sensors should dedup |
| Timestamp | ❌ | TTL handles time window |

## Collision & Fallback Rules
| Scenario | Behavior |
|----------|----------|
| Key collision (different events, same key) | **False positive dedup** - accepted risk; low probability with sid+5-tuple |
| Cache miss (key expired) | Event processed as new (counter increments, IRIS routed) |
| Cache error (datastore failure) | **DATASTORE_FAILED** state; event NOT silently dropped |
| Concurrent identical events | Shuffle serializes; first wins, second sees cache hit |

## IRIS Duplicate Expectations
- **IRIS receives deduplicated stream** - only first event per 300s window routed
- **IRIS may still receive duplicates** if:
  - Workflow restarted (cache cleared)
  - TTL expired between bursts
  - Multiple Shuffle instances (not deployed)
- **IRIS-side dedup recommended** - IRIS should implement its own dedup on `alert_source_ref`

## Restart Behavior
```
Workflow Restart
    → Shuffle cache cleared
    → All dedup keys lost
    → Next event for any key → MISS → ROUTED (if allowed)
    → New 300s window starts
```
**Mitigation:** Persistent dedup requires external store (Redis/DB) - not implemented.

## Concurrency Model
- Shuffle executes workflow runs **sequentially** per trigger
- No race condition on cache check-then-set
- `check_cache_contains(append=False)` is atomic read

## Testing Requirements
| Test | Expected |
|------|----------|
| Same 5-tuple within 300s | DUPLICATE |
| Same 5-tuple after 300s | ROUTED (new) |
| Different port, same sid/src/dst | ROUTED (different key) |
| Workflow restart + immediate repeat | ROUTED (cache cleared) |
| Cache error simulation | DATASTORE_FAILED state |

## Configuration
```python
# In execute_python action
DEDUP_TTL = 300
DEDUP_CATEGORY = "p44_dedup"
DEDUP_KEY_FMT = "p44_dedup_{sid}_{src}_{dst}_{port}"
```

## Decision Authority
Approved by Phase 45 change register (phase45-03-change-register.md).
Owner: Packet routing capability owner.

---
*Generated: 2026-08-27T03:41:00Z (UTC) / 2026-08-26T23:41:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
