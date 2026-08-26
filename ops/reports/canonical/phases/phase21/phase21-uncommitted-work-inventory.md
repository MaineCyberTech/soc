# Phase 21 Uncommitted Work Inventory

Date: 2026-08-19

## By directory

| Directory | Untracked files |
|---|---|
| ops/reports | 65 (phase19 x25, phase20 x37, phase21 x2, proxmox-thinpool x1) |
| integrations/macos | 6 |
| integrations/security-onion | 5 (incl. zeek rules v2.2 XML) |
| integrations/shuffle | 3 |
| integrations/elastiflow | 3 |
| integrations/syslog | 2 |
| integrations/dfir-iris | 2 |
| client-onboarding | 1 |
| ops/runbooks | 1 (index-retention-policy.md) |
| service-packaging | 1 |

## Tracked operational files that dirty git status (should be untracked)

- ops/reports/backup-cron.log, backup-log.txt, backup-prune-cron.log, iris-db-cron.log,
  misp-cdb-cron.log, phase5-freshness-cron.log, shuffle-boot-repair.log, shuffle-export-cron.log,
  vm103-misp-cron.log, full-stack-health-latest.md

These were tracked before .gitignore rules were added; they change every cron/health run.

## Sensitive files NOT tracked (verified safe)

- creds.env, .env, ops/backups/, *.key, *.pem, *.tar.gz - all gitignored.
- wazuh-docker repo (separate, public origin): wazuh_manager.conf local mod (VirusTotal key) is
  UNCOMMITTED; docker-compose.override.yml (indexer password literals) is UNTRACKED. Both
  excluded from any push; Phase 21.04 remediates.

## No secrets