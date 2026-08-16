# Phase 12 Client Agent Deployment Report

Date: 2026-08-16
Status: BLOCKED - no client engaged, no signed authorization, no endpoints

## Verification of preconditions

| Precondition | Status |
|---|---|
| Signed authorization | NOT PRESENT (no client) |
| Approved endpoint list | NOT PRESENT (no client) |
| Level.io group + variables | Configurable (naming standard + variable map exist) |

## Deployment procedure (ready, not executed)

1. Verify authorization + endpoint list.
2. Confirm Level.io group/variables (integrations/levelio/).
3. Run install-wazuh-linux.sh on each approved endpoint.
4. Run verify-endpoint-linux-macos.sh.
5. Confirm Wazuh agent Active via agent_control.
6. Confirm Velociraptor if included (client enrollment).
7. Record rollout result + rollback steps.

## Rollback steps (documented)

- uninstall-endpoint-linux-macos.sh (removes Wazuh agent + optional Velociraptor).
- uninstall-endpoint-windows.ps1 for Windows (external Windows not offered yet).
- Wazuh manager: agent_control -R <id> or delete agent on failure.
- Full procedure: integrations/levelio/uninstall-rollback-workflow.md.

## Result

Deployment NOT performed - blocked by missing authorization/client.

## No secrets

No secret values printed.
