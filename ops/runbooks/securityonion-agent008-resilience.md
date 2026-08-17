# Security Onion Agent 008 Resilience Runbook

Date: 2026-08-17

## Detect agent 008 down

1. Check status: `docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -i 008`
   - Look for Status != Active or stale keepalive.
2. Check event flow: query indexer for agent.id:008 in last 30m.
3. Check SO host: `ps aux | grep -E "wazuh-(agentd|logcollector)"` (expect 2+).
4. Check zeek-forward: `systemctl is-active zeek-forward` (expect active).

## Known fragility (P17/P18 finding)

- `wazuh-control restart` on SO can kill all agent processes WITHOUT restarting
  them (observed 2026-08-16: 0 procs after restart).
- ALWAYS verify procs after restart; use start if missing.

## Safe restart

```bash
# 1. Restart
sudo /var/ossec/bin/wazuh-control restart
# 2. VERIFY (critical - do not skip)
ps aux | grep -cE "wazuh-(agentd|logcollector|syscheckd|execd|modulesd)"
# Expect >= 4. If 0: 
sudo /var/ossec/bin/wazuh-control start
# 3. Verify agent reconnects (manager side)
docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -i 008
```

## Post-restart validation

- Zeek docs flowing (indexer query agent.id:008, decoder zeek-conn).
- Suricata eve.json: no logcollector error in ossec.log.
- Queue-full alerts: 0 new.

## Healthcheck improvement (backlog)

- Add agent 008 proc-count check to full-stack-healthcheck (SO host SSH).

## No secrets
