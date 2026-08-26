# Phase 35: Memory Budget Validation

Date: 2026-08-25

## Host memory (mct-soc-scan)
| Component | RSS | % of Total |
|---|---|---|
| Total RAM | 5,831MB | 100% |
| Used | 2,563MB | 44% |
| Available | 3,268MB | 56% |
| /tmp (tmpfs) | 1,600MB | 28% |

## Top consumers on mct-soc-scan
| Process | RSS |
|---|---|
| mariadbd (IRIS DB) | 551MB |
| redis-server | 360MB |
| gvmd (GVM) | 350MB + 340MB |
| Suricata | 74MB |

## Suricata sensor memory
- mct-suricata: 74MB (stable, well within budget)

## Assessment
- Memory usage is stable and within budget
- /tmp tmpfs uses 1.6GB of RAM — measurable but not critical
- No memory pressure detected

## No secrets
