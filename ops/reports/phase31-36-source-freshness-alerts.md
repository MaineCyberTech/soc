# Phase 31 Source Freshness Alerts

Date: 2026-08-24
Status: **SCRIPT PROVIDED + TESTED** (p31-source-freshness.sh).

- Tested: guardrail log fresh (rc=0); config bundle fresh (daily 02:30 at /opt/wazuh-backups).
- Wiring plan: cron every 15m checks critical sources (guardrail log, backup bundles, S3
  upload, snapshots, sensor eve.json) with rate-limited notification; stale -> alert with
  owner/runbook (42-44).

## No secrets
