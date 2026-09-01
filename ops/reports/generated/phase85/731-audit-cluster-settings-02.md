---
report_id: 731
phase: 85
title: "CLUSTER_SETTINGS_CHANGED — Live Trigger Test"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/731-audit-cluster-settings-02.md
---

## Summary
CLUSTER_SETTINGS_CHANGED trigger test executed: zero events captured.

## Evidence
- **Test**: `PUT /_cluster/settings` with persistent cluster.routing.allocation.disk.watermark.low=85%
- **Response**: 200 acknowledged (setting applied successfully)
- **Audit capture**: CLUSTER_SETTINGS_CHANGED category doc_count remained 0
- **Category aggregation**: No CLUSTER_SETTINGS_CHANGED bucket in terms aggregation

## Verification Method
Pre/post category aggregation comparison; live cluster setting modification.

## Finding
**CONFIRMED DISABLED** — Live cluster setting change did not generate audit event. Category disabled by default despite not appearing in disabled_transport_categories list.
