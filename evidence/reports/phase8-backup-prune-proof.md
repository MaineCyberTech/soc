> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 8 Backup Prune Proof

Date: 2026-08-15
Status: **PASS - scheduled prune ran with --apply**

## Evidence

- backup-prune-cron.log (Sun run): APPLY mode
- IRIS kept 3, pruned 0 (all < 14d)
- MISP kept 2, pruned 0
- Greenbone kept 1, pruned 0 (< 35d)
- Shuffle kept 2, pruned 0 (< 56d)

## Safety

- Explicit patterns only; no secret/phase2 files touched.
- Retention windows correct (nothing deleted prematurely).

## Note

- First prune ran 08-12 (manual simulation log); scheduled Sunday prune will
  append on each Sunday run.
