# Windows Endpoint Onboarding Runbook

Purpose: onboard a Windows 11 endpoint into Wazuh (existing stack) and optionally Velociraptor + Sysmon.

## Order of operations

1. **Wazuh agent** (existing infrastructure, see `agent-rollout-windows-direct.md` in Wazuh ops):
   - Install agent, point to `1515` enrollment (or Cloudflare TCP route for remote endpoints per `agent-rollout-cloudflared-tcp.md`).
   - Assign agent group: `windows` (not `linux`) so Sysmon localfile blocks apply only to Windows agents.
2. **Sysmon**: install per `integrations/sysmon/sysmon-deployment-windows.md`; verify Event 1 in Wazuh within 1-2 days.
3. **Velociraptor**: enroll per `velociraptor-client-rollout-windows.md`.

## Agent group strategy (additive only)

- Keep existing groups untouched. Create `windows` group for Sysmon collection blocks:
  - `config/wazuh_cluster/etc/shared/windows/agent.conf` gets the `<localfile>` block from `integrations/sysmon/wazuh-agent-sysmon-collection.xml`.
- Do not modify the Linux agent group configuration.

## Post-onboarding checklist

- [ ] Agent connected, version current
- [ ] Agent in `windows` group
- [ ] Sysmon installed + collecting
- [ ] Test Event 1 visible in Wazuh
- [ ] Velociraptor client online (if enrolled)
- [ ] Asset registered in inventory (site, owner) for reporting

## Acceptance

- Additive config only — no change to Linux groups.
- No production Windows rollout without operator approval.
