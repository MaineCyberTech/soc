---
report_id: 666
phase: 85
title: "Audit Layer Matrix — Compliance Read/Write Metadata Configuration"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/666-audit-layer-matrix-07.md
---

## Summary
Compliance metadata-only configuration shows drift from Phase 85 baseline.

## Evidence
- **Current config**: `read_metadata_only: false`, `write_metadata_only: false`
- **Phase 85 baseline**: Both `true`
- **Implication**: Full document content (not just metadata) now being logged for compliance events

## Verification Method
Live API query compared against Phase 85 snapshot.

## Finding
**DRIFT DETECTED** — Compliance metadata-only logging disabled. Phase 85 verified zero bcrypt hashes in audit log due to metadata-only + write_log_diffs=false. Current configuration requires re-verification of sensitive field exclusion.
