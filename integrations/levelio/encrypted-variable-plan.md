# Level.io Encrypted Variable Plan

## Secrets to store encrypted (never plaintext)

| Variable | Source | Rotation |
|---|---|---|
| WAZUH_REG_PASSWORD | host creds.env WAZUH_REGISTRATION_PASSWORD | with registration password rotation |
| VELO_CONFIG_B64 | prepare-velociraptor-client.sh output | with client config rotation |

## Non-secret variables

WAZUH_MANAGER, WAZUH_AGENT_GROUP, WAZUH_VERSION, INSTALL_* - plaintext OK.

## level.io usage

- Script settings -> variables -> mark secret for the two above.
- Or use level.io Secrets/Keychain if available.
- Never paste values into script body or comments.

## Audit

- Quarterly: re-pull values from source, confirm level.io matches.
- On rotation: update level.io variable + retest one device.
