Report ID: P83-readall-inventory-04
Phase: 83
Title: Phase 83: Readall Inventory
Date: 2026-08-31
Timestamp UTC: 2026-08-31T08:29:41Z
Timestamp ET: 2026-08-31T04:29:41 EDT
Classification: INTERNAL
Status: PASS
Source Path: ops/reports/generated/phase83/223-readall-inventory-04.md
Prompt: /home/user/mct-p83/prompts/223-readall-inventory-04.md

## Summary
Inventory of the `readall` wildcard role and its rolemappings, required before any reduction.

## readall role (reserved/static)
- index_patterns: ['*']
- allowed_actions: ['read']
- cluster_permissions: ['cluster_composite_ops_ro']
- reserved=true, static=true (PUT to modify returns 403)

## readall rolemappings (before)
- backend_roles: ['readall'] -> grants the wildcard to any principal with backend_role 'readall'.
- Holders identified: internal user `kibanaro` (also backend_role kibanauser) and internal user `readall`.

## Backup (for rollback)
- ops/backups/agents/phase83-readall-role-before-20260831T080500Z.json
- ops/backups/agents/phase83-readall-rolesmapping-before-20260831T080500Z.json
- ops/backups/agents/phase83-rolesmapping-all-before-20260831T080500Z.json

## Evidence
Reference: ops/reports/evidence/phase83/phase83-evidence-rbac.json (key 'readall_mappings inventoried'=true).

## Status
PASS - readall fully inventoried and backed up.
