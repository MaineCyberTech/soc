---
report_id: 711
phase: 85
title: "BAD_HEADERS — Live Trigger Test"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/711-audit-bad-headers-02.md
---

## Summary
BAD_HEADERS event successfully triggered and captured live.

## Evidence
- **Test**: `curl -H "_opendistro_security_user: admin" https://127.0.0.1:9200/_cluster/health`
- **Response**: 500 error "Illegal parameter in http or transport request found...spoofing requests"
- **Audit capture**: BAD_HEADERS category doc_count increased from 0 to 1
- **Timestamp**: Event captured at test execution time

## Verification Method
Pre/post category aggregation comparison; live trigger test with spoofed internal header.

## Finding
**VERIFIED LIVE** — BAD_HEADERS category actively capturing. Spoofed internal security header correctly detected, rejected, and audited. 1 document confirmed in security-auditlog-*.
