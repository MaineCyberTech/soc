# Level.io Variable Name Map

Date: 2026-08-16 (Phase 13 - canonical names)

## Canonical variable names (use these everywhere)

```text
WAZUH_MANAGER         # manager address (required)
WAZUH_REG_PASSWORD    # enrollment password (required, secret)
WAZUH_AGENT_GROUP     # agent group (required)
WAZUH_AGENT_NAME      # agent name (optional, default hostname)
WAZUH_VERSION         # agent version (optional, default 4.14.7)
INSTALL_VELOCIRAPTOR  # "yes"/"no" (optional)
VELO_CONFIG_B64       # base64 client config (secret, conditional)
VELO_CONFIG_URL       # URL to client config (alternative to B64)
INSTALL_SYSMON        # "yes"/"no" (Windows only)
INSTALL_OSQUERY       # "yes"/"no" (Linux only)
SYSMON_CONFIG_URL     # Sysmon config URL (Windows, optional)
MCT_AGENT_GROUP       # LEGACY alias for WAZUH_AGENT_GROUP (accepted)
CLIENT_SLUG           # client identifier (future - reporting)
MCT_DEPLOYMENT_MODE   # "live"/"dry-run" (optional, defaults live)
```

## CLI flag equivalents (P13.06)

```text
--manager <addr>          -> WAZUH_MANAGER
--reg-password <pw>       -> WAZUH_REG_PASSWORD
--group <name>            -> WAZUH_AGENT_GROUP
--agent-name <name>       -> WAZUH_AGENT_NAME
--velo-config-b64 <b64>   -> VELO_CONFIG_B64
--velo-config-url <url>   -> VELO_CONFIG_URL
--sysmon <yes|no>         -> INSTALL_SYSMON
--osquery <yes|no>        -> INSTALL_OSQUERY
--dry-run                 -> MCT_DEPLOYMENT_MODE=dry-run
--print-config-redacted   -> safe diagnostics
```

## Mapping rules

- CLI flag wins over env var wins over default.
- Legacy MCT_AGENT_GROUP accepted as alias for WAZUH_AGENT_GROUP (back-compat).
- Unresolved `{{VAR}}` placeholders are treated as missing (fail-fast if required).

## No secrets

No secret values printed.
