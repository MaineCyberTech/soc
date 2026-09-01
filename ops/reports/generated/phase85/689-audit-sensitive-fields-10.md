---
report_id: 689
phase: 85
title: "Sensitive Fields — Comprehensive Sensitive Field Assessment"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/689-audit-sensitive-fields-10.md
---

## Summary
Sensitive field exclusion comprehensive assessment: Phase 85 baseline clean; current config degraded.

## Scorecard
| Protection | Phase 85 | Current | Status |
|------------|----------|---------|--------|
| exclude_sensitive_headers | true | true | ✓ |
| Authorization header absent | 0 hits | Config unchanged | ✓ |
| Cookie header absent | 0 hits | Config unchanged | ✓ |
| Credential patterns (pwd/secret/token/apikey) | 0 hits | Config degraded | ⚠ UNVERIFIED |
| Bearer/Basic/BCrypt/PEM patterns | 0 hits | Config degraded | ⚠ UNVERIFIED |
| log_request_body | false | true | ✗ DRIFT |
| read_metadata_only | true | false | ✗ DRIFT |
| write_metadata_only | true | false | ✗ DRIFT |
| write_log_diffs | false | false | ✓ |
| Transport header safety | Verified | Config unchanged | ✓ |
| Exception stacktrace safety | Verified | Config unchanged | ✓ |

## Overall Finding
**DEGRADED** — Phase 85 exhaustive scan (140,642 docs) confirmed zero sensitive data leakage across all vectors. Current configuration relaxes 3 critical protections (log_request_body, read_metadata_only, write_metadata_only). Immediate re-scan required to verify current state. Recommend restoring Phase 85 baseline for metadata_only and log_request_body settings.
