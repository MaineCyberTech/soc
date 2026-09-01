---
report_id: 719
phase: 85
title: "BAD_HEADERS — Comprehensive Category Assessment"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/719-audit-bad-headers-10.md
---

## Summary
BAD_HEADERS comprehensive assessment: enabled, capturable, zero organic events, alerting gap.

## Scorecard
| Dimension | Status | Evidence |
|-----------|--------|----------|
| REST enabled | ✓ | Not in disabled_rest_categories |
| Transport enabled | ✓ | Not in disabled_transport_categories |
| Live capture | ✓ | 1 event via spoof test |
| Event structure | ✓ | Full request context captured |
| Organic history | ✓ | 0 events in 167k+ docs |
| False positive risk | ✓ | Negligible (internal headers only) |
| Alerting configured | ✗ | No monitor on BAD_HEADERS |
| Compliance relevance | ✓ | Authentication bypass detection |

## Overall Finding
**VERIFIED WITH ALERTING GAP** — BAD_HEADERS category fully operational and capturing. Zero organic spoofing attempts in history. Critical gap: no alerting configured. Recommend creating BAD_HEADERS >0 monitor (severity 3).
