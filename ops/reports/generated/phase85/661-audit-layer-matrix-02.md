---
report_id: 661
phase: 85
title: "Audit Layer Matrix — Transport Layer Enablement Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/661-audit-layer-matrix-02.md
---

## Summary
Transport audit layer confirmed enabled and operational on wazuh-cluster indexer nodes.

## Evidence
- **Live API check**: `GET /_plugins/_security/api/audit` returns `audit.enable_transport: true`
- **Index verification**: security-auditlog-* indices receiving transport-layer events (GRANTED_PRIVILEGES, MISSING_PRIVILEGES, INDEX_EVENT, COMPLIANCE_INTERNAL_CONFIG_READ/WRITE, OPENSEARCH_SECURITY_INDEX_ATTEMPT)
- **Category coverage**: All transport-enabled categories actively capturing

## Verification Method
Direct REST API query to OpenSearch Security audit configuration endpoint; cross-referenced with live audit index category aggregation showing transport-only categories (GRANTED_PRIVILEGES, MISSING_PRIVILEGES, OPENSEARCH_SECURITY_INDEX_ATTEMPT) with live document counts.

## Finding
**VERIFIED** — Transport audit layer is enabled and capturing events across all expected categories.
