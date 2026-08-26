# Phase 31 Runbook Deep Links

Date: 2026-08-24
Status: **MAPPED**.

| Alert/state | Runbook / rollback |
|---|---|
| Endpoint markers / sysmon | integrations/sysmon/README-sysmon-tuning.md; rollback-sysmon-tune.ps1 |
| Packet sensor | phase31-23 (production plan); integrations/suricata-minimal; service disable rollback |
| Backup freshness | /opt/wazuh-docker/multi-node/ops/runbooks (backup) + phase31-39 |
| Retention/watermark | ISM runbook + phase31-40 |
| Agent disconnect | phase31-37 + endpoint runbooks |
| Credentials | phase30-80 (indexer maintenance); 79/81 (VT/PVE) |
| Release | RELEASE-NOTES + phase31-78 |

## No secrets
