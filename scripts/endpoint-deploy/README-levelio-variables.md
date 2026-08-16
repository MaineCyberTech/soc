# Level.io Variables - Endpoint Scripts (README)

Date: 2026-08-16 (Phase 13 refactor)

## How inputs reach the scripts

Priority: **CLI flag > environment variable > rendered placeholder > safe default**.

Level.io script variables are OUTPUT slots - they do NOT feed inputs into
scripts. To pass values:

1. **Env**: `WAZUH_MANAGER=... WAZUH_REG_PASSWORD=... bash install-wazuh-linux.sh`
2. **Args**: `bash install-wazuh-linux.sh --manager X --reg-password Y --group Z`
3. **Level automation**: render automation variables / custom fields into the
   Run Script action args or env.

## Required variables (fail-fast - exit 2 if missing/unresolved)

| Variable | Flag | Notes |
|---|---|---|
| WAZUH_MANAGER | --manager | default 142.105.190.25 (LAN overrides for on-site) |
| WAZUH_REG_PASSWORD | --reg-password | SECRET - encrypted in Level |
| WAZUH_AGENT_GROUP | --group | default "default" |

## Optional

| Variable | Flag | Default |
|---|---|---|
| WAZUH_AGENT_NAME | --agent-name | hostname |
| WAZUH_VERSION | - | 4.14.7 |
| INSTALL_VELOCIRAPTOR | - | no |
| VELO_CONFIG_B64 | --velo-config-b64 | - (secret) |
| VELO_CONFIG_URL | --velo-config-url | - |
| INSTALL_SYSMON | - | yes (Windows) |
| INSTALL_OSQUERY | --osquery | no (Linux) |

## Unresolved placeholders

Level renders `{{VAR}}` literally when the variable is unset. The scripts
detect `{{...}}` values and treat them as MISSING (fail-fast for required).
This was the root cause of "variables set but not used".

## Diagnostics

- `--dry-run`: prints resolved config (secrets redacted) and exits 0 without changes.
- `--print-config-redacted`: prints config without changing anything.
- Secrets always show as `<set:redacted>`.

## Verification

```bash
bash scripts/endpoint-deploy/test/simulate-levelio-linux.sh
bash scripts/ci/run-levelio-variable-tests.sh   # full harness
```

## No secrets

No secret values printed.
