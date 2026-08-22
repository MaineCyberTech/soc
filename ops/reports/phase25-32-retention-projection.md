# Phase 25 Retention Projection

Date: 2026-08-22

## 1. Verified state (indices on disk)

- Archives indices: 08-07..08-22 (08-11..08-14 absent - deleted earlier).
- Policy coverage: **all archives indices now carry wazuh-archives-14d** (08-19..22 from P24;
  08-07..18 re-attached this phase). Alerts: 30d (wazuh-retention). Flow: 14d.

## 2. 14d deletion trend

| Index (archives) | Created | Age on 08-22 | Delete expected |
|---|---|---|---|
| 08-07 | 08-07 | 15d | immediately (past 14d) |
| 08-08 | 08-08 | 14d | immediately |
| 08-09 | 08-09 | 13d | ~08-23 |
| 08-10 | 08-10 | 12d | ~08-24 |
| 08-15..08-18 | - | 4-7d | ~08-29..09-01 |
| 08-19+ | - | < 3d | 14d each |

## 3. Projected relief + growth

- Eligible archives: ~14.4GB (08-07..08-18). Node fs projected 84.7% -> ~76-78% within ~10 days.
- Daily growth (post-noise-fixes): alerts ~50-60MB/day; archives ~0.7-1.2GB/day (bounded;
  EID7 quiet). Flow stable ~2.4GB total.

## 4. Anomalies

- 08-11..08-14 archives absent (deleted pre-P22) - no action; store consistent.
- EID7 quiet cycle on 013/014 keeps archives low; if floods resume pre-tuning, growth spikes
  (tuning apply remains the control).

## 5. Cleanup approval

- Retention application = approved policy (P19/P22 archives 14d); index deletion is
  automatic ISM behavior, not ad-hoc cleanup. Documented in change register.

## No secrets