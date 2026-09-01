---
report_id: 721
phase: 85
title: "SECURITY_INDEX_ATTEMPT — Live Trigger Test"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/721-audit-security-index-attempt-02.md
---

## Summary
OPENSEARCH_SECURITY_INDEX_ATTEMPT event successfully triggered and captured live.

## Evidence
- **Test**: `PUT /.opendistro_security/_doc/test` with JSON body (admin user, not TLS admin cert)
- **Response**: 403 "no permissions for [] and User [name=admin, backend_roles=[admin]]"
- **Audit capture**: OPENSEARCH_SECURITY_INDEX_ATTEMPT category doc_count increased from 0 to 1
- **Timestamp**: Event captured at test execution time

## Verification Method
Pre/post category aggregation comparison; live trigger test with unauthorized security index write.

## Finding
**VERIFIED LIVE** — OPENSEARCH_SECURITY_INDEX_ATTEMPT category actively capturing. Unauthorized security index modification attempt correctly rejected and audited. 1 document confirmed in security-auditlog-*.
