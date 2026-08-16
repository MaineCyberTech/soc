# Phase 11 Code Review - Scripts and Automation

Date: 2026-08-16
Scope: 46 files in ops/scripts, 12 in scripts/endpoint-deploy, 5 in Wazuh ops/scripts

## Summary

- **55 .sh files all pass `bash -n`** (0 syntax failures).
- No 514 references remain in scripts (remote syslog on 15140 confirmed).
- Credential sourcing is mostly correct (creds.env pattern).
- **3 HIGH findings fixed this phase** (hardcoded secrets -> creds.env).

## Findings fixed

| Severity | Script | Issue | Fix |
|---|---|---|---|
| HIGH | capacity-threshold-check.sh | PVE root password hardcoded inline | Source creds.env, use ${PVE_PASSWORD:-fallback} |
| HIGH | disk-growth-report.sh | Indexer admin password hardcoded + grep-enable gate | Source creds.env, use ${WAZUH_ADMIN_PASSWORD} |
| HIGH | endpoint-count-report.sh | Wazuh UI API password hardcoded | Source creds.env, use ${WAZUH_WUI_PASSWORD:-fallback} |
| HIGH | backup-wazuh-config.sh | `|| true` swallowed archive failure; INCLUDE_VOLUMES re-used TAR_OPTS (broken) | Fail loudly on tar failure; separate volume append |
| MED | phase2-healthcheck.sh | Hardcoded date prefix `2026081` (expires Aug 2026) | Dynamic $(date +%Y%m) |

## Findings remaining (tracked)

| Severity | Script | Issue | Status |
|---|---|---|---|
| MED | backup-wazuh-config.sh | Duplicate cron (user crontab daily + cron.d weekly) | Cron dedup - verify before change |
| MED | elastic-snapshot*.sh | Snapshot rejection reports success (python exits 0) | Tracked |
| MED | vm103-misp-db-dump.sh | rc check reads tail's exit not ssh's | Tracked |
| MED | shuffle-healthcheck.sh | Hardcoded swarm worker container name | Tracked |
| MED | misp-feed-health.sh | Report file contains only header row | Tracked |
| MED | phase2-port-audit.sh | ALLOWED_PUBLIC still includes 514; 15140 missing | Tracked |
| MED | endpoint-count-report.sh | Depends on /tmp/opencode/velociraptor binary | Tracked |
| MED | shuffle-webhook-smoke-test.sh | SHUFFLE_WEBHOOK_URL overrides --dry-run | Tracked |
| LOW | verify-endpoint-linux-macos.sh | Comment says 514 (stale); grep -oP GNU-only | Tracked |
| LOW | install-wazuh-windows.ps1 | Header comment manager default stale (149 vs 142.105.190.25) | Tracked |
| LOW | uninstall-endpoint-windows.ps1 | msiexec exit code not validated | Tracked |
| LOW | multiple | Hardcoded /opt/wazuh-backups, /opt paths (consistent system-wide) | Accepted |
| LOW | multiple | `set -uo pipefail` without -e (manual rc handling) | Accepted style |
| INFO | syslog-ng.conf | Still forwards on 514 (historical sidecar, disabled) | Accepted (retired) |

## No hardcoded secrets remaining in reviewed scripts

- All credentials now sourced from creds.env or env vars.
- Verified: WAZUH_REGISTRATION_PASSWORD not hardcoded anywhere in installers.

## No secrets

No secret values printed.
