# Phase 10 First Client Agent Deployment (Rehearsal)

Date: 2026-08-15
Status: EXTERNAL DEPLOYMENT BLOCKED (no client engaged) - INTERNAL REHEARSAL PASS

## Deployment path validated (internal pilot)

- Target: VM 204 mct-linux-client01 (.240) - the internal rehearsal "client".
- Verify script (verify-endpoint-linux-macos.sh): **PASS 4/4**
  - wazuh-agent process running
  - wazuh daemons running (5)
  - agent enrolled (client.keys)
  - ossec.conf manager address set (142.105.190.25)
- Agent 011: Active, keepalive fresh, Debian 13, linux-clients group.

## Deployment kit readiness

- install-wazuh-linux.sh: READY (public IP default, group via MCT_AGENT_GROUP,
  WAZUH_REG_PASSWORD required + encrypted).
- verify script: READY (exit codes).
- uninstall script: READY (idempotent).
- prepare-velociraptor-client.sh: VERIFIED (Phase 9 - 3 clients enrolled).

## Client deployment procedure (when engaged)

1. level.io group `client-<slug>` created.
2. Run: `install-wazuh-linux.sh` with WAZUH_MANAGER=142.105.190.25,
   MCT_AGENT_GROUP=client-<slug>, WAZUH_REG_PASSWORD (encrypted).
3. Verify: `verify-endpoint-linux-macos.sh` (root) -> PASS required.
4. Confirm Active in Wazuh dashboard (group filter).
5. Optional: Velociraptor client per prepare-velociraptor-client.sh.

## Rollback

- `uninstall-endpoint-linux-macos.sh` (root) - removes agent + config.

## Blocker

- No external client endpoints exist to deploy to - waiting on intake +
  signed authorization (phase10-first-client-launch-decision.md).

## No secrets

No secret values printed.
