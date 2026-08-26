# Phase 13 Client Linux Agent Deployment

Date: 2026-08-16
Status: BLOCKED - no client, no signed authorization

## Preconditions

| Item | Status |
|---|---|
| Signed authorization | NOT PRESENT |
| Approved endpoint list | NOT PRESENT |
| Level.io variable-driven scripts | READY (P13.06 refactor) |
| Simulation harness | PASS (P13.07) |

## Deployment procedure (ready, not executed)

1. Verify authorization + endpoint list.
2. Level.io: render WAZUH_MANAGER/WAZUH_REG_PASSWORD/WAZUH_AGENT_GROUP into
   script args or env (phase13-variable-driven-rollout.md).
3. Run install-wazuh-linux.sh --dry-run on one device -> confirm config.
4. Run install live -> verify-endpoint-linux-macos.sh.
5. Confirm Wazuh agent Active + group (agent_control).
6. Confirm Velociraptor if included.
7. Rollback: uninstall-endpoint-linux-macos.sh.

## Result

NOT performed - blocked by missing client/authorization.

## No secrets

No secret values printed.
