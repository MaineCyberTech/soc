---
report_id: 753
phase: 85
title: "Audit RBAC Events — Role Change Detection Gap"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/753-audit-rbac-events-04.md
---

## Summary
Role create/update/delete invisible; privilege escalation via role modification not audited.

## Evidence
- **Attack vector**: Add `cluster:admin/opendistro/security/*` to existing role → full security admin
- **Or**: Create new role with elevated permissions; map to attacker user
- **Current visibility**: 0 compliance events; GRANTED_PRIVILEGES only shows privilege checks, not config changes
- **Detection gap**: Role changes only visible via manual API diff or change register

## Verification Method
Attack scenario modeling; current detection capability analysis; gap documentation.

## Finding
**PRIVILEGE ESCALATION GAP** — Role modifications not audited; silent privilege escalation possible.