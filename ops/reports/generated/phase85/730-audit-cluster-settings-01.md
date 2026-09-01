---
report_id: 730
phase: 85
title: "CLUSTER_SETTINGS_CHANGED — Category Status Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/730-audit-cluster-settings-01.md
---

## Summary
CLUSTER_SETTINGS_CHANGED category verified DISABLED by default on transport layer.

## Evidence
- **Config check**: Not explicitly in disabled_transport_categories (only AUTHENTICATED, GRANTED_PRIVILEGES)
- **Documentation**: OpenSearch Security docs state "By default, CLUSTER_SETTINGS_CHANGED and INDEX_SETTINGS_CHANGED categories are disabled on the transport layer"
- **Default behavior**: Disabled unless explicitly removed from disabled_transport_categories
- **Live test**: Cluster setting change (disk.watermark.low) generated 0 events

## Verification Method
Live config inspection; documentation cross-reference; live trigger test (PUT /_cluster/settings).

## Finding
**DISABLED BY DEFAULT** — CLUSTER_SETTINGS_CHANGED not capturing despite live cluster setting change. Requires explicit enablement via audit configuration.
