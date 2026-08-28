# Phase 45: Counter Policy Decision

## Counter Definitions

| Counter | Key | Category | Scope | Persistence |
|---------|-----|----------|-------|-------------|
| **Packet Routed (Real)** | `p44_packet_routed` | `p44_counters` | Real events only (ROUTED state) | Shuffle cache (survives workflow restart) |
| **Packet Synthetic** | `p44_packet_synthetic` | `p44_counters` | Synthetic events (SYNTHETIC_TEST state) | Shuffle cache |
| **Packet Suppressed** | `p44_packet_suppressed` | `p44_counters` | POLICY_SUPPRESSED events | Shuffle cache |
| **Packet Duplicate** | `p44_packet_duplicate` | `p44_counters` | DUPLICATE events | Shuffle cache |
| **Packet Malformed** | `p44_packet_malformed` | `p44_counters` | MALFORMED events | Shuffle cache |
| **Target Failed** | `p44_packet_target_fail` | `p44_counters` | TARGET_FAILED events | Shuffle cache |

## Persistence Model
| Property | Value |
|----------|-------|
| **Storage** | Shuffle in-memory cache (Redis-backed) |
| **Workflow Restart** | **Survives** - cache is external to workflow process |
| **Shuffle Restart** | **Lost** - Redis flush clears all |
| **Atomicity** | `set_cache_value` is atomic increment |
| **TTL** | None (manual reset or Shuffle restart) |

## Daily Reset Policy
| Counter | Reset Schedule | Method |
|---------|----------------|--------|
| All | Daily at 00:00 UTC | Scheduled workflow or cron job |
| On-demand | Owner request | Manual `set_cache_value(key, "0")` |

## Restart Durability
| Event | Counter State |
|-------|---------------|
| Workflow restart | **Preserved** (cache external) |
| Shuffle backend restart | **Lost** (Redis flush) |
| Host reboot | **Lost** (Redis flush) |
| Network partition | **Preserved** if Redis available |

## Thresholds & Monitoring
| Counter | Warning Threshold | Critical Threshold | Action |
|---------|-------------------|-------------------|--------|
| `p44_packet_routed` | > 1000/hour | > 5000/hour | Alert owner - potential alert storm |
| `p44_packet_target_fail` | > 10/hour | > 50/hour | Alert owner - IRIS connectivity issue |
| `p44_packet_synthetic` | > 100/hour | > 500/hour | Review synthetic test frequency |
| `p44_packet_malformed` | > 50/hour | > 200/hour | Investigate sensor/config issues |

## Override Audit
| Override | Authorized By | Logged | Retention |
|----------|---------------|--------|-----------|
| Manual reset | Owner | Audit log + timestamp | 90 days |
| Threshold change | Owner | Audit log + previous value | 90 days |
| Daily reset job | Automation | Job log | 30 days |

## Implementation
```python
# Increment routed counter (atomic)
self.set_cache_value(
    key="p44_packet_routed",
    value="1",  # Increment by 1 (Shuffle adds to existing)
    category="p44_counters"
)

# Read counter
count = self.get_cache_value(key="p44_packet_routed", category="p44_counters")

# Reset counter
self.set_cache_value(key="p44_packet_routed", value="0", category="p44_counters")
```

## Daily Reset Job
```yaml
# Cron entry (on Shuffle host or scheduled workflow)
0 0 * * * curl -X POST "http://shuffle-backend:5001/api/v1/workflows/daily-reset-counters/execute" \
  -H "Authorization: Bearer $SHUFFLE_API_KEY"
```

## Decision Authority
Approved by Phase 45 change register (phase45-03-change-register.md).
Owner: Packet routing capability owner.

---
*Generated: 2026-08-27T03:42:00Z (UTC) / 2026-08-26T23:42:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
