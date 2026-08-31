Report ID: P83-negative-authz-03
Phase: 83
Title: Phase 83: Negative Authz
Date: 2026-08-31
Timestamp UTC: 2026-08-31T08:29:41Z
Timestamp ET: 2026-08-31T04:29:41 EDT
Classification: INTERNAL
Status: PASS
Source Path: ops/reports/generated/phase83/252-negative-authz-03.md
Prompt: /home/user/mct-p83/prompts/252-negative-authz-03.md

## Summary
Denied-access verifications for the least-privilege identity `soc_least_priv` (temporary user soc_test_lp, since removed).

## Denied-access verifications (all returned 403 Forbidden)
- Unrelated index: GET users/_search where `users` is outside required_indexes -> 403 (unrelated_indexes_denied=true). This proves the identity is NOT granted the readall '*' wildcard.
- Cluster admin: PUT _plugins/_security/api/roles/soc_should_fail (cluster:* / security admin) -> 403 (cluster_admin_denied=true).
- Security index: GET .opendistro_security/_search -> 403 (security_index_denied=true). The .opendistro_security security index is denied to the least-privilege identity.

## Positive controls (returned 200)
- GET security-auditlog-*/_search -> 200; GET _cluster/health -> 200.

## Evidence
Reference: ops/reports/evidence/phase83/phase83-evidence-rbac.json (unrelated_indexes_denied=true, cluster_admin_denied=true, security_index_denied=true).

## Status
PASS - negative authorization certified.
