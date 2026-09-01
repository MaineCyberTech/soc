---
report_id: 663
phase: 85
title: "Audit Layer Matrix — Category Enablement Matrix"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/663-audit-layer-matrix-04.md
---

## Summary
Complete category enablement matrix documented for both REST and transport layers.

## Evidence
- **REST enabled**: FAILED_LOGIN, AUTHENTICATED, SSL_EXCEPTION, BAD_HEADERS, OPENSEARCH_SECURITY_INDEX_ATTEMPT
- **Transport enabled**: AUTHENTICATED, GRANTED_PRIVILEGES, SSL_EXCEPTION
- **Transport disabled (default)**: CLUSTER_SETTINGS_CHANGED, INDEX_SETTINGS_CHANGED
- **Not configured**: COMPLIANCE_INTERNAL_CONFIG_READ/WRITE (compliance.internal_config=false)

## Verification Method
API config dump; documentation cross-reference; live event category tally from security-auditlog-*.

## Finding
**VERIFIED** — Category matrix matches documented defaults plus explicit BAD_HEADERS and OPENSEARCH_SECURITY_INDEX_ATTEMPT enablement.