---
report_id: 661
phase: 85
title: "Audit Layer Matrix — Transport Layer Enablement Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/661-audit-layer-matrix-02.md
---

## Summary
Transport audit layer confirmed enabled and operational on wazuh-cluster indexer nodes.

## Evidence
- **Live API check**: `GET /_plugins/_security/api/audit` returns `audit.enable_transport: true`
- **Index verification**: security-auditlog-* indices receiving transport-layer events (AUTHENTICATED, GRANTED_PRIVILEGES, SSL_EXCEPTION)
- **Category coverage**: Transport-enabled categories actively capturing; excludes CLUSTER_SETTINGS_CHANGED and INDEX_SETTINGS_CHANGED by default

## Verification Method
Direct REST API query to OpenSearch Security audit configuration endpoint; cross-referenced with live audit index category aggregation.

## Finding
**VERIFIED** — Transport audit layer is enabled and capturing events across all expected transport categories.