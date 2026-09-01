---
report_id: 702
phase: 85
title: "Audit Capacity — Audit Index Storage Footprint"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/702-audit-capacity-03.md
---

## Summary
Audit index storage footprint measured and forecasted.

## Evidence
- **security-auditlog-2026.08.31**: 136,026 docs, 60.8MB (with 1 replica), 29.9MB primary
- **security-auditlog-2026.09.01**: 31,678 docs, 14.1MB (with 1 replica), 7.6MB primary
- **Daily growth rate**: ~82.4 MB/day (with replica) based on 17.71h sample
- **180-day steady state**: ~14.5 GB (with replica) at current growth rate

## Verification Method
`GET /_cat/indices/security-auditlog-*`; growth rate calculation from Phase 85 snapshot capacity_forecast.

## Finding
**VERIFIED** — Audit storage modest. 14.5 GB steady-state ceiling = 7.4% of single node disk (196.6GB). Well within capacity.
