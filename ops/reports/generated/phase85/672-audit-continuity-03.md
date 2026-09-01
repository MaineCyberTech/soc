---
report_id: 672
phase: 85
title: "Audit Continuity — Document Growth Rate Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/672-audit-continuity-03.md
---

## Summary
Audit document growth rate measured and consistent with Phase 85 baseline.

## Evidence
- **security-auditlog-2026.08.31**: 136,026 docs over 17.71 hours = ~7,680 docs/hour
- **security-auditlog-2026.09.01**: 31,678 docs over ~4.75 hours = ~6,670 docs/hour
- **Growth consistency**: Comparable rates; slight decrease expected as day progresses
- **Dominant category**: FAILED_LOGIN ~135k docs (99%+ from stale admin credential in wazuh-modulesd)

## Verification Method
`GET /_cat/indices/security-auditlog-*` for doc counts; category aggregation for breakdown.

## Finding
**VERIFIED** — Audit pipeline capturing continuously at steady rate. Growth dominated by known stale-credential signal (reported, not remediated).
