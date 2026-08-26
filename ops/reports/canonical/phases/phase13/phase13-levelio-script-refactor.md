# Phase 13 Level.io Script Refactor Report

Date: 2026-08-16

## Status: REFACTOR COMPLETE + TESTED

## Files changed

| File | Change |
|---|---|
| scripts/endpoint-deploy/lib/mct-env.sh | NEW shared lib: mct_get_var, mct_require_var, mct_is_unset, mct_redact, mct_print_config, mct_is_yes. Detects unresolved {{placeholders}}. |
| scripts/endpoint-deploy/install-wazuh-linux.sh | CLI flags (--manager/--reg-password/--group/--agent-name/--velo-config-*/--osquery/--dry-run/--print-config-redacted); fail-fast; placeholder detection; redacted diagnostics |
| scripts/endpoint-deploy/install-wazuh-macos.sh | Same refactor as Linux |
| scripts/endpoint-deploy/install-wazuh-windows.ps1 | Placeholder detection (Test-MctValue); fail-fast WAZUH_REG_PASSWORD; -DryRun/-PrintConfigRedacted switches |
| scripts/endpoint-deploy/README-levelio-variables.md | NEW usage doc |

## Behavior verified (exit codes)

| Test | Result |
|---|---|
| Env vars + --dry-run | config printed (secrets redacted), exit 0 |
| CLI flags override env | --manager wins over WAZUH_MANAGER env |
| Unresolved {{placeholder}} for required | ERROR + exit 2 |
| Missing required password | ERROR + exit 2 |
| Unknown arg | ERROR + exit 2 |
| --print-config-redacted | prints without changes |

## Root cause fixed

Level.io rendered `{{VAR}}` literals into script env when variables were unset;
scripts used them as real values (silent broken enrollment). Now `{{...}}` =
missing = fail-fast for required vars. Script variables (output slots) are no
longer conflated with inputs in docs.

## Not changed

- prepare-velociraptor-client.sh (host-side tool, no Level inputs - documented).
- verify scripts (no inputs needed; run post-install).

## No secrets

No secret values printed.
