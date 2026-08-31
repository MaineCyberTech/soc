Report ID: P83-permission-checks-08
Phase: 83
Title: Phase 83: Permission Checks
Date: 2026-08-31
Timestamp UTC: 2026-08-31T08:29:41Z
Timestamp ET: 2026-08-31T04:29:41 EDT
Classification: INTERNAL
Status: PASS
Source Path: ops/reports/generated/phase83/247-permission-checks-08.md
Prompt: /home/user/mct-p83/prompts/247-permission-checks-08.md

## Summary
Permission checks performed against the least-privilege identity `soc_least_priv` (via temporary user soc_test_lp, now removed).

## Checks executed (HTTP result)
1. GET security-auditlog-*/_search -> 200 OK (positive control: required index readable).
2. GET _cluster/health -> 200 OK (read-only monitor permission granted).
3. GET users/_search (index NOT in required_indexes) -> 403 Forbidden (unrelated_indexes_denied).
4. PUT _plugins/_security/api/roles/soc_should_fail (cluster-admin security API) -> 403 Forbidden (cluster_admin_denied).
5. GET .opendistro_security/_search (security index) -> 403 Forbidden (security_index_denied).

## Evidence
Reference: ops/reports/evidence/phase83/phase83-evidence-rbac.json (permission_checks text; unrelated_indexes_denied=true, cluster_admin_denied=true, security_index_denied=true).

## Status
PASS - all permission checks behaved as designed.
