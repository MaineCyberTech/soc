> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 4 Backup Coverage

Date: 2026-08-11

## New coverage added this phase

| Component | Script | Test result | Size | Cadence proposed |
|---|---|---|---|---|
| MISP DB (VM103) | vm103-misp-db-dump.sh | PASS | 149 MB gz | daily |
| Greenbone gvmd DB (VM103) | vm103-greenbone-backup.sh | PASS (manual pull) | 1.8 GB gz | weekly |
| Shuffle workflows | shuffle-workflow-export.sh | PASS | 30 KB | weekly |
| VM103 freshness | vm103-backup-freshness-check.sh | PASS | - | daily |

## Full coverage matrix

| Component | Status | Evidence |
|---|---|---|
| OpenSearch local snapshots | OK | 16 snapshots, latest SUCCESS |
| OpenSearch S3 snapshot | OK | cron 5h |
| DR bundle S3 | OK | daily |
| Wazuh config | OK | daily cron |
| Phase 2 config bundles | OK | daily cron |
| IRIS DB | OK | iris-db-dump.sh (36K), Phase 3 |
| **MISP DB** | **NOW COVERED** | vm103-misp-db-dump.sh (149 MB) |
| **Greenbone gvmd** | **NOW COVERED** | vm103-greenbone-backup.sh (1.8 GB) |
| **Shuffle workflows** | **NOW COVERED** | shuffle-workflow-export.sh (30 KB) |
| Velociraptor config | PARTIAL | in phase2 config bundle; filestore manual |
| Greenbone reports | PARTIAL | exported on-demand; add to weekly dump |

## Greenbone dump operational note

- gvmd DB ~9.8 GB uncompressed / 1.8 GB gz; dump takes ~5-10 min.
- The inline scp in vm103-greenbone-backup.sh can race the gzip (first attempt
  produced a truncated file). Recommended flow (documented in runbook):
  run dump on VM with nohup, verify gzip -t on VM, then scp. Cron version must
  follow this pattern.

## Cron status

- Cron snippets created: ops/cron/phase4-backup-cron.example
- **NOT INSTALLED** - operator approval required (daily MISP, weekly Greenbone+Shuffle, freshness check, IRIS dump).

## Blockers

- Velociraptor filestore snapshot (weekly manual) - no automation yet.
- Greenbone feed re-sync after restore is long-running (off-peak only).
- Disk impact: Greenbone backups ~1.8 GB/week at 14-day retention (~3.6 GB peak); host at 75% disk - monitor.

## Files

- ops/scripts/vm103-misp-db-dump.sh
- ops/scripts/vm103-greenbone-backup.sh
- ops/scripts/shuffle-workflow-export.sh
- ops/scripts/vm103-backup-freshness-check.sh
- ops/runbooks/vm103-backup-restore.md
- ops/cron/phase4-backup-cron.example
