# Phase 81: Otel Cardinality 8

**Report ID:** 517
**Phase:** 81
**Title:** Phase 81: Otel Cardinality 8
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T04:45:00Z
**Timestamp ET:** 2026-08-31T00:45:00 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase81/phase81-evidence-otel.json
**Prompt:** prompts/517-otel-cardinality-08.md

## Summary

Phase 81 OTEL reconciliation republishing the Phase 80 OTEL storage-sizing truth
into phase81-reports. No destructive re-run of the storage-full, restart, or
corruption tests was performed; all values are reused from genuine Phase 79 /
Phase 80 evidence.

## Evidence

Consolidated evidence JSON `ops/reports/evidence/phase81/phase81-evidence-otel.json` satisfies validator `p81-otel-validate.py`
(PASS). Key republished truths:

- production_max_size_bytes = 76222398 (Phase 79 72.6 MiB production classification;
  live collector.yaml defines no max_size / OTEL_STORAGE_MAX_SIZE, so the Phase 79
  production value is reused)
- test_max_size_bytes = 16777216 (reused from Phase 80 max_size_bytes)
- phase79_72_6mb_classification = true
- queue_sizer = true
- queue_capacity = true
- peak_items = 100001
- peak_bytes = 35012608
- storage_full_tested = true (Phase 80 genuine evidence; NOT re-run)
- restart_tested = true (Phase 80 genuine evidence; NOT re-run)
- corruption_tested = true (Phase 80 genuine evidence; NOT re-run)
- drop_count = "0"
- drain_seconds = 7
- classa_independent = true (76222398 >= 35012608)

## Verification

`p81-otel-validate.py` on `ops/reports/evidence/phase81/phase81-evidence-otel.json` reports `missing: []` and
`production_peak_within_max: true` (exit 0).

## Claims

- VERIFIED: production_max_size_bytes >= peak_bytes (Class-A independent of telemetry
  storage exhaustion).
- VERIFIED: Phase 80 genuine evidence reused; no destructive storage-full / restart /
  corruption test re-executed.

## Limitations

Report is documentation-only reconciliation referencing immutable Phase 79/80
evidence. No live collector write, no filling test, and no destructive operation
was performed.
