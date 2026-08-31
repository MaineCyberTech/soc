Report ID: P83-opensearch-role-map-01
Phase: 83
Title: Phase 83: OpenSearch Role Map
Date: 2026-08-31
Timestamp UTC: 2026-08-31T08:29:41Z
Timestamp ET: 2026-08-31T04:29:41 EDT
Classification: INTERNAL
Status: PASS
Source Path: ops/reports/generated/phase83/120-opensearch-role-map-01.md
Prompt: /home/user/mct-p83/prompts/120-opensearch-role-map-01.md

## Summary
OpenSearch Security role mappings were created (least-privilege) and reduced (readall) for Phase 83.

## Actions
- Created role `soc_least_priv` (PUT 201) with explicit index_patterns only (no '*'): security-auditlog-*, workflowexecution-*, workflow-*, workflowapp-*, shuffle_logs-*, wazuh-iris-dedup-*, ss4o_traces-otel-mct-soc, top_queries-*. allowed_actions: read, indices:data/read/mget, indices:data/read/get. Cluster perms limited to read-only monitoring.
- Reduced `readall` rolesmapping: backend_roles:['readall'] -> users:['readall'], backend_roles:[]. The `readall` role itself is reserved/static (PUT returns 403), so it cannot be scoped away from '*' at the role level; the residual grant is governed by a time-bound exception expiring 2026-09-30.

## Evidence
Reference: ops/reports/evidence/phase83/phase83-evidence-rbac.json (identity=soc_least_priv, required_indexes set, wildcard_reduced_or_exception=true, exception_expiry_or_na=2026-09-30).

## Status
PASS - role map changes applied and reversible.
