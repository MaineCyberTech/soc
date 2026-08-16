# macOS Device Rollout Result

Date: 2026-08-12
Status: BLOCKED - no device

## When a Mac is available

1. level.io group mac-clients
2. Run install-wazuh-macos.sh (variables: WAZUH_MANAGER=142.105.190.25, WAZUH_REG_PASSWORD encrypted)
3. Run verify-endpoint-linux-macos.sh (as root)
4. Confirm Active in Wazuh
5. Record results here

## Platform notes

- Intel: x86_64 binary; Apple Silicon: arm64 binary (auto-detected).
- Requires sudo/root (installer -pkg).
- Velociraptor darwin binary auto-selected.
