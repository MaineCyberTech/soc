# Endpoint Kit Variable Map (level.io)

## Required (set per group)

| Variable | Example | Scripts | Secret? |
|---|---|---|---|
| WAZUH_MANAGER | 142.105.190.25 (public) / 192.168.222.149 (LAN) | all installers | no |
| WAZUH_REG_PASSWORD | <from host creds.env WAZUH_REGISTRATION_PASSWORD> | all installers | YES - encrypted |
| WAZUH_AGENT_GROUP | linux-clients / mac-clients / windows-clients / default | all installers | no |

## Optional

| Variable | Default | Scripts |
|---|---|---|
| WAZUH_VERSION | 4.14.7 | all |
| INSTALL_SYSMON | yes | windows |
| INSTALL_OSQUERY | no | linux |
| INSTALL_VELOCIRAPTOR | no | all |
| VELO_CONFIG_B64 | - | all (encrypted) |
| VELO_CONFIG_URL | - | all |
| SYSMON_CONFIG_URL | - | windows |

## Value sources

- WAZUH_REG_PASSWORD: `grep WAZUH_REGISTRATION_PASSWORD /opt/wazuh-docker/multi-node/ops/creds.env` (host, 0600)
- VELO_CONFIG_B64: `base64 -w0 <(prepare-velociraptor-client.sh)` output
- Never commit values to scripts or git.
