# Phase 4 Routing Adjustments

## Applied

| rule | change | effect | evidence |
|---|---|---|---|
| 24010 osquery inventory | level 0 (archive-only) override | ~263k/24h suppressed | applied doc + logtest level 0 + children 24013 still level 4 |

## Proposed (not applied)

| rule | proposal | route |
|---|---|---|
| 120520/120509/120510/120531/120532/120506/120512/120517 | UniFi churn/roaming digest | C |
| 120518/120501 | routine drops digest (flood stays B) | C |
| 120535/120559 | mctportal benign archive | D |
| 120537 | app warn/error dedupe digest | C |

## Class A protection (unchanged)

- OpenCanary 121000-121099
- MISP IOC 121100+
- flow unknown-exporter / lateral-movement monitors
- auditd 80710 (kept level 10)
