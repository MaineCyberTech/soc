---
report_id: 757
phase: 85
title: "Audit RBAC Events — Compliance Requirement Mapping"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/757-audit-rbac-events-08.md
---

## Summary
Compliance frameworks require access control change auditing; RBAC config gap identified.

## Evidence
- **SOC2 CC6.1**: Logical access controls — changes to access rights must be tracked
- **PCI-DSS 7.1 / 10.2.1**: Access control changes auditable; audit trails for privilege changes
- **HIPAA 164.308(a)(3)**: Access authorization — modifications to access rights auditable
- **ISO 27001 A.9.2**: User access management — changes to access rights logged
- **Current gap**: RBAC config changes not audited → compliance evidence gap for access control

## Verification Method
Compliance framework mapping; access control audit requirement analysis; gap documentation.

## Finding
**COMPLIANCE GAP** — Disabled compliance.internal_config creates evidence gap for access control change auditing.