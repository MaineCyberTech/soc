# Level.io Variable Model for MCT Endpoint Deployment

Date: 2026-08-16 (Phase 13 - corrected model)

## Operating principle

Do NOT rely on Level script variables as input fields for install scripts.
Script variables are OUTPUT capture slots. Pass install inputs by rendering
system variables / custom fields into the Run Script action as command-line
arguments or environment variables, or set them as automation variables
exported to the script environment.

## Level.io variable types (clarified)

| Type | Purpose | Use for script input? |
|---|---|---|
| Automation variables | Pass values between automation actions | YES - export to env or pass as args |
| System variables / custom fields | Per-device data (group, site, client) | YES - render into args/env |
| Script variables | Capture script OUTPUT into automation variables | NO - outputs, not inputs |

## Required install inputs

| Variable | Required | Secret | Purpose |
|---|---|---|---|
| WAZUH_MANAGER | yes | no | Wazuh manager/enrollment endpoint |
| WAZUH_REG_PASSWORD | yes | yes | Wazuh enrollment password |
| WAZUH_AGENT_GROUP | yes | no | Agent group (linux-clients/windows-clients/mac-clients) |
| INSTALL_VELOCIRAPTOR | no | no | Enable Velociraptor install |
| VELO_CONFIG_B64 | conditional | yes | Velociraptor client config (base64) |
| INSTALL_SYSMON | Windows | no | Enable Sysmon install |

## Script input priority (P13.06 refactor)

1. CLI flag (--manager, --reg-password, --group, ...)
2. Environment variable (WAZUH_MANAGER, ...)
3. Rendered Level placeholder (unresolved `{{VAR}}` detected as missing)
4. Safe default ONLY for non-sensitive optional values
5. Fail-fast (exit 2) for missing required values

## Failure behavior

- Required variable missing or unresolved -> clear error + exit 2.
- --dry-run prints resolved config (redacted) without installing.
- Never print secret values (password shown as <set:redacted>).

## No secrets

No secret values printed.
