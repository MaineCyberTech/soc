# Phase 36: Retention Wave Baseline

Date: 2026-08-25

## Archive indices inventory

| Index | Docs | Size | Age (days) | Expected Deletion |
|---|---|---|---|---|
| 08-15 | 3,007,251 | 1.8GB | 11 | Day 14 = 2026-08-29 |
| 08-16 | 2,150,542 | 1.2GB | 10 | 2026-08-30 |
| 08-17 | 2,633,464 | 2.4GB | 9 | 2026-08-31 |
| 08-18 | 2,397,160 | 2.0GB | 8 | 2026-09-01 |
| 08-19 | 2,519,199 | 3.8GB | 7 | 2026-09-02 |
| 08-20 | 1,486,141 | 1.2GB | 6 | 2026-09-03 |
| 08-21 | 1,423,025 | 1.2GB | 5 | 2026-09-04 |
| 08-22 | 599,196 | 708MB | 4 | 2026-09-05 |
| 08-23 | 170,521 | 98MB | 3 | 2026-09-06 |
| 08-24 | 248,458 | 140MB | 2 | 2026-09-07 |
| 08-25 | 631,329 | 486MB | 1 | 2026-09-08 |

## Alert indices
- 08-15: 140,354 docs, 135MB
- All days present through 08-25

## Total wazuh index size: 18.1GB

## ISM policy
- Policy `wazuh-archives-14d`: EXISTS (14d hot → delete)
- **Policy NOT attached to indices** — root cause of no deletion

## Expected relief
- 08-15..18: ~7.4GB
- Post-wave estimate: 120G - 7.4G = ~113G = 76%

## No secrets
