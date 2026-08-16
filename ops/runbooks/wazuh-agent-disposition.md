# Wazuh Agent Disposition Runbook

Use for never-connected, duplicate, retired, or stale agents.

## Options

- **Re-enroll**: if a real target system exists and the agent can be installed.
- **Remove**: if no corresponding system exists (phantom registration) or the
  agent is definitively decommissioned.
- **Mark retired/historical**: if you want to keep the registration for records.
- **Exclude from billing/coverage**: if the agent exists but is internal-only.

## Decision guide

1. Inspect agent metadata: id, name, registerIP, dateAdd, lastKeepAlive, os.
   (API: GET /agents?search=<name>)
2. Determine whether a current system matches the registration:
   - Check candidate host for /var/ossec/etc/client.keys.
   - For containerized services (e.g. Greenbone on VM 103), agents are NOT
     installed in containers - container hostname registrations are phantom.
3. Recommend disposition with evidence.
4. Apply only after operator approval.

## Removal procedure (manager CLI)

```bash
docker exec multi-node-wazuh.master-1 bash -c "printf 'r\n<AGENT_ID>\ny\n' | /var/ossec/bin/manage_agents"
```

Then verify:

```bash
docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -l
# or API: GET /agents/summary/status  -> 0 never_connected
```

## API-only path (requires older_than 7d)

```bash
curl -sk -X DELETE -H "Authorization: Bearer $TOKEN" \
  "https://127.0.0.1:55000/agents?agents_list=<ID>&status=never_connected&older_than=7d"
```

## Documentation

- Always write the disposition report (reason + evidence) under ops/reports/.
- Update endpoint-count reporting rules (phase12-endpoint-counts-after-disposition.md).

## No secrets

No secret values printed.
