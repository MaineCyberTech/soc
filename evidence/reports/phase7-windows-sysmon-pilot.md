# Phase 7 Windows Sysmon Pilot

Date: 2026-08-12
Status: **BLOCKED - no Windows endpoint available**

## Blocker

- No Windows 11 device/VM (PVE API 401 blocks provisioning).
- Existing agents: docker-host, mct-portal-dev, securityonion, ospd-openvas (all Linux).

## Ready artifacts

- install-wazuh-windows.ps1 (agent + Sysmon + optional Velociraptor)
- sysmon-mct.xml (conservative config, detection-backlog aligned)
- verify-endpoint-windows.ps1 (service, events, enrollment checks)
- windows-sysmon-agent-group.xml (agent group config)
- Windows agent group plan (integrations/sysmon/windows-agent-group-plan.md)

## Next action

Operator provides Windows 11 device (or unblocks PVE); run installer -> verify
-> confirm Sysmon events in Wazuh archive.
