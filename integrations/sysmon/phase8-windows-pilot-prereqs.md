# Phase 8 Windows Pilot Prereqs

## Checklist

- [ ] Windows 11 ISO + license
- [ ] Proxmox .222 access (VM 201)
- [ ] Wazuh agent group windows-clients created; sysmon collection config uploaded
- [ ] level.io vars: WAZUH_MANAGER=142.105.190.25, WAZUH_REG_PASSWORD (encrypted), INSTALL_SYSMON=yes
- [ ] Velociraptor client config (prepare-velociraptor-client.sh) + VelociraptorServer DNS
- [ ] sysmon-mct.xml (in endpoint kit)

## Validation after install

1. verify-endpoint-windows.ps1 -> PASS (WazuhSvc, Sysmon64, events)
2. Wazuh: agent Active, group correct
3. Sysmon Event 1 (process) visible in archive
4. Velociraptor GUI check-in

## Status

BLOCKED on Proxmox access (no VM).
