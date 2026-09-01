---
report_id: 716
phase: 85
title: "BAD_HEADERS — Integration with Alerting"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/716-audit-bad-headers-07.md
---

## Summary
BAD_HEADERS alerting integration gap identified.

## Evidence
- **Current monitors**: Phase 82/83 target FAILED_LOGIN only
- **BAD_HEADERS monitor**: None configured
- **Detection gap**: Header spoofing attempts would not trigger alerts
- **Remediation**: Create monitor with query audit_category.keyword=BAD_HEADERS, threshold >0

## Verification Method
Monitor inventory review; category coverage analysis.

## Finding
**GAP IDENTIFIED** — No alerting on BAD_HEADERS category. Header spoofing attempts silently audited but not alerted. Recommend creating dedicated BAD_HEADERS monitor (severity 3, any occurrence).
