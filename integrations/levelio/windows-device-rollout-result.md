# Windows Device Rollout Result

Date: 2026-08-12
Status: BLOCKED - no device

## When a Windows endpoint is available

1. level.io group windows-clients (upload windows-sysmon-agent-group.xml config)
2. Run install-wazuh-windows.ps1 (variables: WAZUH_MANAGER=142.105.190.25, WAZUH_REG_PASSWORD encrypted, INSTALL_SYSMON=yes)
3. Run verify-endpoint-windows.ps1 (as admin)
4. Confirm: WazuhSvc Running, Sysmon64 Running, events flowing
5. Confirm in Wazuh: agent Active, sysmon events in archive
