# Rollback Index

Rollback path for every workstream. Wazuh volumes are NEVER touched.

| # | Workstream | Change | Rollback | Evidence |
|---|---|---|---|---|
| 1 | Noise reduction | Wazuh rule level/route change | Restore `local_rules.xml` from ops/backups timestamped copy; restart analysisd master+worker; verify PID + cluster green | phase4-routing-changes-applied.md |
| 2 | Noise reduction | OpenSearch monitor suppression | Disable/revert monitor in alerting UI or API | phase4-routing-changes-applied.md |
| 3 | Drills D2-D8 | Test IOCs in CDB | Expire/remove test IOC; re-export CDB (misp-to-wazuh-cdb.py) | d2 report |
| 4 | Drills D3/D4 | Test payload to Shuffle webhook | No persistent change; workflow may need re-run cleanup | d3/d4 reports |
| 5 | Drill D5 | Synthetic critical payload | No persistent change (notify-only mode) | d5 report |
| 6 | Credential rotation | WAZUH_ADMIN_PASSWORD | Keep old value in creds.env until validation passes; restore if indexer auth breaks | phase4-credential-rotation-status.md |
| 7 | Credential rotation | IRIS/MISP API keys | Regenerate + update consumer config (Shuffle workflows) | rotation status |
| 8 | Credential rotation | Cloudflare tunnel token | Restore old token in .env.cloudflare; restart wazuh-cloudflared | rotation status |
| 9 | VM 103 backups | New scripts/cron snippets | Remove cron line; scripts are additive | phase4-backup-coverage.md |
| 10 | mct-canary01 | VM provisioning (not started) | Delete VM if created (not a data volume) | mct-canary01-readiness.md |
| 11 | Sysmon pilot | Agent group config | Move endpoint back to default group; uninstall Sysmon (`Sysmon64.exe -u`) | sysmon-pilot-results.md |
| 12 | Scorecards | Generated reports | None (output only) | - |
| 13 | Capacity | (no moves without approval) | N/A - nothing applied | phase4-capacity-plan.md |

## Golden rules

- Never `docker compose down -v` on any stack.
- Never delete Wazuh/IRIS/MISP/Shuffle/Greenbone/ElastiFlow/SO data volumes.
- Wazuh ingest has priority; if a change degrades ingest, roll it back immediately.
- Every rollback is documented in ops/reports with timestamp.

## Verification after any rollback

```bash
/opt/wazuh-docker/multi-node/ops/scripts/health-check.sh
/opt/mct-security-stack/ops/scripts/full-stack-healthcheck.sh
/opt/mct-security-stack/ops/scripts/backup-dr-audit.sh
```
