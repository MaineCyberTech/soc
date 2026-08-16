# Windows Pilot Rollout Result (Phase 8)

Date: 2026-08-15
Status: BLOCKED (no Windows device)

## When VM 201 available

1. level.io windows-clients group (upload windows-sysmon-agent-group.xml).
2. install-wazuh-windows.ps1 (WAZUH_MANAGER=142.105.190.25, WAZUH_REG_PASSWORD encrypted, INSTALL_SYSMON=yes).
3. verify-endpoint-windows.ps1 (admin) -> PASS.
4. Confirm Sysmon events in Wazuh archive.
