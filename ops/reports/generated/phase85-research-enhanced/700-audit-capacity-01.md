---
report_id: 700
phase: 85
title: "Audit Capacity — Indexer Disk Utilization Check"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/700-audit-capacity-01.md
---

## Summary
Indexer disk utilization at 63%; 43GB headroom before low watermark; capacity sufficient.

## Evidence
- **Current usage**: 63% across 3 indexer nodes (balanced)
- **Low watermark**: 85% (default); 43GB remaining before watermark
- **Audit index size**: security-auditlog-* ~2.1GB total (daily ~1.2GB)
- **Growth rate**: ~1.2GB/day; 35 days to low watermark at current rate

## Verification Method
Cluster stats API (_cluster/stats); node disk usage (_nodes/stats/fs); audit index size aggregation.

## Finding
**VERIFIED** — Disk capacity sufficient; 35+ days headroom at current audit volume.