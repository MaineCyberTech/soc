# Phase 9 Backup Operations Runbook

## Job inventory

| Job | Cron | Script | Log | Retention |
|---|---|---|---|---|
| OpenSearch local snapshot | 17 */5 | elastic-snapshot.sh | /opt/wazuh-backups/snapshot-cron.log | 7d |
| S3 snapshot | 47 */5 | elastic-snapshot-s3.sh | /opt/wazuh-backups/snapshot-s3-cron.log | 30d |
| DR bundle to S3 | 0 4 * * * | dr-s3-bundle.sh | /opt/wazuh-backups/dr-s3-cron.log | n/a |
| Config backup | 30 2 * * * (daily) + Sun 04:30 (weekly) | backup-wazuh-config.sh | /tmp/wazuh-backup-cron.log + /opt/wazuh-backups/config-cron.log | 14d |
| IRIS dump | 30 4 * * * | iris-db-dump.sh | ops/reports/iris-db-cron.log | 14d |
| MISP dump | 35 4 * * * | vm103-misp-db-dump.sh | ops/reports/vm103-misp-cron.log | 14d |
| Greenbone dump | 15 5 * * 0 | vm103-greenbone-backup.sh | ops/reports/vm103-greenbone-cron.log | 35d |
| Shuffle export | 45 5 * * 0 | shuffle-workflow-export.sh | ops/reports/shuffle-export-cron.log | 56d |
| Prune | 0 6 * * 0 | prune-phase5-backups.sh --apply | ops/reports/backup-prune-cron.log | n/a |
| Freshness | 15 6 * * * | phase5-backup-freshness-check.sh | ops/reports/phase5-freshness-cron.log | n/a |

## Phase 9 changes

1. **backup-wazuh-config.sh**: added `cd /opt/wazuh-docker/multi-node` - fixes
   empty (45-byte) archives from cron CWD mismatch. VERIFIED (145KB valid archive).
2. Config archive naming unchanged: wazuh-config-<ts>.tar.gz.

## Verification checklist (weekly)

- [ ] freshness check PASS (all streams < thresholds)
- [ ] prune log shows correct keep/prune
- [ ] shuffle export JSON present
- [ ] greenbone dump present (Sunday)
- [ ] config archive valid (gzip -t as root)
- [ ] DR S3 bundle: watch for 403 (open issue - needs valid DO keys)

## Troubleshooting

- Empty config archives: script must run from stack root (fixed in P9.08).
- S3 403 SignatureDoesNotMatch: stale DO_SPACES keys in creds.env - fix per
  phase9-s3-snapshot-policy-review.md.
- Freshness FAIL > 48h: check the specific stream log.

## No secrets

No secret values printed.
