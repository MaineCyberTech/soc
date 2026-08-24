# Phase 30 Retention and Capacity Watch

Date: 2026-08-24

## State

| Metric | Value |
|---|---|
| Disk (root) | **84%** (was 82% P29; climbing ~1-2%/day pre-wave) |
| Archives | 08-15..24 present; **08-15..18 wave (~7.4GB) due ~08-29..09-01** |
| Cluster | green, 264 shards |
| Snapshots | 42, rolling |
| Writes | healthy; 0 read-only blocks |

## Watch

- 84% approaches the 85% low-watermark trigger (alert at 2 consecutive > 85%).
- The 08-15..18 deletion wave (~08-29) provides ~7.4GB relief; projected ~76-78% after.
- Daily growth collapsed (~100MB) but pre-wave accumulation still drives the climb.

## Action

- Continue ISM (no intervention); re-check at wave (Phase 31 / monthly ops). If disk reaches
  85% before the wave, raise with operator (ISM policy is 14d - correct).

## No secrets