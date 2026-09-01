---
report_id: 732
phase: 85
title: "Audit Cluster Settings — Event Schema (If Enabled)"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/732-audit-cluster-settings-03.md
---

## Summary
Expected event schema for CLUSTER_SETTINGS_CHANGED documented based on OpenSearch Security source.

## Evidence
- **Expected fields**: timestamp, category, user, roles, setting_name, old_value, new_value, persistent/transient, source_ip, node
- **Setting coverage**: All cluster settings (disk watermarks, shard allocation, routing, etc.)
- **Value capture**: Both old and new values logged for change tracking
- **Scope**: Persistent and transient changes both captured

## Verification Method
OpenSearch Security source code review; documentation cross-reference; schema extrapolation.

## Finding
**SCHEMA DOCUMENTED** — If enabled, events would provide full change audit trail with before/after values.