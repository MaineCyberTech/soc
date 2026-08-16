# Windows Sysmon + Velociraptor Pilot

Scope: ONE Windows 11 endpoint. No broad rollout.

## Stack

```text
Windows 11 VM
├── Wazuh agent (group windows-sysmon-pilot)
├── Sysmon (sysmon-mct.xml)
└── Velociraptor client (post-port-fix enrollment)
```

## Checklist

- [ ] 1. Provision Windows 11 VM (PVE - currently BLOCKED: PVE API 401)
- [ ] 2. Install Wazuh agent; group windows-sysmon-pilot (config: windows-sysmon-agent-group.xml)
- [ ] 3. Deploy Sysmon: Sysmon64.exe -accepteula -i sysmon-mct.xml
- [ ] 4. Verify: sc query Sysmon64; Get-WinEvent Sysmon/Operational -MaxEvents 5
- [ ] 5. Collection validation (events 1/3/22) per test-event-checklist.md
- [ ] 6. Confirm events in wazuh-archives (validation queries)
- [ ] 7. 2-week tune-in at log-only levels
- [ ] 8. Velociraptor client enroll (requires frontend port fix - see test-client-enrollment.md)

## Rollback

1. Sysmon64.exe -u
2. Move agent to default group
3. Remove sysmon rules (backup first), restart analysisd both nodes
4. Verify ingest continues

## Status

NOT DEPLOYED - no Windows endpoint available; PVE API 401 blocks VM provisioning.
All configs/checklists ready (sysmon agent group xml, validation queries, dashboard backlog).
