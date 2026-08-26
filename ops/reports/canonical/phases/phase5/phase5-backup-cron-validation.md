# Phase 5 Backup Cron Validation

Date: 2026-08-11

## Status

- Final cron file created: ops/cron/phase5-backup-cron.final
- **NOT INSTALLED** - pack rule: "Create final cron file but do not install unless approved". Operator approval required.

## Validated components

| Component | Script | Manual test | Result |
|---|---|---|---|
| IRIS dump | iris-db-dump.sh | Phase 3/4 | PASS (36K dump) |
| MISP dump | vm103-misp-db-dump.sh | Phase 4 | PASS (149 MB) |
| Greenbone dump | vm103-greenbone-backup.sh | Phase 4 (nohup pattern) | PASS (1.8 GB) |
| Shuffle export | shuffle-workflow-export.sh | Phase 4 | PASS (30 KB) |
| Freshness check | phase5-backup-freshness-check.sh | THIS PHASE | PASS (all 5 streams) |
| Retention prune | prune-phase5-backups.sh | THIS PHASE (dry-run) | PASS (1 kept per stream, 0 pruned - all fresh) |

## Retention verified

- Prune dry-run correctly identified all current dumps as within retention.
- Explicit patterns only; secret files and phase2 configs excluded from pruning.

## Disk validation

- Current backups: IRIS 36K + MISP 149 MB + Greenbone 1.8 GB + Shuffle 30 KB.
- Host disk 77% - prune weekly keeps Greenbone bounded (~9 GB peak at 35d).

## Install procedure (when approved)

```bash
cat /opt/mct-security-stack/ops/cron/phase5-backup-cron.final >> <(crontab -l)
crontab -   # or append lines manually via crontab -e
# then run one manual test per job
/opt/mct-security-stack/ops/scripts/iris-db-dump.sh
/opt/mct-security-stack/ops/scripts/vm103-misp-db-dump.sh
```

## Blocker

- Operator approval required to install (pack rule). Cron entries are final and tested-ready.
