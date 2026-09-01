---
report_id: 752
phase: 85
title: "Audit RBAC Events — Event Schema (If Enabled)"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/752-audit-rbac-events-03.md
---

## Summary
Expected event schema for COMPLIANCE_INTERNAL_CONFIG_READ/WRITE documented.

## Evidence
- **READ events**: timestamp, category, user, roles, resource_type (role/rolemapping/tenant), resource_name, action (get/list), source_ip
- **WRITE events**: timestamp, category, user, roles, resource_type, resource_name, action (create/update/delete), diff (before/after), source_ip
- **Diff field**: JSON patch showing exact changes (e.g., backend_roles added, permissions modified)
- **Compliance value**: Full change trail with before/after state for every RBAC modification

## Verification Method
OpenSearch Security source review; compliance category documentation; schema extrapolation.

## Finding
**SCHEMA DOCUMENTED** — If enabled, events would provide complete RBAC change audit trail with diffs.