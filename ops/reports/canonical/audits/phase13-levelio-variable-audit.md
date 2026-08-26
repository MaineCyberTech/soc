# Phase 13 Level.io Variable Model Audit

Date: 2026-08-16

## Symptom (user report)

Level.io endpoint deployment scripts appear not to use variables even when
variables are set.

## Root cause (confirmed by live tests)

### Finding 1 - Unresolved placeholders are used as literal values (CRITICAL)

If Level.io renders `{{VAR}}` into the script environment but the variable is
unset/empty, the script substitutes the literal placeholder:

```text
WAZUH_MANAGER="{{WAZUH_MANAGER}}"  ->  manager used: {{WAZUH_MANAGER}}
```

Result: agent enrolls to a nonexistent manager address with NO error. This is
the likely production failure: variables are "set" in Level but never rendered
into the script, so the literal placeholder (or default) is used.

### Finding 2 - Env-only reads, no CLI argument support

All install/verify scripts read variables ONLY via `${VAR:-default}` env
substitution. No getopts/args parsing:

```text
script sees $1 = NOTHING   (CLI args silently ignored)
```

If Level.io passes values as script arguments or rendered arguments, they are
dropped.

### Finding 3 - Level.io variable types mismatched

Per Level.io model:
- **Automation variables**: can be created in the automation's Variables tab
  or from action output; passed BETWEEN automation actions.
- **Script variables**: OUTPUT capture slots (store script output), NOT inputs.
- **Inputs to scripts**: must be rendered from system variables/custom fields
  into args or env by the Run Script action.

The stack docs described variables as "script config" inputs, implying Level
script variables would inject values. They do not - the docs/scripts never
established HOW values get from Level into the script (env vs arg), and no
wrapper example existed.

### Finding 4 - Silent defaults hide missing values

WAZUH_MANAGER defaults to 142.105.190.25, WAZUH_AGENT_GROUP to "default".
If Level fails to pass values, the script runs with defaults and reports
"OK" - masking the failure. Only WAZUH_REG_PASSWORD fails fast.

## Variable consumption map (current scripts)

| Variable | Required | Read how | Fail-fast? | Risk |
|---|---|---|---|---|
| WAZUH_MANAGER | yes | env only | no (default) | silent wrong manager |
| WAZUH_REG_PASSWORD | yes | env only | yes | - |
| WAZUH_AGENT_GROUP | no | env only (MCT_AGENT_GROUP alias) | no (default) | wrong group |
| WAZUH_AGENT_NAME | no | env only | no (hostname) | - |
| WAZUH_VERSION | no | env only | no (default) | - |
| INSTALL_VELOCIRAPTOR | no | env only | no (default no) | - |
| VELO_CONFIG_B64/URL | conditional | env only | no (WARN skip) | silent no-velo |
| INSTALL_SYSMON | Windows | env only | no (default yes) | - |
| MCT_AGENT_GROUP | no | env only (alias) | no | - |

## Fix direction (P13.06)

1. Shared lib (lib/mct-env.sh): mct_get_var, mct_require_var, mct_redact,
   unresolved-placeholder detection (`{{...}}` -> treat as unset).
2. Scripts: CLI flags > env > rendered placeholder > default; fail-fast for
   required vars; --dry-run; --print-config-redacted.
3. Windows PS1: param block already env-fallback-capable; add placeholder
   detection + required checks.
4. Docs: correct variable model + wrapper examples (P13.08).

## No secrets

No secret values printed.
