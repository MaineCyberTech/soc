# Agent Onboarding Checklist

Per client endpoint.

## Endpoint inventory

- [ ] Hostname, OS, IP recorded in client asset list
- [ ] Asset owner identified
- [ ] Business-critical? (affects alert priority)

## Wazuh agent install (Linux)

```bash
# enroll agent (ID auto-assigned; group per client)
curl -so wazuh-agent.deb https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.14.7-1_amd64.deb
sudo dpkg -i wazuh-agent.deb
sudo /var/ossec/bin/agent-auth -m <wazuh-master-ip> -A <client>-<host>
sudo systemctl enable --now wazuh-agent
```

## Wazuh agent install (Windows)

1. Download Wazuh Windows agent MSI.
2. Install with server address + client name:
   `msiexec /i wazuh-agent.msi WAZUH_MANAGER=<master-ip> WAZUH_REGISTRATION_SERVER=<master-ip> WAZUH_AGENT_GROUP=<client-group>`
3. Verify enrollment: Wazuh UI -> Agents -> active.

## Post-install verification

- [ ] Agent active in Wazuh (agent_control or UI)
- [ ] syscollector data visible (processes/ports/packages)
- [ ] FIM baseline running (file integrity)
- [ ] Test alert fires for a local event (e.g. failed sudo)
- [ ] Agent group set to client group

## Optional additions

- [ ] Velociraptor client (per rollout runbook)
- [ ] Sysmon (Windows - see sysmon pilot docs; only with approval)
- [ ] Canary (see canary-authorization.md)

## Notes

- Agents must be deployed per client authorization only.
- Never install agents on infrastructure without documented approval.
- Record deployment in client asset inventory.
