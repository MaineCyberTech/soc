---
report_id: 742
phase: 85
title: "Audit Index Settings — Event Schema (If Enabled)"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/742-audit-index-settings-03.md
---

## Summary
Expected event schema for INDEX_SETTINGS_CHANGED documented based on OpenSearch Security source.

## Evidence
- **Expected fields**: timestamp, category, user, roles, index_name, setting_name, old_value, new_value, source_ip, node
- **Setting coverage**: All index settings (refresh_interval, number_of_replicas, blocks, lifecycle, etc.)
- **Multi-index**: Wildcard index operations (e.g., `security-auditlog-*`) would generate per-index events
- **Value capture**: Before/after values for change tracking

## Verification Method
Source code review; documentation cross-reference; schema extrapolation.

## Finding
**SCHEMA DOCUMENTED** — If enabled, events would provide per-index change audit trail with before/after values.