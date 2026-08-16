# Windows 11 Pilot Install

## VM

- PVE VM 120 (win11-sysmon-pilot), 8 GiB / 4 cores / 80 GiB
- Windows 11 Pro, network: site LAN

## Install order

1. Wazuh agent (MSI) -> enroll -> group windows-sysmon-pilot
   (windows-sysmon-agent-group.xml config)
2. Sysmon: Sysmon64.exe -accepteula -i sysmon-mct.xml
3. Verify: sc query Sysmon64; Get-WinEvent Sysmon/Operational
4. Velociraptor client: velociraptor-v0.77.2-windows-amd64.exe service install
   --config client.config.yaml (port-8002 config)
5. Test events (event 1/3/22) -> validate in Wazuh archives + Velociraptor GUI

## Rollback

- Sysmon64.exe -u; remove agent group; velociraptor service remove;
  move agent to default group; verify ingest.

## Status

- NOT INSTALLED (no VM; PVE blocked).
