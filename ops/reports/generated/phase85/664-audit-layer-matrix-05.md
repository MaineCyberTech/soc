---
report_id: 664
phase: 85
title: "Audit Layer Matrix — Request Body Logging Configuration"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/664-audit-layer-matrix-05.md
---

## Summary
Request body logging configuration shows drift from Phase 85 baseline.

## Evidence
- **Current config**: `log_request_body: true`
- **Phase 85 baseline**: `log_request_body: false`
- **Implication**: Request bodies now being logged to audit index; increases sensitive data exposure risk

## Verification Method
Live API query compared against Phase 85 snapshot.

## Finding
**DRIFT DETECTED** — Request body logging enabled (was disabled in Phase 85). This increases audit index size and potential sensitive data exposure. The Phase 85 sensitive field scan verified zero credential patterns with log_request_body=false; current setting requires re-verification.
