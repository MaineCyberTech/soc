---
report_id: 687
phase: 85
title: "Sensitive Fields — Compliance Read Metadata-Only Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/687-audit-sensitive-fields-08.md
---

## Summary
Compliance read metadata-only verified at Phase 85 baseline; currently disabled.

## Evidence
- **Phase 85 config**: read_metadata_only=true
- **Observed behavior**: 68 COMPLIANCE_INTERNAL_CONFIG_READ events; all audit_request_body values are field-name lists only (e.g., {"field_names":["internalusers"]})
- **Internalusers protection**: 13 reads of internalusers document (contains bcrypt hashes) — never logged hash, only field_names
- **Current config**: read_metadata_only=false — full document content now logged on reads

## Verification Method
Phase 85 scan request_body_field analysis; live config comparison.

## Finding
**BASELINE VERIFIED, CURRENTLY DISABLED** — Phase 85 metadata-only enforcement prevented hash leakage. Current config (read_metadata_only=false) removes this protection; compliance reads will now log full document content including bcrypt hashes if internal_config re-enabled.
