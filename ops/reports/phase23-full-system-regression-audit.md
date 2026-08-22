# Phase 23 Full System Regression Audit

Date: 2026-08-22
Post-change re-audit (disk relief, docs, banners, macos reconnect, sysmon design, retention).

## Before/after comparison

| Area | Before (P22) | After (P23) | Regression? |
|---|---|---|---|
| Healthcheck | 0 FAIL | 0 FAIL | NO |
| Cluster | green | green (266 shards) | NO |
| Disk | 85% | **83%** (D1+D2 relief) | NO (improved) |
| Swap | 64% | **8.6%** (si=0) | NO (resolved) |
| Watermarks | at low (84.7%) | 82-83% (below low) | NO (improved) |
| 015 | offline | **active + bounded** (archives 0, 0 queue-full) | NO (recovered) |
| 014 | throttled flood | throttled (unchanged) | NO |
| Zeek | 316/day | 316/day (24h) | NO |
| Retention | archives-14d attached | held | NO |
| Evidence | 0/122 bannered | **122/122 bannered** | NO (claim now true) |
| Docs | stale | ARCHITECTURE/STACK-OVERVIEW refreshed | NO |
| Client-dir | 33 headerless + internal artifacts in export path | moved to internal/ + governance doc | NO (improved) |
| Images | pinned + policy | held (0 violations) | NO |
| Secrets | env-abstraction | held (no literals in tracked) | NO |

## Risk register (updated)

| # | Risk | Trend |
|---|---|---|
| R1 | 014 flood (throttled) | unchanged - tuning blocked |
| R2 | 013 offline | unchanged |
| R3 | Disk 83% (below watermark) | improved - watch |
| R4 | PVE222 token | unchanged |
| R5 | VT key + indexer rotation pending | unchanged |
| R6 | NetFlow scope | unchanged |
| R7 | Git history literals | unchanged (accepted, private) |

## Verdict

**No regressions introduced.** All Phase 23 changes are validated (health/CI/secret gates green).

## Files
- `ops/reports/phase23-full-system-regression-audit.md` (this), `ops/reports/phase23-risk-register.md`

## No secrets