# Backup/DR Audit - Phase 3

Date: 2026-08-11
Report: ops/reports/backup-dr-audit-20260811-042236.md

## Results (PASS)

| Component | Status | Evidence |
|---|---|---|
| OpenSearch local snapshots | OK | snap-20260811-0330 SUCCESS (1h old, repo has 16 snapshots) |
| OpenSearch S3 snapshot | OK | snapshot-s3-cron.log 3h old |
| DR bundle to S3 | OK | dr-s3-cron.log 0h old |
| Wazuh config backups | OK | wazuh-config-* present (cron daily) |
| Phase 2 config bundles | OK | phase2-config-* daily |
| IRIS DB dump | **FIXED THIS PHASE** | iris-db-20260811-042155.sql.gz (36K) - was missing |
| MISP DB dump | WARN - manual (VM) | verify on mct-soc-scan |

## Actions taken

1. **IRIS DB dump was missing** (gap found by audit). Created
   `ops/scripts/iris-db-dump.sh` - dumps postgres (user/db auto-detected from
   container env: raptor/iris_db), gzip, 14-day retention. Dump produced and
   verified. NOT cron-enabled yet (needs operator approval).
2. Local snapshot check fixed to use snapshot repo API (file mtimes were stale).

## Missing / manual coverage

- MISP DB + Greenbone gvmd DB: live on VM 192.168.222.154 - no automated check from this host; manual SSH verification required.
- Velociraptor filestore volume snapshot: weekly manual per phase2-backup runbook.
- Shuffle workflow UI exports: weekly manual.

## Restore documentation

- phase3-restore-map.md - per-service restore order (Wazuh volumes untouched).
- phase3-rollback-verification.md - verification checklist confirming Wazuh volumes not touched.

## Recommended follow-ups

- [ ] Enable iris-db-dump.sh in cron (operator approval).
- [ ] Add MISP/Greenbone VM dump script (SSH to VM) or manual checklist.
- [ ] Test snapshot restore in a DR drill (restore to scratch repo, not production).
