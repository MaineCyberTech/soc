> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 4 Noise Before/After Comparison

Date: 2026-08-11

| metric | before (24h) | after (expected 24h) | delta | status |
|---|---|---|---|---|
| total alerts | 520,670 | ~257k | -50.6% | APPLIED - verify after 24h |
| osquery 24010 | 263,490 | 0 (archive only) | -263,490 | VERIFIED (0 since 05:32Z) |
| UniFi family | ~238,074 | unchanged | 0 | proposed C digest - not applied |
| mct-portal/auditd | ~18,373 | unchanged | 0 | proposed C/D - not applied |
| Class A (OpenCanary/MISP/flow) | intact | intact | 0 | verified |

## Evidence

- Before: ops/reports/alert-volume-by-rule-20260811-052509.md (520,670 total, track_total_hits)
- Applied: ops/reports/phase4-routing-changes-applied.md
- After verification: rule 24010 = 0 alerts since 05:32Z (post-restart timestamps)
- logtest: 24010 matched level 0; child 24013 matched level 4

## Disclosure

- Measurement window short (~5 min post-restart at write time). Full 24h
  re-baseline scheduled after steady state (procedure in phase4-noise-after.md).
- UniFi/mctportal reductions are PROPOSED only - no monitor/workflow changes
  executed; alert levels unchanged for those families.
