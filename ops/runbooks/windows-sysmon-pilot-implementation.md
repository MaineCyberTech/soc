# Windows Sysmon Pilot Implementation

Scope: ONE Windows 11 test endpoint. No broad rollout.

## Pilot stack

```text
Windows 11 VM
├── Wazuh agent (group: windows-sysmon-pilot)
├── Sysmon (sysmon-mct.xml)
└── Velociraptor client (optional phase B)
```

## Implementation checklist

- [ ] 1. Provision Windows 11 VM (PVE or test hardware); document IP in asset inventory.
- [ ] 2. Install Wazuh agent; enroll to master; assign agent group `windows-sysmon-pilot` (config in integrations/sysmon/windows-agent-group-config-phase4.xml).
- [ ] 3. Deploy Sysmon (elevated):
      `Sysmon64.exe -accepteula -i sysmon-mct.xml`
- [ ] 4. Verify: `sc query Sysmon64`; `Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational -MaxEvents 5`
- [ ] 5. Collection validation (collection-only mode first - no rules enabled):
      run integrations/sysmon/test-event-checklist.md events 1/3/22
- [ ] 6. Confirm events in Wazuh archives (query below).
- [ ] 7. 2-week tune-in at log-only levels (rules 101001-101031 in sysmon-rule-plan.md).
- [ ] 8. Record results in ops/reports/sysmon-pilot-results.md.

## Validation queries (Wazuh host)

```bash
# Event 1 process creation on pilot
curl -sk -u admin:$WAZUH_ADMIN_PASSWORD -H 'Content-Type: application/json' \
  -d '{"size":0,"query":{"bool":{"filter":[{"term":{"data.win.system.eventID":1}},{"term":{"agent.name":"<pilot>"}}]}},"aggs":{"by_image":{"terms":{"field":"data.win.eventdata.image.keyword","size":10}}}}' \
  "https://127.0.0.1:9200/wazuh-alerts-*/_search"

# Event 22 DNS
curl -sk -u admin:$WAZUH_ADMIN_PASSWORD -H 'Content-Type: application/json' \
  -d '{"size":0,"query":{"bool":{"filter":[{"term":{"data.win.system.eventID":22}},{"term":{"agent.name":"<pilot>"}}]}},"aggs":{"by_query":{"terms":{"field":"data.win.eventdata.queryName.keyword","size":10}}}}' \
  "https://127.0.0.1:9200/wazuh-alerts-*/_search"

# Archives reachability (no rules enabled yet = archive only)
curl -sk -u admin:$WAZUH_ADMIN_PASSWORD -H 'Content-Type: application/json' \
  -d '{"size":1,"query":{"term":{"agent.name":"<pilot>"}},"sort":[{"timestamp":"desc"}]}' \
  "https://127.0.0.1:9200/wazuh-archives-*/_search"
```

## Rollback

1. Uninstall Sysmon: `Sysmon64.exe -u`
2. Move agent back to default group (Wazuh UI/agent_control).
3. Remove Sysmon rules from local_rules.xml (backup first); restart analysisd both nodes.
4. Remove dashboard references.
5. Verify Wazuh ingest continues (health-check.sh).

## Status: NOT DEPLOYED (no Windows endpoint provisioned in this phase)

Deliverables prepared: agent group config, validation queries, dashboard backlog,
pilot results template. Deployment requires a Windows VM - operator action.
