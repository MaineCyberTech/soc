# Endpoint Count Reporting

## Billing source

- Wazuh agent count per group = billed endpoint count.
- Query: agent_control -l (or Wazuh API /agents) grouped by group.

## Monthly snapshot

```bash
docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -l \
  | grep -E 'Active|Disconnected' | wc -l
```

- Record in monthly scorecard (endpoint coverage section).
- Audit quarterly: expected vs actual per client.

## Integrity

- Only Active agents count toward billing (disconnected > 30d excluded).
- Report per client group, not totals.
