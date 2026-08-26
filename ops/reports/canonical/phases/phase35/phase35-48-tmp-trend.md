# Phase 35: /tmp Recurrence Trend

Date: 2026-08-25

## Current state
- /tmp size: **1.6GB / 7.6GB (21%)**
- /tmp file count: 10,211 (directories)
- Python temp dirs (tmp.*): 10,195 directories
- Newest temp dirs: 1,275 created since last audit (00:25Z)

## Top consumers
| Path | Size |
|---|---|
| p32-tmp-audit-20260825-002517/ | 15MB |
| Various tmp.* dirs | ~1.1MB each |

## Trend
- /tmp has been at 21% for multiple days — stable
- Python creates temp dirs at a steady rate (~1,275/day)
- Each dir is small (~1KB) but accumulation is measurable
- /tmp is on tmpfs (RAM-backed) — not consuming disk, but using 1.6GB of 5.8GB total RAM

## Impact
- 1.6GB RAM consumed by /tmp (28% of available)
- Not critical but noticeable

## No secrets
