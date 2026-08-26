# Phase 34 Full Operational Alert Test Matrix

Date: 2026-08-25

| Alert | Trigger | Dedup | Escalation | Ack | Maintenance | Recovery | Payload | Owner | Runbook |
|---|---|---|---|---|---|---|---|---|---|
| sensor-service | systemctl stop | state-based | 15m | yes | 4h | auto | HEALTHY->FAILED | security | restart mct-suricata |
| eve-fresh | touch eve.json (age>600s) | state-based | 15m | yes | 4h | auto | HEALTHY->FAILED | security | check Suricata |
| agent016 | wazuh API offline | state-based | 15m | yes | 4h | auto | HEALTHY->FAILED | security | restart agent |
| drops | kernel_drops>0 | state-based | 15m | yes | 4h | auto | HEALTHY->FAILED | security | check NIC/SPAN |
| memcap | flow.memcap>0 | state-based | immediate | yes | 4h | auto | HEALTHY->FAILED | security | increase memcap |
| resource | MemoryCurrent>1.5GiB | state-based | 15m | yes | 4h | auto | HEALTHY->FAILED | security | investigate leak |
| ruleset-age | rules>7d old | state-based | 15m | yes | 4h | auto | HEALTHY->DEGRADED | security | suricata-update |
| config-drift | hash mismatch | state-based | immediate | yes | 4h | manual | HEALTHY->FAILED | security | reconcile config |
| wazuh-ingest | 0 events>30m | state-based | 15m | yes | 4h | auto | HEALTHY->FAILED | security | check agent |
| backup-fresh | config bundle>48h | state-based | 15m | yes | 4h | auto | HEALTHY->FAILED | ops | restore config |
| disk-wm | disk>=85% | state-based | 15m | yes | 4h | auto | HEALTHY->DEGRADED | ops | capacity runbook |
| tmp-health | space/inode>=70% | state-based | 15m | yes | 4h | auto | HEALTHY->DEGRADED | ops | safe cleanup |
| release-provenance | bundle missing | state-based | 15m | yes | 4h | manual | HEALTHY->FAILED | ops | rebuild release |

## No secrets
