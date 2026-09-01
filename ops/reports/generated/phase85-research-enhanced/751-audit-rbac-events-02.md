---
report_id: 751
phase: 85
title: "Audit RBAC Events — Enablement Procedure Documentation"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/751-audit-rbac-events-02.md
---

## Summary
Procedure to enable RBAC config change auditing; requires compliance.internal_config=true + restart.

## Evidence
- **Enablement method**: Set `plugins.security.audit.config.compliance.internal_config: true` in opensearch.yml
- **Restart required**: Rolling restart of indexer nodes
- **Categories enabled**: 
  - COMPLIANCE_INTERNAL_CONFIG_READ (role/role mapping/tenant reads)
  - COMPLIANCE_INTERNAL_CONFIG_WRITE (role/role mapping/tenant creates/updates/deletes)
- **Config snippet**:
  ```yaml
  plugins.security.audit.config.compliance.internal_config: true
  ```

## Verification Method
Config documentation review; enablement procedure validation; restart impact assessment.

## Finding
**PROCEDURE DOCUMENTED** — Enablement via single config flag + rolling restart; two compliance categories activated.