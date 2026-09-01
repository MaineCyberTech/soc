---
report_id: 715
phase: 85
title: "BAD_HEADERS — False Positive Assessment"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/715-audit-bad-headers-06.md
---

## Summary
BAD_HEADERS false positive risk assessed: negligible for legitimate traffic.

## Evidence
- **Legitimate sources**: Internal headers only set by OpenSearch Security plugin during inter-node communication
- **Client traffic**: External clients cannot legitimately set _opendistro_security_* headers
- **Test result**: Single intentional spoof test generated 1 event; zero organic events in 167k+ docs
- **Baseline**: 0 BAD_HEADERS events in Phase 85 snapshot (141,396 docs)

## Verification Method
Category aggregation over full audit index history; header semantics analysis.

## Finding
**VERIFIED LOW FP** — BAD_HEADERS events exclusively indicate malicious spoofing attempts. Zero false positives observed in baseline. Any BAD_HEADERS event warrants investigation.
