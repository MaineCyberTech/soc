---
report_id: 684
phase: 85
title: "Sensitive Fields — Request Body Content Analysis"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/684-audit-sensitive-fields-05.md
---

## Summary
Request body content analyzed at Phase 85 baseline; current config logs bodies.

## Evidence
- **Phase 85 baseline**: log_request_body=false, 68 docs with audit_request_body (all COMPLIANCE_INTERNAL_CONFIG_READ)
- **Body content**: Field-name lists only (e.g., {"field_names":["roles"]}, {"field_names":["internalusers"]})
- **Length range**: 25-33 chars (avg 28), consistent with metadata-only
- **Critical finding**: 13 reads of 'internalusers' document (contains bcrypt hashes) recorded ONLY field_names, never hashes
- **Current config**: log_request_body=true — all REST request bodies now logged

## Verification Method
Phase 85 scan request_body_field analysis (phase85-audit-snapshot.json sensitive_field_scan_live.request_body_field).

## Finding
**BASELINE CLEAN, CURRENT RISK** — Phase 85 verified request bodies contain only metadata field lists. Current log_request_body=true will log all REST request bodies (including potential credentials in POST bodies). Immediate re-scan recommended.
