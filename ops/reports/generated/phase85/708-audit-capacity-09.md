---
report_id: 708
phase: 85
title: "Audit Capacity — Config Drift Impact Assessment"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/708-audit-capacity-09.md
---

## Summary
Config drift assessed: file vs persistent watermark setting mismatch.

## Evidence
- **File config**: wazuh1.indexer.yml has cluster.routing.allocation.disk.threshold_enabled: false
- **Live persistent**: cluster.routing.allocation.disk.threshold_enabled: true (set Phase 83)
- **Effect**: Persistent setting wins; no functional gap today
- **Risk**: If persistent setting cleared, file config would silently disable watermark enforcement

## Verification Method
File inspection (phase85-audit-snapshot.json drift_observations[0]); live cluster settings comparison.

## Finding
**DRIFT DOCUMENTED** — No current impact. Persistent setting overrides file. Remediation: update file config to match persistent setting (config change gate required).
