# Level.io Endpoint Rollout Runbook

## Prereqs

- Endpoint kit audited (PASS 2026-08-12).
- Agent groups created in Wazuh.
- Encrypted variables set in level.io.
- One pilot device identified per OS.

## Steps

1. Create level.io scripts (paste from scripts/endpoint-deploy/).
2. Set variables per integrations/levelio/endpoint-kit-variable-map.md.
3. Create groups per device-group-rollout-plan.md.
4. Run pilot install on 1 device -> verify -> confirm in Wazuh.
5. Expand group-by-group after pilot PASS.

## Verification

- verify-endpoint-*.sh/.ps1 exit 0.
- Wazuh: agent Active, group correct, syscollector data visible.
- Sysmon (Windows): events in archive (validation queries).

## Rollback

- integrations/levelio/uninstall-rollback-workflow.md.

## Status

Plan ready; pilots pending targets (Linux local target available).
