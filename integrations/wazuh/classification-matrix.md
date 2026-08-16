# Alert Classification Matrix (Class A/B/C/D)

Route map: Wazuh rule/monitor -> class -> action. Applies to OpenSearch alerting
monitors, Shuffle workflows, and IRIS routing. Based on the stack taxonomy.

## Class definitions

| Class | Timeframe | Action | IRIS handling |
|---|---|---|---|
| A | Immediate (<10 min) | IRIS case + notify | case severity 4-5, immediate |
| B | Same day | IRIS alert + queue | case severity 3, same-day triage |
| C | Daily digest | digest only | reviewed daily, no case unless escalated |
| D | Archive | none | stored, searchable |

## Rule routing matrix

| source | rule/monitor | class | notes |
|---|---|---|---|
| OpenCanary | 121000-121012 hit | A | any canary touch = suspicious |
| MISP IOC | 121100+ match (confidence high) | A | action:block IOCs |
| MISP IOC | confidence medium | B | alert only |
| Flow | unknown exporter | A | new exporter = possible spoofing |
| Flow | lateral movement (flow rules) | A | |
| Flow | unusual port | B | |
| Flow | high outbound transfer | B | |
| Flow | generic records | D | archive only |
| Greenbone | critical vuln (internet facing) | A | webhook A -> Shuffle -> IRIS |
| Greenbone | non-critical vuln | C | monthly review |
| Wazuh | SSH brute force + AR fired | A | active response already triggered |
| Wazuh | auth failures (5710) | B | |
| Wazuh | auditd exec/login (80710 split) | B | |
| Wazuh | auditd routine | D | |
| Security Onion | suricata exploit/C2 | A | via agent 008 -> Wazuh |
| Security Onion | policy/misc | C | |
| mct-portal | app error/warn | C | escalate on repeat pattern |
| mct-portal | Caddy ACME / Sentry init | D | known benign |
| UniFi | WAN drop flood (1205xx flood) | B | |
| UniFi | routine drops/roaming/churn | C | |
| UniFi | unknown device MAC | C | add to known-devices after review |
| Velociraptor | manual hunt evidence | B | per case |
| Wazuh | agent offline/tamper | B | check daily |

## Escalation path (Shuffle degraded mode)

If Shuffle variable substitution fails: alert must still reach IRIS with static
title + raw payload (see integrations/shuffle/workflow-fallback-pattern.md).
Manual escalation: analyst creates IRIS case from the raw payload.

## Change policy

- Class changes are config-only (monitor/workflow level) - preferred over rule level changes.
- Rule level changes require backup + wazuh-logtest + analysisd restart on both nodes.
