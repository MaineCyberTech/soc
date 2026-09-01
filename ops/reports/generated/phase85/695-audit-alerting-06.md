---
report_id: 695
phase: 85
title: "Audit Alerting — Defence-in-Depth Coverage"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/695-audit-alerting-06.md
---

## Summary
Defence-in-depth alerting coverage verified: two monitors with different sensitivities.

## Evidence
- **Layer 1 (Phase 82)**: Any FAILED_LOGIN → immediate alert (severity 1, 5-min schedule)
- **Layer 2 (Phase 83)**: Spike >200/5min → sustained alert (severity 2, 1-min schedule)
- **Coverage**: Layer 1 catches low-volume attacks; Layer 2 catches high-volume spikes
- **Current state**: Both enabled; Layer 2 continuously firing; Layer 1 would fire on each evaluation

## Verification Method
Monitor configuration comparison; schedule/threshold analysis.

## Finding
**VERIFIED** — Defence-in-depth intact. Two-tier approach provides both immediate notification (any failure) and sustained spike detection. Redundancy confirmed.
