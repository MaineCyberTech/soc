> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 8 Backup Scheduled-Run Proof

Date: 2026-08-15
Status: **PROVEN - scheduled cron runs verified with real outputs**

## Evidence (real cron runs, not simulations)

| Job | Schedule | Proof |
|---|---|---|
| IRIS dump | daily 04:30 | iris-db-cron.log: runs 08-12/13/14 04:30 (iris-db-20260814-043002.sql.gz, 40K) |
| MISP dump | daily 04:35 | vm103-misp-cron.log: misp-db-20260814-043501.sql.gz (150MB) |
| Freshness | daily 06:15 | phase5-freshness-cron.log 08-14 06:15: PASS |
| Prune | Sun 06:00 | backup-prune-cron.log: APPLY ran, kept 3/2/1/2, pruned 0 |
| Shuffle export | Sun 05:45 | shuffle-export-cron.log: export 30KB |
| Greenbone | Sun 05:15 | pending next Sunday (Aug 16) |

## Readability

- IRIS scheduled dump: gzip -t PASS
- MISP scheduled dump: gzip -t PASS
- Shuffle export: JSON parse PASS

## Dump counts

- IRIS: 6 dumps (multiple scheduled days)
- MISP: 5 dumps

## Notes

- The 20260812-021130 entry in iris log = Phase 7 manual simulation; genuine
  04:30 cron runs confirmed on 12/13/14.
- Prune retention verified: nothing deleted prematurely; all within keep windows.
- S3 snapshots: 31 (do-spaces repo) - DR copy healthy.

## Files

- ops/reports/phase8-backup-scheduled-run-proof.md (this file)
- ops/reports/phase8-backup-prune-proof.md
- ops/runbooks/backup-cron-operations-phase8.md
