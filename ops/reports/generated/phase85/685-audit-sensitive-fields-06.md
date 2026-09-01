---
report_id: 685
phase: 85
title: "Sensitive Fields — Transport Header Analysis"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/685-audit-sensitive-fields-06.md
---

## Summary
Transport headers analyzed; internal security headers excluded; base64 blobs benign.

## Evidence
- **Distinct REST request header keys observed**: Host, Content-Type, Accept, Accept-Charset, User-Agent, Accept-Encoding, Content-Length, Connection, content-length
- **Excluded headers**: Authorization, Cookie, Set-Cookie, Proxy-Authorization (via exclude_sensitive_headers=true)
- **Transport headers**: audit_transport_headers contains OpenSearch Security internal objects (_opendistro_security_user, _opendistro_security_remote_address, _opendistro_security_source_field_context) serialized as base64
- **Base64 adjudication**: 3,778 docs with transport headers; 7,468 base64 blobs decoded; 0 credential patterns

## Verification Method
Phase 85 exhaustive scan distinct_rest_request_header_keys_present and base64 adjudication (phase85-audit-snapshot.json sensitive_field_scan_live).

## Finding
**VERIFIED** — Transport headers contain only safe operational headers. Internal security objects base64-encoded but contain no credentials. Header exclusion mechanism functioning.
