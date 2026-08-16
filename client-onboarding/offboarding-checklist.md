# Offboarding Checklist

Clean removal of monitoring for a departing client or endpoint.

## Client offboarding

- [ ] Notify MCT SOC (effective date)
- [ ] Stop alert routing to client (disable notifications for client group)
- [ ] Remove agents from all client endpoints (uninstall or deactivate)
- [ ] Remove client canaries/tokens (destroy artifacts; revoke tokens)
- [ ] Remove client targets from vulnerability scan schedules
- [ ] Export final scorecard/report package for client records
- [ ] Archive client data per retention agreement (do not delete prematurely)
- [ ] Remove client from escalation matrix + reporting lists
- [ ] Revoke any client-specific access (portals, tunnels)
- [ ] Document offboarding in ops/reports

## Single endpoint offboarding

1. Verify endpoint is the correct one (hostname/IP match inventory).
2. Confirm no active IRIS case depends on it.
3. Uninstall agent:
   - Linux: `sudo systemctl disable --now wazuh-agent && sudo dpkg -r wazuh-agent`
   - Windows: Programs and Features -> Wazuh agent -> uninstall
4. Delete/remove agent from Wazuh (agent_control -r or UI) AFTER verification.
5. Remove Velociraptor client (if enrolled).
6. Remove Sysmon (if installed): `Sysmon64.exe -u`.
7. Update asset inventory.

## Data handling

- [ ] Wazuh alerts for the departed endpoint: keep per retention policy (do not delete indices).
- [ ] IRIS cases: retained (evidence preservation).
- [ ] Backups: retained per retention.

## Final checks

- [ ] No alerts still routing to offboarded client.
- [ ] No canary/token alerts expected (artifacts destroyed).
- [ ] Inventory updated.
- [ ] Reporting lists updated.
