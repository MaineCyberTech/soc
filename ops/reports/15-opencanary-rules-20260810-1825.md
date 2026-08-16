# OpenCanary Rules Deployment — 2026-08-10 (DONE)

## What was deployed

- 16 rules (121000-121099) appended to `config/wazuh_cluster/etc/rules/local_rules.xml`
- No custom decoder needed: canary events are JSON syslog, parsed by the built-in `json` decoder (verified in archives: fields `data.node_id`, `data.logtype`, `data.src_host`)
- Scanner suppression: rule 121099 (level 0) suppresses Greenbone scanner (192.168.222.154) hits — documented noise
- Bind mounts added to docker-compose.yml (master + worker): rules + decoders files → `/wazuh-config-mount/etc/...` so future edits auto-sync on container restart (additive, compose backed up)

## Issues found and fixed

1. `frequency="1"` is invalid for Wazuh rules (must be > 1) → removed attribute; analysisd had CRITICAL load error until fixed
2. **Unanchored `<field>` regex matching**: `<field name="logtype">8001</field>` matched logtype `18001` (substring!) — a printer/tcpbanner hit fired the RDP rule. All logtype fields now anchored: `^8001$` etc.
3. analysisd did not restart after `docker compose stop/start` — a full `docker compose restart` brought it back cleanly (Total rules enabled: 8503)

## Verified end-to-end

- Test: TCP connect to canary port 9100 (printer tcpbanner)
- Result: alert fired rule **121012 "OpenCanary: connection made"** (level 12, Class A), correct port 9100 mapping
- Cluster health: green, 3 nodes

## Access model (unchanged)

- Canary ports published: 21, 23, 3306, 1433, 9100, 8008 (intentional deception exposure, documented in ports.md)
- Alerts flow: canary → syslog UDP → master 514 → analysisd → wazuh-alerts-* (level 12 = Class A)
