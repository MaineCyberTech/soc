# Phase 14 Known-Good Windows Rollout (agent 013)

Date: 2026-08-16
Status: RECORDED - production-validated path

## Steps (validated with client 013)

1. Level.io automation renders WAZUH_MANAGER/WAZUH_REG_PASSWORD/WAZUH_AGENT_GROUP
   into install-wazuh-windows.ps1 args or env (variable-driven, P13 model).
2. Script fails fast if any required value missing/unresolved (exit 2).
3. Agent enrolls -> group windows-clients (verified: agent 013 group correct).
4. VERIFY NODE: agent may connect to worker01 - group config + suppressions
   must exist on ALL nodes (master + worker).
5. Sysmon channel: added to windows-clients shared agent.conf - collection
   verified (175 events/24h, EID 1+7).
6. SCA: CIS Windows 11 benchmark summaries flow (classified informational).
7. FP suppressions: custom_rules/suppressions.xml on every node (121105/121106).

## Gotchas recorded

- Local_rules.xml loads before the ruleset -> if_sid children/overwrites there
  don't work. Use etc/custom_rules (loaded after ruleset/rules) on every node.
- Agent node assignment varies (manager <-> worker01) - check agent_control -i.
- Sysmon is installed by the script but channel collection needs the group
  agent.conf localfile.

## No secrets
