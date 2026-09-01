---
report_id: 729
phase: 85
title: "Audit Security Index Attempt — Category Summary & Effectiveness"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/729-audit-security-index-attempt-10.md
---

## Summary
OPENSEARCH_SECURITY_INDEX_ATTEMPT category effective for REST-layer privilege escalation detection; gaps documented for reads and transport layer.

## Evidence
- **Enablement**: Explicitly enabled on REST layer
- **Detection**: Write attempts (role, rolemapping, config, tenant) all caught
- **Alerting**: Spike monitor operational; high severity; Shuffle delivery confirmed
- **Forensics**: Event schema includes privilege gap analysis
- **Baseline**: Near-zero; any events actionable
- **Gaps**: Read attempts not distinctly categorized; transport layer not covered

## Verification Method
Full category validation across enablement, detection, alerting, forensics, baseline, gaps.

## Finding
**VERIFIED** — Category operational and effective for REST write escalation detection; documented gaps for reads/transport.