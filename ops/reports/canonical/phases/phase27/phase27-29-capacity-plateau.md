# Phase 27 Disk Capacity Plateau

Date: 2026-08-24

## Measurements

| Metric | Value |
|---|---|
| Node fs | **81.0%** used (was 79.5% P26; 84.7% P25) |
| Root disk | 81% |
| Watermarks | low 85 / high 90 / flood 95 (unchanged; no raise) |
| Read-only blocks | 0 |
| Write health | healthy; cluster green (262 shards) |
| Allocation | 0 unassigned |

## Trend / growth model

- Archives daily: ~1.2GB/day (08-20/21) -> **~100MB/day** (08-23/24; EID7 quiet + 015 bounded).
- ElastiFlow: ~100MB/day. Snapshots: rolling 7d (fixed window).
- Pending relief: 08-15..18 archives (~7.4GB) delete ~08-29..09-01.

## Plateau projection

- Current 81.0%; after the 08-15..18 wave -> **~76-78% plateau** with steady-state growth
  ~200-300MB/day (archives + flow). No capacity action required; watermark headroom > 4pp.

## Decision

- **PLATEAU OBSERVED** (stable ~76-81% band); watch only. No action (capacity via retention).

## No secrets