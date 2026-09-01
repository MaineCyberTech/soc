---
report_id: 669
phase: 85
title: "Audit Layer Matrix — Layer Matrix Summary & Drift Report"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/669-audit-layer-matrix-10.md
---

## Summary
Audit layer matrix comprehensive verification: 5/10 configurations match Phase 85 baseline; 5 show drift.

## Drift Summary
| Setting | Phase 85 | Current | Status |
|---------|----------|---------|--------|
| audit.enable_rest | true | true | ✓ VERIFIED |
| audit.enable_transport | true | true | ✓ VERIFIED |
| disabled_rest_categories | [] | [] | ✓ VERIFIED |
| disabled_transport_categories | [] | ["AUTHENTICATED","GRANTED_PRIVILEGES"] | ✗ DRIFT |
| ignore_users | ["kibanaserver"] | ["kibanaserver"] | ✓ VERIFIED |
| log_request_body | false | true | ✗ DRIFT |
| resolve_indices | true | true | ✓ VERIFIED |
| resolve_bulk_requests | false | false | ✓ VERIFIED |
| read_metadata_only | true | false | ✗ DRIFT |
| write_metadata_only | true | false | ✗ DRIFT |
| internal_config | true | false | ✗ DRIFT (CRITICAL) |
| external_config | false | false | ✓ VERIFIED |
| write_log_diffs | false | false | ✓ VERIFIED |

## Overall Finding
**PARTIAL** — Core audit pipeline (REST+Transport enabled, indices capturing) operational. However, 5 configuration drifts detected, including CRITICAL disablement of internal_config auditing (RBAC change tracking) and relaxation of sensitive data protections (log_request_body, metadata_only). Remediation recommended to restore Phase 85 baseline.
