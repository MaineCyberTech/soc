---
report_id: 660
phase: 85
title: "Audit Layer Matrix — REST Layer Enablement Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/660-audit-layer-matrix-01.md
---

## Summary
REST audit layer confirmed enabled and operational on wazuh-cluster indexer nodes.

## Evidence
- **Live API check**: `GET /_plugins/_security/api/audit` returns `audit.enable_rest: true`
- **Index verification**: security-auditlog-* indices receiving REST-layer events (FAILED_LOGIN, AUTHENTICATED, BAD_HEADERS, SSL_EXCEPTION)
- **Category coverage**: All REST-enabled categories (FAILED_LOGIN, AUTHENTICATED, SSL_EXCEPTION, BAD_HEADERS) actively capturing

## Verification Method
Direct REST API query to OpenSearch Security audit configuration endpoint; cross-referenced with live audit index category aggregation.

## Finding
**VERIFIED** — REST audit layer is enabled and capturing events across all expected categories.