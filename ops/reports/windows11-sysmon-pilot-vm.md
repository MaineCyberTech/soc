# Windows 11 Sysmon Pilot VM

Date: 2026-08-11
Status: **BLOCKED - no Windows endpoint; PVE API 401 (no VM provisioning)**

## Blocker

- PVE API 401 + no SSH key (same as canary VM) - cannot provision Windows 11 VM.
- No existing Windows endpoint in Wazuh agent list (agents: docker-host, mct-portal-dev, securityonion, ospd-openvas).

## Ready artifacts (Phase 4/5)

- windows-sysmon-velociraptor-pilot.md runbook (checklist + rollback)
- windows-sysmon-agent-group.xml (agent group config)
- sysmon-validation-queries.md (events 1/3/22)
- sysmon-dashboard-backlog-phase5.md
- Velociraptor windows-client-enrollment.md (post-port-fix)

## Unblock

- PVE access (pve-api-repair.md) -> qm create 120 win11-sysmon-pilot (manual-vm-provisioning-bypass.md)
- OR operator provides an existing Windows endpoint.

## Velociraptor status for pilot

- Server port rebind DONE (8002) - client enrollment path VALIDATED with Linux test client.
- Windows client enroll will use the same fixed config pattern (client-config-port-8002.md).
