---
report_id: 731
phase: 85
title: "Audit Cluster Settings — Enablement Procedure Documentation"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/731-audit-cluster-settings-02.md
---

## Summary
Procedure documented to enable CLUSTER_SETTINGS_CHANGED auditing; requires config change and node restart.

## Evidence
- **Enablement method**: Remove CLUSTER_SETTINGS_CHANGED from `plugins.security.audit.config.disabled_transport_categories` in opensearch.yml
- **Restart required**: Transport layer config changes require rolling restart
- **Config snippet**:
  ```yaml
  plugins.security.audit.config.disabled_transport_categories:
    - AUTHENTICATED
    - GRANTED_PRIVILEGES
    # CLUSTER_SETTINGS_CHANGED removed to enable
  ```
- **Impact**: Will generate events for all persistent/transient cluster setting changes

## Verification Method
Documentation review; config change procedure validation; restart impact assessment.

## Finding
**PROCEDURE DOCUMENTED** — Enablement possible via config change + rolling restart; operational impact low.