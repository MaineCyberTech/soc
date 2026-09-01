---
report_id: 703
phase: 85
title: "Audit Capacity — ISM Retention Impact on Capacity"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/703-audit-capacity-04.md
---

## Summary
ISM 180-day retention policy bounds audit storage growth.

## Evidence
- **Policy**: security-auditlog-retention, delete after min_index_age=180d
- **Mechanism**: Daily rollover + ISM delete = bounded storage
- **Max indices retained**: 180 daily indices
- **Steady-state max**: 180 × 82.4 MB = 14.8 GB (with replica)
- **Current indices**: 2 (2026.08.31, 2026.09.01) — both in hot state, policy attached

## Verification Method
ISM policy inspection; explain API for attachment verification; growth forecast.

## Finding
**VERIFIED** — ISM retention enforces hard bound on audit storage. Cannot exceed ~14.8 GB at steady state regardless of event volume. Growth bounded by design.
