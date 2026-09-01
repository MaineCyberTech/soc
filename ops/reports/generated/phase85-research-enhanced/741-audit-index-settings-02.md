---
report_id: 741
phase: 85
title: "Audit Index Settings — Enablement Procedure Documentation"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/741-audit-index-settings-02.md
---

## Summary
Procedure to enable INDEX_SETTINGS_CHANGED auditing; same config change as cluster settings.

## Evidence
- **Enablement method**: Remove INDEX_SETTINGS_CHANGED from `plugins.security.audit.config.disabled_transport_categories`
- **Config snippet**:
  ```yaml
  plugins.security.audit.config.disabled_transport_categories:
    - AUTHENTICATED
    - GRANTED_PRIVILEGES
    # INDEX_SETTINGS_CHANGED removed to enable
  ```
- **Restart required**: Rolling restart of indexer nodes
- **Joint enablement**: Typically enable both CLUSTER_SETTINGS_CHANGED and INDEX_SETTINGS_CHANGED together

## Verification Method
Config procedure documentation; joint enablement validation; restart procedure confirmation.

## Finding
**PROCEDURE DOCUMENTED** — Same enablement path as cluster settings; joint enablement recommended.