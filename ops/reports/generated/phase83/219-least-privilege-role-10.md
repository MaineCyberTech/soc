Report ID: P83-least-privilege-role-10
Phase: 83
Title: Phase 83: Least-Privilege Role
Date: 2026-08-31
Timestamp UTC: 2026-08-31T08:29:41Z
Timestamp ET: 2026-08-31T04:29:41 EDT
Classification: INTERNAL
Status: PASS
Source Path: ops/reports/generated/phase83/219-least-privilege-role-10.md
Prompt: /home/user/mct-p83/prompts/219-least-privilege-role-10.md

## Summary
A least-privilege identity `soc_least_priv` was established to replace blanket readall access for SOC read operations.

## Definition
- index_patterns (explicit, NO wildcard): security-auditlog-*, workflowexecution-*, workflow-*, workflowapp-*, shuffle_logs-*, wazuh-iris-dedup-*, ss4o_traces-otel-mct-soc, top_queries-*
- allowed_actions: read, indices:data/read/mget, indices:data/read/get
- cluster_permissions: cluster:monitor/health, cluster:monitor/state, cluster:monitor/nodes/info, cluster:monitor/nodes/stats, cluster:monitor/main (read-only)

## Verification
A temporary user mapped to the role was able to read a required index (security-auditlog-* -> 200) and was denied an unrelated index, cluster-admin, and the security index (all 403). The temporary user was then removed; the role persists as the established identity.

## Evidence
Reference: ops/reports/evidence/phase83/phase83-evidence-rbac.json (identity=soc_least_priv; unrelated_indexes_denied=true, cluster_admin_denied=true, security_index_denied=true).

## Status
PASS.
