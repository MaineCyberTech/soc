# Phase 10 First Client Rollout Result (Level.io)

Date: 2026-08-15

## Status: Internal rehearsal PASS; external rollout pending client

| Item | Status |
|---|---|
| Level.io group pattern | client-<slug> defined |
| Linux installer | READY + rehearsal verified |
| Internal pilot (VM 204 / agent 011) | Active, verify PASS |
| External client rollout | PENDING (no client engaged) |
| Velociraptor client prep | VERIFIED (Phase 9) |

## Rehearsal evidence

- verify-endpoint-linux-macos.sh on VM 204: PASS 4/4.
- Agent 011 enrolled via public IP + registration password (Phase 8 pattern).
- linux-clients group confirmed in Wazuh.

## When client engaged

1. Create client-<slug> group in level.io + Wazuh.
2. Deploy via level.io with encrypted WAZUH_REG_PASSWORD.
3. Verify + confirm Active.
4. Record endpoint inventory in phase10-first-client-endpoint-inventory.md.

## No secrets

No secret values printed.
