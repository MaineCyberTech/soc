---
report_id: 754
phase: 85
title: "Audit RBAC Events — Role Mapping Change Detection Gap"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/754-audit-rbac-events-05.md
---

## Summary
Role mapping changes invisible; user-to-role binding modifications not audited.

## Evidence
- **Attack vector**: Add attacker's user/DN to `security_rest_role_admin` mapping → instant admin
- **Or**: Remove legitimate admin from mapping → lockout
- **Current visibility**: 0 compliance events for role mapping changes
- **Alternative detection**: Only via manual `GET _plugins/_security/api/rolemappings` comparison

## Verification Method
Role mapping attack modeling; detection gap analysis; alternative detection review.

## Finding
**ACCESS CONTROL GAP** — Role mapping changes not audited; silent access grant/revoke possible.