---
report_id: 740
phase: 85
title: "Audit Index Settings — Category Status Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/740-audit-index-settings-01.md
---

## Summary
INDEX_SETTINGS_CHANGED category DISABLED by default on transport layer; no events captured despite live changes.

## Evidence
- **Config check**: Not in disabled_transport_categories override
- **Documentation**: OpenSearch Security docs confirm INDEX_SETTINGS_CHANGED disabled by default on transport
- **Live test**: `PUT security-auditlog-*/_settings {"index.refresh_interval": "30s"}` → 0 events generated
- **REST layer**: Index settings changes typically via transport; REST equivalent not categorized separately

## Verification Method
Live config inspection; documentation cross-reference; live index setting change test; event stream monitoring.

## Finding
**DISABLED BY DEFAULT** — INDEX_SETTINGS_CHANGED not capturing. Requires explicit enablement via disabled_transport_categories removal.