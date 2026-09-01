---
report_id: 662
phase: 85
title: "Audit Layer Matrix — Disabled Categories Configuration"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/662-audit-layer-matrix-03.md
---

## Summary
Disabled categories configuration reviewed; drift detected from Phase 85 baseline.

## Evidence
- **Current config**: `disabled_rest_categories: []` (empty), `disabled_transport_categories: ["AUTHENTICATED","GRANTED_PRIVILEGES"]`
- **Phase 85 baseline**: Both arrays were empty (`[]`)
- **Drift**: AUTHENTICATED and GRANTED_PRIVILEGES now explicitly disabled on transport layer

## Verification Method
Live API query to `/_plugins/_security/api/audit` compared against Phase 85 snapshot (phase85-audit-snapshot.json).

## Finding
**PARTIAL** — REST layer has no disabled categories (all enabled). Transport layer has 2 explicitly disabled categories (AUTHENTICATED, GRANTED_PRIVILEGES) that were not disabled in Phase 85. This reduces transport-layer audit coverage for successful authentications and privilege grants.
