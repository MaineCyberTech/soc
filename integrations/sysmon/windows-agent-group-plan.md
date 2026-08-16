# Windows Agent Group Plan (windows-sysmon-pilot)

## Group definition

- Wazuh agent group: `windows-sysmon-pilot`
- Scope: 1 Windows 11 test endpoint
- Files in group (from integrations/sysmon):
  - `wazuh-agent-sysmon-collection.xml` (eventlog module for Sysmon)
  - `sysmon-mct.xml` (Sysmon config - optional via agent rollout)
  - `agent.conf` overrides: enable syscollector + eventlog

## agent.conf (draft)

```xml
<agent_config>
  <localfile>
    <location>Microsoft-Windows-Sysmon/Operational</location>
    <log_format>eventchannel</log_format>
  </localfile>
  <localfile>
    <location>System</location>
    <log_format>eventchannel</log_format>
  </localfile>
  <localfile>
    <location>Security</location>
    <log_format>eventchannel</log_format>
  </localfile>
  <syscollector>
    <interval>1h</interval>
    <processes>yes</processes>
    <ports>yes</ports>
    <packages>yes</packages>
  </syscollector>
</agent_config>
```

## Rollout

1. Create group in Wazuh UI (Agents -> Groups -> Add group `windows-sysmon-pilot`).
2. Upload `agent.conf` above.
3. Upload `wazuh-agent-sysmon-collection.xml` as `ossec.conf` (or inline into agent.conf).
4. Set endpoint agent group: `wazuh-agent-control -g` or via UI agent settings.
5. Verify agent config received (`/var/ossec/etc/shared` sync on endpoint).

## Group sync note

- Agent group updates propagate within minutes; verify with `agent_upgrade`/config sync logs.
- Do NOT include secrets in group files.

## Phasing

- Phase A: 1 test endpoint, collection only (2 weeks).
- Phase B (with approval): 2-3 admin workstations.
- Phase C (with approval): client endpoints per client onboarding.

## Rollback

- Move endpoint back to `default` group; remove group files after all endpoints moved.
- Deleting a group with enrolled agents resets them to default - safe, no data loss.
