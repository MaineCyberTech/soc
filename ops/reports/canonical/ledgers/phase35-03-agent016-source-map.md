# Phase 35 Agent 016 Collection Source Map

Date: 2026-08-25

## Canonical config
- Repo: /opt/mct-security-stack/integrations/suricata-minimal/
- OSSEC_CONF: /var/ossec/etc/ossec.conf on mct-soc-scan
- Backup: /var/ossec/etc/ossec.conf.bak-p34

## Effective localfile entries
| Location | Format | Purpose | Status |
|---|---|---|---|
| /var/log/suricata/eve.json | json | Stats + alerts (all EVE) | ACTIVE (19 events, 141KB) |
| /var/log/suricata/eve-alert.json | json | Alerts only (on-demand) | ACTIVE (0 events - no alerts) |

## Agent state
- Agent 016: active, keepalive fresh, version 4.14.7
- Logcollector: running, monitoring both files
- Queue: 5000, events_per_second: 500

## Wazuh destination
- Manager: Wazuh manager (4.x cluster)
- Events indexed: 0 (stats events don't match rules - expected)
- Alerts: will appear when eve-alert.json has entries

## Rollback
- Restore /var/ossec/etc/ossec.conf from .bak-p34
- Restart wazuh-agent

## No secrets
