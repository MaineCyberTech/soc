# Phase 45: Delivery Monitor Window

## Monitor Window Definition
| Property | Value |
|----------|-------|
| **Window Start (UTC)** | 2026-08-27T00:00:00Z |
| **Window End (UTC)** | 2026-08-28T00:00:00Z |
| **Window Start (EDT)** | 2026-08-26T20:00:00-04:00 |
| **Window End (EDT)** | 2026-08-27T20:00:00-04:00 |
| **Duration** | 24 hours |
| **Timezone (UTC)** | UTC (authoritative) |
| **Timezone (Display)** | America/New_York (EDT/-04:00) |

## Expected Slots
| Slot | UTC | EDT | Description |
|------|-----|-----|-------------|
| **Slot 1** | 00:00-06:00 | 20:00-02:00 | Overnight |
| **Slot 2** | 06:00-12:00 | 02:00-08:00 | Morning |
| **Slot 3** | 12:00-18:00 | 08:00-14:00 | Afternoon |
| **Slot 4** | 18:00-00:00 | 14:00-20:00 | Evening |

## Cadence
| Metric | Cadence |
|--------|---------|
| **Packet Routing Check** | Every 5 minutes |
| **IRIS Health** | Every 5 minutes |
| **Dedup Cache** | Every 15 minutes |
| **Counter Snapshot** | Every hour |
| **Full Reconciliation** | Every 6 hours (00:00, 06:00, 12:00, 18:00 UTC) |

## Sources
| Source | Type | Cadence |
|--------|------|---------|
| **Shuffle Executions** | API | 5 min |
| **IRIS Alerts** | API | 5 min |
| **Dedup Cache** | Shuffle API | 15 min |
| **Counters** | Shuffle API | 1 hour |
| **Wazuh Alerts** | Log/Index | 5 min |
| **IRIS Alerts** | API | 5 min |
| **OpenSearch Indices** | API | 1 hour |

## Timezone Offsets
| Period | UTC Offset | Abbreviation |
|--------|------------|--------------|
| **Current (Aug 2026)** | -04:00 | EDT |
| **Standard Time (Nov-Mar)** | -05:00 | EST |

## Evidence Requirements
| Evidence | Window | Format |
|---------|--------|---------|
| **Packet Events** | Full 24h | JSON per execution |
| **IRIS Alerts** | Full 24h | API response |
| **Counters** | Hourly snapshots | JSON |
| **Reconciliation** | 6-hourly | Markdown report |
| **Dedup Cache** | 15-min | JSON dump |

## Reconciliation Windows
| Window | UTC | EDT | Report Due |
|--------|-----|-----|------------|
| **R1** | 00:00-06:00 | 20:00-02:00 | 06:15 UTC |
| **R2** | 06:00-12:00 | 02:00-08:00 | 12:15 UTC |
| **R3** | 12:00-18:00 | 08:00-14:00 | 18:15 UTC |
| **R4** | 18:00-00:00 | 14:00-20:00 | 00:15 UTC (next day) |

## Evidence Completeness
| Requirement | Window | Verification |
|-------------|--------|--------------|
| **All Executions Captured** | 24h | Count matches sent |
| **All IRIS Alerts Captured** | 24h | Count matches routed |
| **Counters Complete** | 24h | Hourly snapshots |
| **Reconciliation Complete** | 4x | All 4 reports generated |

## Timezone Handling
- **Authoritative:** UTC (all evidence timestamps)
- **Display:** America/New_York with explicit offset
- **Never:** Hardcode EST, use EDT/EST based on DST
- **Conversion:** Use IANA `America/New_York` zone

## Evidence Collection
```bash
# Per-slot capture
for slot in 1 2 3 4; do
  # Capture executions
  curl -H "Authorization: Bearer $NT" \
    "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/executions" \
    > "monitor-slot-$slot-executions.json"
  
  # Capture counters
  curl ... > "monitor-slot-$slot-counters.json"
  
  # Capture IRIS alerts
  curl ... > "monitor-slot-$slot-iris.json"
done
```

## Verification Checklist
| Check | Window | Verification |
|---------|--------|--------------|
| All executions captured | 24h | Count matches sent |
| All IRIS alerts captured | 24h | Count matches routed |
| Counters complete | 24h | 24 hourly snapshots |
| Reconciliation reports | 4 | All 4 generated |
| Timezone labels correct | All | EDT/-04:00 displayed |

---
*Generated: 2026-08-27T04:26:00Z (UTC) / 2026-08-27T00:26:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after field cert (Phase 45-52)*
