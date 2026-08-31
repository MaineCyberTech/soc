Report ID: P83-opensearch-user-map-02
Phase: 83
Title: Phase 83: OpenSearch User Map
Date: 2026-08-31
Timestamp UTC: 2026-08-31T08:29:41Z
Timestamp ET: 2026-08-31T04:29:41 EDT
Classification: INTERNAL
Status: PASS
Source Path: ops/reports/generated/phase83/111-opensearch-user-map-02.md
Prompt: /home/user/mct-p83/prompts/111-opensearch-user-map-02.md

## Summary
OpenSearch Security internal-user mappings were inventoried and adjusted for Phase 83 RBAC least-privilege enforcement.

## Actions
- Created temporary verification user `soc_test_lp` with opendistro_security_roles ['soc_least_priv']; used to prove positive and negative authorization, then DELETED (subsequent GET returns 404). No secret values are recorded.
- The `readall` internal user retains its mapping via the reduced rolesmapping (users:['readall']); it is the only principal still granted the readall wildcard, governed by a time-bound exception expiring 2026-09-30.
- The `kibanaro` internal user no longer inherits the readall wildcard because the readall backend_role catch-all was removed from the readall rolesmapping.

## Evidence
Reference: ops/reports/evidence/phase83/phase83-evidence-rbac.json (keys: identity=soc_least_priv, readall_mappings inventoried=true, wildcard_reduced_or_exception=true, exception_expiry_or_na=2026-09-30).

## Status
PASS - user mapping changes applied, reversible via ops/backups/agents/phase83-readall-rolesmapping-before-*.json.
