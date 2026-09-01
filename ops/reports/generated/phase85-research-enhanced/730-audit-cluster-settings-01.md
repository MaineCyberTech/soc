---
report_id: 730
phase: 85
title: "Audit Cluster Settings — Category Status Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/730-audit-cluster-settings-01.md
---

## Summary
CLUSTER_SETTINGS_CHANGED category DISABLED by default on transport layer; no events captured despite live changes.

## Evidence
- **Config check**: Not in disabled_transport_categories override (only AUTHENTICATED, GRANTED_PRIVILEGES explicitly disabled)
- **Documentation**: OpenSearch Security docs confirm CLUSTER_SETTINGS_CHANGED disabled by default on transport
- **Live test**: `PUT _cluster/settings {"persistent": {"cluster.routing.allocation.disk.watermark.low": "85%"}}` → 0 events generated
- **REST layer**: Category not available on REST (cluster settings changed via transport only)

## Verification Method
Live config inspection; documentation cross-reference; live cluster setting change test; event stream monitoring.

## Finding
**DISABLED BY DEFAULT** — CLUSTER_SETTINGS_CHANGED not capturing. Requires explicit enablement via `plugins.security.audit.config.disabled_transport_categories` removal.