# Phase 29 Capacity and Retention

Date: 2026-08-24

## Live state

| Metric | Value |
|---|---|
| Disk (root) | **82%** (was 81% P28) |
| Cluster | green, 264 shards, 0 unassigned |
| Writes | healthy; 0 read-only blocks |
| Archives | 08-15..08-24 present (08-15..18 delete wave due ~08-29..09-01) |
| Snapshots | 42, rolling 7d |
| Cache/release growth | negligible (bundle + cache manifest only) |

## Trend

- 82% (short-term rise as 08-20/21-ish build before the 08-15..18 wave ~7.4GB relief).
- Projected ~76-78% after the wave. Daily archive growth ~100MB. No capacity action.

## Action threshold

- > 85% low watermark for 2 consecutive checks -> operator alert; flood 95% -> ISM soft block
  (current headroom > 3pp to low watermark).

## No secrets