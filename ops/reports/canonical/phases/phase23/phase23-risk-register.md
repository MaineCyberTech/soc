# Phase 23 Risk Register

Date: 2026-08-22 (updated from P22)

| # | Risk | Owner | Trend | Phase 24 action |
|---|---|---|---|---|
| R1 | 014 Sysmon EID7 flood agent-side (throttled) | Operator | unchanged | include-oriented tuning apply + throttle retirement |
| R2 | 013 offline (power unconfirmed) | Client | unchanged | power confirm |
| R3 | Disk 83% (below low watermark) | SOC | improved | monitor; swapfile resize if >85% |
| R4 | PVE222 API token missing | Operator | unchanged | new token |
| R5 | VT key + indexer password rotation pending | SOC/Operator | unchanged | replacements + approval |
| R6 | NetFlow scope unconfirmed (~423K/24h) | Operator | unchanged | classification |
| R7 | Git history credential literals | SOC | accepted (private) | rotation preferred |
| R8 | Greenbone client scan unsigned | Client | unchanged | signed auth |
| R9 | Redis loop 120537 ~10K/day | Portal VPS | unchanged | VPS fix |
| R10 | Swap idle pages 8.6% (si=0) | SOC | resolved | monitor si |
| R11 | Client-dir/template branding leaks | SOC | improved (governance) | template neutralization (P24) |
| R12 | Evidence banner claim | SOC | resolved (122/122) | maintain at creation |

## Accepted risks
- Git history literals (private repo; rotation over history rewrite).
- 014 throttle retains signal suppression until endpoint access (bounded impact).

## No secrets