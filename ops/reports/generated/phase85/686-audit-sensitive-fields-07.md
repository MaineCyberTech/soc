---
report_id: 686
phase: 85
title: "Sensitive Fields — Exception Stacktrace Analysis"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/686-audit-sensitive-fields-07.md
---

## Summary
Exception stacktraces analyzed; hex blobs contain only HTTP protocol bytes.

## Evidence
- **Hex blobs**: 6 occurrences in audit_request_exception_stacktrace field
- **Content**: io.netty.handler.ssl.NotSslRecordException hex dumps of first bytes of non-TLS records
- **Decoded values**: Plain HTTP request lines (e.g., "GET /_cluster/health HTTP/1.1", "POST /index/_search HTTP/1.1")
- **Credential patterns**: 0 matches in any decoded hex blob

## Verification Method
Phase 85 scan hex blob ≥32 chars adjudication (phase85-audit-snapshot.json sensitive_field_scan_live.adjudicated_non_zero_classes[0]).

## Finding
**VERIFIED** — Exception stacktraces contain only protocol-level HTTP bytes; no credentials, secrets, or sensitive data in error traces.
