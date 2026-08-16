# Phase 14 Known-Good Linux Rollout

Date: 2026-08-16
Status: READY (validated by simulation + internal pilot 011)

## Steps

1. Level.io renders WAZUH_MANAGER/WAZUH_REG_PASSWORD/WAZUH_AGENT_GROUP into
   install-wazuh-linux.sh args or env.
2. Dry-run first: --dry-run prints resolved config (secrets redacted).
3. Install -> verify-endpoint-linux-macos.sh (PASS/FAIL per check).
4. Confirm agent Active + group in Wazuh.
5. Optional: Velociraptor via VELO_CONFIG_B64/URL.

## Validation status

- Simulation harness: 4/4 PASS (env, CLI, missing-required, unresolved).
- Internal pilot: agent 011 mct-linux-client01 Active (P10).
- No external Linux client deployed yet.

## No secrets
