# Phase 34 Canary End-to-End Proof

Date: 2026-08-25

## Status: DEFERRED (agent 016 forwarding gap)

## Path (designed)
1. Synthetic pcap triggers SID 2027967 on sensor
2. Suricata fires alert -> eve-alert.json (on-demand)
3. Agent 016 monitors eve-alert.json -> forwards to Wazuh
4. Wazuh decodes (proven via logtest level 3)
5. Test group receives alert
6. Guardrail dedup + daily limit enforced

## Blocker
- Agent 016 ossec.conf: only `<location>/var/log/suricata/eve-alert.json</location>`
- eve-alert.json is created on first alert; agent 016 will pick it up
- BUT: the canary E2E requires a real alert to fire first
- Offline proof: sid 2027967 fires on crafted pcap (proven P32)
- Live proof: requires synthetic trigger on SPAN (non-invasive)

## Remediation needed
- Add `<localfile>` for eve.json to agent 016 ossec.conf (for stats/health monitoring)
- OR: rely on eve-alert.json (created on-demand) for canary alerts only

## No secrets
