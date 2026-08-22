# Phase 23 Swap Activity Root Cause

Date: 2026-08-22

## Metrics

| Metric | Value | Meaning |
|---|---|---|
| Swap used | 707MB / 8.2GB (8.6%) | was 5.2GB (64%) at P22 close |
| vmstat si | **0** (all samples) | NO swap-in activity - pages not being read back |
| vmstat so | 0-844KB (minimal) | no active swap-out |
| PSI memory | avg10=0.00, avg60=0.64 | negligible memory stalls |
| Indexer RSS | 3x ~1.7-1.8GB | within JVM/heap norms |
| shuffle-opensearch | 1.42GB/1.5GB cap; VmSwap 7MB | not swapping |

## Root cause

- The P22 spike (64%) was **transient pressure during telemetry flood bursts** (agent analysis
  + log processing spikes from 014/015 floods). Once 015's flood was fixed and 014's flood was
  throttled at analysis, pressure cleared and stale pages were reclaimed.
- Current usage = **stale/idle pages**, not active pressure (si=0 + PSI~0 confirms).

## Decision (per pack: not percentage-driven)

- **NO ACTION**: do not clear swap or resize the swapfile to improve a percentage. Swapfile
  resize (D5) only if disk pressure requires it later (currently disk 83%, below watermark).
- Monitor: si stays ~0 and swap < 15% = healthy; revisit if si rises.

## No secrets