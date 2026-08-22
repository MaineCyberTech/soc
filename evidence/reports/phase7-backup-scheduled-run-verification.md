> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 7 Backup Scheduled-Run Verification

Date: 2026-08-12
Status: **JOBS PROVEN via exact-cron-command simulation; automated runs pending schedule timing**

## Method

Cron installed 2026-08-11 22:44 UTC. First automated runs: IRIS 04:30,
MISP 04:35, freshness 06:15 (today); weekly Sun 05:15/05:45/06:00.
To provide scheduled-run proof now, each job was executed with the EXACT
command + output redirection cron uses.

## Results (simulated with cron syntax)

| Job | Cron cmd | Exit | Output |
|---|---|---|---|
| IRIS dump (04:30 daily) | iris-db-dump.sh >> iris-db-cron.log | 0 | iris-db-20260812-021130.sql.gz (36K) |
| MISP dump (04:35 daily) | vm103-misp-db-dump.sh >> vm103-misp-cron.log | 0 | misp-db-20260812-021131.sql.gz (149MB) |
| Freshness (06:15 daily) | phase5-backup-freshness-check.sh >> phase5-freshness-cron.log | 0 | all 5 streams OK, PASS |
| Shuffle export (Sun 05:45) | shuffle-workflow-export.sh >> shuffle-export-cron.log | 0 | shuffle-workflows-20260812-021212.json (30KB) |
| Prune (Sun 06:00 --apply) | prune-phase5-backups.sh --apply >> backup-prune-cron.log | 0 | kept all, pruned 0 (fresh) |
| Greenbone (Sun 05:15) | vm103-greenbone-backup.sh | proven Phase 6 (1.8GB) | scheduled run pending |

## File readability

- All new dumps gzip-integrity verified in earlier checks; freshness PASS confirms.

## Action items

- [ ] 04:40 UTC today: confirm iris-db-cron.log grew by cron (not manual)
- [ ] 04:40 UTC today: confirm vm103-misp-cron.log grew by cron
- [ ] 06:20 UTC today: confirm phase5-freshness-cron.log grew by cron
- [ ] Sunday: confirm greenbone + shuffle + prune weekly runs

## Troubleshooting

ops/runbooks/backup-cron-troubleshooting.md
