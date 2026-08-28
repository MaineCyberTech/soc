# Phase 45: Evidence Timestamp Policy

## Authority
- **UTC is authoritative** for all evidence ordering, automation, retention timing, log comparison, and cross-system evidence.
- **America/New_York (Eastern Time)** is the operator-facing display companion.
- **IANA Timezone Database** is the source of truth for DST transitions.

## Format Requirements

### UTC (Authoritative)
- **Format:** ISO 8601 with `Z` suffix
- **Example:** `2026-08-27T03:30:45Z`
- **Use for:** All evidence timestamps, automation triggers, retention calculations, cross-system correlation

### Eastern Time (Display)
- **Format:** ISO 8601 with explicit offset
- **DST (EDT):** `2026-08-27T23:30:45-04:00` (UTC-4)
- **Standard (EST):** `2026-12-27T22:30:45-05:00` (UTC-5)
- **Abbreviation:** EDT or EST (never "ET" or hardcoded "EST")
- **Use for:** Operator-facing reports, dashboards, scheduling displays

### Epoch (Unix)
- **Format:** Seconds since 1970-01-01T00:00:00Z
- **Example:** `1787800245`
- **Use for:** Programmatic comparisons, retention windows, TTL calculations

## Timestamp Classification

| Classification | Definition | Label | Examples |
|----------------|------------|-------|----------|
| **OBSERVED** | Event actually occurred; captured by system | `OBSERVED` | Log entry, webhook receipt, sensor reading |
| **SCHEDULED** | Future execution time; not yet occurred | `SCHEDULED` / `PLANNED` | Cron job, ISM policy start, maintenance window |
| **ELAPSED_WINDOW** | Duration measured from start to now | `ELAPSED` | Monitor window, dedup TTL remaining, retention age |

## Rules

### Never
- Future-date evidence (use `SCHEDULED` or `PLANNED`)
- Hardcode `EST` year-round (use EDT/EST based on DST)
- Use `ET` or ambiguous timezone abbreviations
- Omit offset in Eastern Time display
- Use local time for evidence ordering

### Always
- Record UTC timestamp first, derive Eastern display
- Include explicit offset (`-04:00` / `-05:00`) in Eastern display
- Use `America/New_York` IANA zone for DST transitions
- Classify every timestamp as OBSERVED, SCHEDULED, or ELAPSED_WINDOW
- Use epoch for programmatic TTL/retention calculations

## DST Transition Handling
- **Spring Forward (2026-03-08):** 02:00 EST → 03:00 EDT (gap)
- **Fall Back (2026-11-01):** 02:00 EDT → 01:00 EST (overlap)
- Use IANA database; never hardcode dates

## Implementation
```python
# Python reference implementation
from datetime import datetime, timezone
import zoneinfo

def utc_now():
    return datetime.now(timezone.utc)

def eastern_display(utc_dt):
    eastern = utc_dt.astimezone(zoneinfo.ZoneInfo("America/New_York"))
    return eastern.isoformat()

def classify_timestamp(ts_utc, now_utc=None):
    now_utc = now_utc or utc_now()
    if ts_utc > now_utc:
        return "SCHEDULED"
    elif ts_utc <= now_utc:
        return "OBSERVED"
    return "UNKNOWN"
```

## Report Template
Every operational report MUST include:
```
Generated: 2026-08-27T03:30:45Z (UTC) / 2026-08-26T23:30:45-04:00 (EDT)
```

---
*Policy effective: 2026-08-27T03:30:45Z (UTC) / 2026-08-26T23:30:45-04:00 (EDT)*
*Authority: Phase 45 Time Policy*
