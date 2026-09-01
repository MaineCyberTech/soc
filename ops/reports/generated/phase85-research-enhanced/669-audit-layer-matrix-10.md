---
report_id: 669
phase: 85
title: "Audit Layer Matrix — Comprehensive Layer Matrix Summary"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/669-audit-layer-matrix-10.md
---

## Summary
Complete audit layer matrix validated: dual-layer enabled, category matrix documented, sensitive fields excluded, request bodies logged, indices resolved.

## Evidence
- **REST layer**: enable_rest=true, categories: FAILED_LOGIN, AUTHENTICATED, SSL_EXCEPTION, BAD_HEADERS, OPENSEARCH_SECURITY_INDEX_ATTEMPT
- **Transport layer**: enable_transport=true, categories: AUTHENTICATED, GRANTED_PRIVILEGES, SSL_EXCEPTION
- **Defaults honored**: CLUSTER_SETTINGS_CHANGED, INDEX_SETTINGS_CHANGED disabled on transport
- **Compliance**: compliance.internal_config=false (RBAC changes not captured)
- **Privacy**: exclude_sensitive_headers=true, log_request_body=true, resolve_indices=true

## Verification Method
Full API config dump; live event stream validation across all categories; privacy control verification; documentation cross-reference.

## Finding
**VERIFIED** — Comprehensive audit layer matrix fully operational with documented gaps (cluster/index settings, compliance RBAC) at known defaults.