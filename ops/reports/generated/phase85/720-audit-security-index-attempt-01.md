---
report_id: 720
phase: 85
title: "SECURITY_INDEX_ATTEMPT — Category Enablement Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/720-audit-security-index-attempt-01.md
---

## Summary
OPENSEARCH_SECURITY_INDEX_ATTEMPT category verified enabled on transport layer.

## Evidence
- **Config check**: Not in disabled_transport_categories (only AUTHENTICATED, GRANTED_PRIVILEGES)
- **Category validity**: OpenSearch Security docs list OPENSEARCH_SECURITY_INDEX_ATTEMPT as Transport-only category
- **Transport-only**: Not logged on REST layer by design (security index access via transport)

## Verification Method
Live config inspection; OpenSearch Security documentation cross-reference.

## Finding
**VERIFIED** — OPENSEARCH_SECURITY_INDEX_ATTEMPT enabled on transport layer. Security index access attempts via transport protocol will be audited.
