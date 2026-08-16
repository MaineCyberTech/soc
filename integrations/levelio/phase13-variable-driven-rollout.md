# Phase 13 Variable-Driven Rollout (Level.io)

Date: 2026-08-16 (Phase 13 - corrected model)

## Variable model (summary)

- **Inputs to scripts**: automation variables / system variables / custom
  fields rendered into args or env by the Run Script action.
- **Script variables**: OUTPUT slots only - capture script output.
- Unresolved `{{VAR}}` placeholders are treated as missing (fail-fast).
- Priority: CLI flag > env var > rendered placeholder > safe default.

Full model: integrations/levelio/levelio-variable-model.md
Name map: integrations/levelio/levelio-variable-name-map.md

## Setup in Level.io

1. Create automation variables (or use custom fields) for:
   - WAZUH_MANAGER (plaintext)
   - WAZUH_REG_PASSWORD (encrypted/secret)
   - WAZUH_AGENT_GROUP (plaintext)
2. In the Run Script action, render values into the script:
   - Args: `bash install-wazuh-linux.sh --manager {{WAZUH_MANAGER}} --reg-password {{WAZUH_REG_PASSWORD}} --group {{WAZUH_AGENT_GROUP}}`
   - Or env: prefix the command with `WAZUH_MANAGER={{WAZUH_MANAGER}} WAZUH_REG_PASSWORD={{WAZUH_REG_PASSWORD}} ...`
3. Run script with `--dry-run` first on one device; confirm config output.
4. Then run live + verify (install-verify-workflow.md).

## Rollout flow

1. Preflight: simulate (test/simulate-levelio-linux.sh) - all PASS expected.
2. Dry-run on first device: `--dry-run` prints resolved config (redacted).
3. Live install on device group.
4. Verify: scripts/endpoint-deploy/verify-endpoint-linux-macos.sh (PASS/FAIL).
5. Confirm in Wazuh: agent Active + correct group.
6. Record result: integrations/levelio/phase13-client-rollout-result.md (per client).

## Group naming + billing notes

- Group naming: integrations/levelio/client-group-naming-standard.md.
- Billing: integrations/levelio/endpoint-count-reporting.md - billable = active
  external-client agents; internal/lab excluded.

## No secrets

No secret values printed.
