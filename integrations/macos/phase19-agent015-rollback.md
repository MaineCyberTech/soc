# Phase 19 Agent 015 (Julians-Air) Rollback

Date: 2026-08-18
Owner: operator with Mac access. No secrets required.

## Trigger

Rollback if any of the following after applying the Phase 19 change:

- Agent 015 does not reconnect within 10 minutes of restart.
- Archive volume does not drop materially (< 50% reduction) within 24h.
- Legitimately-needed macOS telemetry is missing AND cannot be restored another way.
- Agent-local config edit breaks `wazuh-control restart` (processes fail to start).

## Rollback procedure

1. Restore backup:

```bash
sudo cp /Library/Ossec/etc/ossec.conf.phase19.bak /Library/Ossec/etc/ossec.conf
```

2. Restart agent:

```bash
sudo /Library/Ossec/bin/wazuh-control restart
sleep 5
sudo /Library/Ossec/bin/wazuh-control status
```

3. Verify:

```bash
sudo tail -n 30 /Library/Ossec/logs/ossec.log   # no errors
# Wazuh dashboard: agent 015 shows active within ~2 min
```

## SOC-side confirmation of rollback

- Agent 015 `lastKeepAlive` fresh (Wazuh API).
- Agent 015 archive volume returns to pre-fix level (flood pattern ~1.4M/day) - expected
  if rollback is complete; confirm with SOC before accepting this.

## Notes

- Rollback restores full flood behaviour. If rollback is required, escalate to SOC -
  Phase 19.02 remediation must be re-planned before re-apply.
- Keep `ossec.conf.phase19.bak` even after a successful rollback for audit trail.