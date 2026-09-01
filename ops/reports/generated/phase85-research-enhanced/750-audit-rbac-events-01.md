---
report_id: 750
phase: 85
title: "Audit RBAC Events — Category Status Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/750-audit-rbac-events-01.md
---

## Summary
COMPLIANCE_INTERNAL_CONFIG_READ/WRITE categories exist but NOT CAPTURING; compliance.internal_config=false.

## Evidence
- **Config check**: `GET /_plugins/_security/api/audit/config` → compliance.internal_config: false
- **Categories present**: COMPLIANCE_INTERNAL_CONFIG_READ, COMPLIANCE_INTERNAL_CONFIG_WRITE in schema
- **Live test**: RBAC role creation/modification → 0 compliance events generated
- **Alternative**: GRANTED_PRIVILEGES captures privilege checks but not config changes

## Verification Method
Audit config API inspection; live RBAC change test; compliance category event monitoring.

## Finding
**NOT CAPTURING** — compliance.internal_config=false disables RBAC config change auditing despite category existence.