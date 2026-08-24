# Phase 27 Retention Delete Follow-up

Date: 2026-08-24

## Observed transitions

- **Newly deleted by archives-14d**: `wazuh-archives-4.x-2026.08.10` (14d birthday 08-24).
- Remaining: 08-15..08-24. Next deletes: 08-15 on ~08-29, 08-16 ~08-30, 08-17 ~08-31,
  08-18 ~09-01 (total ~7.4GB pending).
- 08-11..14 absent (pre-P22 deletions) - no anomaly.

## Disk movement

- Node: 84.7% (P25) -> 79.5% (P26) -> **81.0%** (P27). Short-term uptick from 08-20/21
  ~1.2GB/day archives while deletes lagged; daily growth now ~100MB (08-23/24) - plateau
  expected once 08-15..18 delete.

## ISM errors / snapshots

- No ISM policy errors observed. Snapshots: 42 (rolling 7d). Flow retention 14d active
  (elastiflow 9.4M docs / 2.7GB, ~100MB/day).

## Verdict

- **PASS** - retention executing; next relief wave ~08-29..09-01.

## No secrets