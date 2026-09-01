---
report_id: 683
phase: 85
title: "Sensitive Fields — Secret Derived Data Exclusion Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/683-audit-sensitive-fields-04.md
---

## Summary
Secret-derived data (bcrypt hashes, base64-encoded secrets, hex blobs) exclusion verified at Phase 85 baseline.

## Evidence
- **Phase 85 scan adjudication**:
  - 6 hex blobs (≥32 chars) in audit_request_exception_stacktrace: all decode to HTTP request lines (GET/POST + path), 0 credential patterns
  - 7,631 base64 blobs (≥40 chars) in transport headers/scroll_ids: all decode to OpenSearch Security internal objects or scroll context IDs, 0 credential patterns
- **Compliance read bodies** (68 docs): Only field-name lists (e.g., {"field_names":["internalusers"]}), never actual hash values
- **write_log_diffs**: false (unchanged) — no configuration payloads in write events

## Verification Method
Phase 85 exhaustive scan with automated base64/hex decoding and re-scanning (phase85-audit-snapshot.json sensitive_field_scan_live.adjudicated_non_zero_classes).

## Finding
**BASELINE VERIFIED** — Zero secret-derived data in audit index at Phase 85 baseline. Current config drift (metadata_only=false) requires re-verification for compliance write events.
