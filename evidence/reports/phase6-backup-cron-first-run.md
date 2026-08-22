> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 6 Backup Cron First-Run Verification

Date: 2026-08-11

## Status

- Cron installed 2026-08-11 22:44 UTC (6 jobs).
- Daily jobs (IRIS 04:30, MISP 04:35, freshness 06:15) FIRST AUTOMATED RUN
  due tomorrow 04:xx - **pending by schedule timing** (verified manually at install).
- Weekly jobs (Greenbone Sun 05:15, Shuffle Sun 05:45, prune Sun 06:00) - next Sun.

## Manual verification at install (equivalent to cron execution)

| Stream | Result | Evidence |
|---|---|---|
| IRIS dump | PASS | iris-db-20260811-224405.sql.gz (36K), gzip readable |
| Shuffle export | PASS | shuffle-workflows-20260811-224406.json (30KB), JSON valid |
| Freshness | PASS | phase5-backup-freshness-check: all 5 streams OK |
| Prune (--apply) | PASS | 0 pruned (all fresh); explicit patterns only |

## File readability

- IRIS, MISP, Greenbone dumps: gzip -t PASS (usable, not just present)
- Shuffle export: JSON parse PASS

## Action items

- [ ] Tomorrow 04:40: confirm iris-db-<date>.sql.gz created by cron (not manual)
- [ ] Tomorrow 04:40: confirm vm103 misp-db-<date>.sql.gz created by cron
- [ ] Sunday: confirm greenbone + shuffle weekly runs + prune
- [ ] Verify cron logs: ops/reports/iris-db-cron.log etc. (first runs)

## Troubleshooting

See backup-cron-troubleshooting.md if a job fails.
