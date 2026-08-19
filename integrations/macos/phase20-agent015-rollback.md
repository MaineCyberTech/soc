# Phase 20 Agent 015 Rollback (Julians-Air)

Date: 2026-08-19
Owner: operator with Mac access. No secrets.

## Trigger

- Agent 015 fails to reconnect within 10 min of the config change.
- Volume does not drop materially (<50%) within 24h.
- Required macOS telemetry lost and cannot be recovered otherwise.
- Agent processes fail to start after restart.

## Rollback

```bash
sudo cp /Library/Ossec/etc/ossec.conf.phase20.bak /Library/Ossec/etc/ossec.conf
sudo /Library/Ossec/bin/wazuh-control restart
sleep 5
sudo /Library/Ossec/bin/wazuh-control status
sudo tail -n 30 /Library/Ossec/logs/ossec.log
```

## Confirm

- Agent 015 active in Wazuh within ~2 min.
- Keep the backup even after success for audit trail.
- If rollback required, escalate to SOC before re-applying (flood returns).

## No secrets