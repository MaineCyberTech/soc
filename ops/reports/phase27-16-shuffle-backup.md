# Phase 27 Shuffle Workflow Backup and Version

Date: 2026-08-24
Status: **DONE** (backup + version captured; rollback preserved).

## Backup

- Exported `wazuh-high-severity-to-iris` (eb937a37) to
  `integrations/shuffle/backups/wazuh-high-severity-to-iris-phase27-export.json` (19.8KB).
- Credential-bearing fields redacted (`<REDACTED>`); no secrets in the backup.

## Version record

- Nodes: 2 (Shuffle Tools "Log received alert"; HTTP "Create DFIR-IRIS alert").
- Branches: 1 (log -> IRIS). Triggers: webhook `wazuh-high-severity` (24636c49).
- Variables: none set.

## Rollback

- Restore = POST the export back to the workflow API (verified update path works, HTTP 200).

## No secrets