# Level.io Rollout

## Updated flow (from pilot learnings)

1. Create Wazuh groups (client-<slug> + OS groups).
2. Set level.io vars (WAZUH_MANAGER public IP, WAZUH_REG_PASSWORD encrypted, group).
3. Pilot ONE device -> verify (root) -> confirm in Wazuh.
4. Rollout to group -> verify each -> alert on non-zero exit.
5. Monthly: endpoint count report for billing.

## Key requirements (learned)

- Registration password REQUIRED (enforced on master).
- Verify scripts: root (Linux/macOS), admin (Windows).
- Velociraptor config per-server (prepare-velociraptor-client.sh).
- Group naming per client-group-naming-standard.md.

## Rollback

- Uninstall scripts; remove agent from Wazuh; update inventory.
