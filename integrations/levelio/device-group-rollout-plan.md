# Level.io Device Group Rollout Plan

## Groups

| Group | Membership | Installer | Verify | Notes |
|---|---|---|---|---|
| linux-clients | Linux servers/workstations | install-wazuh-linux.sh | verify-endpoint-linux-macos.sh | osquery optional |
| mac-clients | macOS devices | install-wazuh-macos.sh | verify-endpoint-linux-macos.sh | Intel + ARM |
| windows-clients | Windows 10/11/Server | install-wazuh-windows.ps1 | verify-endpoint-windows.ps1 | Sysmon on |
| internal-mct | MCT-owned devices | per-OS installer | per-OS verify | Client Zero scope |
| client-pilot | First external client pilot | per-OS installer | per-OS verify | one device first |

## Rollout order (phased)

1. **Pilot**: 1 device per OS group -> install -> verify -> confirm Active in Wazuh.
2. **Internal scale**: internal-mct group (after pilot PASS).
3. **Client pilot**: client-pilot group (1 device) -> 30-day review.
4. **Broad**: only after client pilot acceptance.

## Prereqs per group

- Wazuh agent group exists (linux-clients etc.) - create in Wazuh UI first.
- Windows group has sysmon collection config uploaded (windows-sysmon-agent-group.xml).
- Velociraptor enabled only where VELO_CONFIG_B64 provided.

## Safety

- One-device pilot first; no broad rollout without approval.
- Sysmon only on windows-clients with pilot approval.
