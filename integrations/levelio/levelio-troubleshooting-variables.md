# Troubleshooting Level.io Variables

## Symptom

Variables are set in Level but scripts behave as if defaults/missing values are used.

## Checks

1. Confirm whether the value is an automation variable, system variable, or custom field.
2. Confirm whether it is rendered into the Run Script action.
3. Confirm whether the script expects environment variables or CLI arguments.
4. Confirm unresolved placeholders like `{{WAZUH_MANAGER}}` are not reaching the shell.
5. Run local simulation harness in dry-run mode.

## Fix pattern

Wrap the install command so Level-rendered values become environment variables or CLI arguments consumed by the script.
