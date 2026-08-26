# Phase 28 Capacity Plateau - Final

Date: 2026-08-24

## Measurements

| Metric | Value |
|---|---|
| Node fs | **81.0%** used (81% root) |
| Watermarks | low 85 / high 90 / flood 95 (unchanged) |
| Read-only blocks | 0 |
| Cluster | green, 264 shards, 0 unassigned |
| Writes | healthy (no throttle events) |
| Snapshots | 42, rolling 7d |
| Daily growth | ~100MB archives + ~100MB flow (collapsed from 1.2GB/day) |

## Plateau conclusion

- **PLATEAU CONFIRMED** in the ~76-81% band. Trajectory: 84.7% (P25) -> 79.5% (P26) ->
  81.0% (P27/P28 short-term archive build between waves). After the 08-29..09-01 relief
  wave (~7.4GB) projected ~76-78%.
- No capacity action required. Watch: confirm next wave lands; re-check at monthly ops.

## Action threshold

- Alert operator if > 85% (low watermark) for 2 consecutive checks; flood (95%) triggers
  ISM soft block - current buffer > 10pp.

## No secrets