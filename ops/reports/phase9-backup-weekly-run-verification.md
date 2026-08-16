# Phase 9 Backup Weekly Run Verification

Date: 2026-08-15
Scope: weekly jobs (prune, shuffle, Greenbone) + daily jobs + config backup fix

## Weekly jobs

| Job | Schedule | Last run | Evidence |
|---|---|---|---|
| Prune (backup retention) | Sun 06:00 | 2026-08-12 02:12 | prune log: kept 3 IRIS / 2 MISP / 1 GB / 2 Shuffle, pruned 0 (retention correct) |
| Shuffle workflow export | Sun 05:45 | 2026-08-12 02:12 | shuffle-workflows-20260812-021212.json (30369 bytes) |
| Greenbone gvmd dump | Sun 05:15 | 2026-08-11 (manual/setup) | greenbone-gvmd-20260811-060311.sql.gz on disk; cron log not yet created - first scheduled run 2026-08-16 |

Note: weekly cron times in /etc/cron.d/wazuh-backups + user crontab are Sun 05:15/05:45/06:00; the Aug 12 02:12 entries were earlier manual/simulated runs. The next scheduled Sunday run (Aug 16) will produce fresh logs.

## Daily jobs

| Job | Last run | Result |
|---|---|---|
| IRIS DB dump (04:30) | 2026-08-15 04:30 | OK (40K) |
| MISP DB dump (04:35) | 2026-08-15 04:35 | OK (151MB) |
| OpenSearch local snapshot (5h) | 2026-08-15 15:17 | SUCCESS |
| S3 snapshot (5h) | 2026-08-15 15:47 | SUCCESS (34 total) |
| Freshness check (06:15) | 2026-08-15 06:15 | **PASS** (all streams) |
| DR S3 bundle (04:00) | - | **FAILING (403)** - see phase9-s3-snapshot-policy-review.md |

## Config backup FIX (Phase 9)

- Preflight finding: cron produced 45-byte EMPTY archives (relative paths + wrong CWD).
- Fix: added `cd /opt/wazuh-docker/multi-node` to backup-wazuh-config.sh.
- Verified: manual run from CWD=/ produced 145KB valid archive (94 files: compose, override, cloudflare, configs, certs). gzip VALID.
- Freshness check reads config-cron.log (weekly Sunday 04:30) with 72h threshold - will PASS after Aug 16 run.

## Readability validation

- gzip VALID on new config archive.
- IRIS/MISP dumps: SQL.gz files present, sizes sane.
- Shuffle export: JSON present.
- Greenbone dump: sql.gz present.

## Action items

1. Verify fresh logs after Sunday Aug 16 cron runs (prune, shuffle, greenbone, config).
2. DR S3 bundle 403: needs valid DO Spaces keys (open action, P9.03).

## No secrets

No secret values printed.
