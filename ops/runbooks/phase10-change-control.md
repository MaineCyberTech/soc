# Phase 10 Change Control Runbook

Date: 2026-08-15
Purpose: track and document all production/lab changes during Phase 10.

## Rules

- All changes logged with timestamp, component, action, before/after, validation.
- No `docker compose down -v` ever.
- No production data volume deletion.
- Credential rotation: one at a time, validate before revoke, only with new values.
- No production DR restore - scratch only (VM203).

## Change log

| # | Timestamp | Component | Change | Before | After | Validation |
|---|---|---|---|---|---|---|
| 1 | 2026-08-15 23:35 | Windows agent 012 | Restarted WazuhSvc (logcollector stalled at 21:00 UTC) | agent events stopped at 21:00; keepalive active | events flowing (23:35+), sysmon flowing, indexed current | archive index current 23:36 |
| 2 | 2026-08-15 (audit) | data/opencanary/opencanary.conf | Local canary syslog 514 -> 15140 | local canary broken (silent) after 514->15140 move | rule 121012 firing | alert 23:25:58 |
| 3 | 2026-08-15 (audit) | config/wazuh_cluster/wazuh_worker.conf | Removed legacy <syslog_output> to SO:514 | worker forwarded alerts to SO | no forwarding (SO retired as receiver) | grep clean |
| 4 | 2026-08-15 (audit) | docs | 25+ files updated (SO model, 15140, greenbone schedule, agent 008) | stale refs | accurate | phase9-docs-audit report |

## Rollback notes

- Agent 012: restart is non-destructive; if events stop again check logcollector +
  the sysmon channel localfile.
- Local canary: revert port to 514 only if master syslog moves back (unlikely).
- Worker syslog_output: re-add block if SO-as-receiver is ever restored.

## Verification procedure (any change)

1. Apply change.
2. Restart affected service.
3. Validate functional path (event flow, alert firing, healthcheck).
4. Update this log.

## No secrets

No secret values printed.
