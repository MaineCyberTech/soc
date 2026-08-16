# Phase 5 UniFi Routing Applied

Date: 2026-08-11

## Change

Added overrides in `local_rules.xml` (new group `ubiquiti,noise-suppressed,`)
for routine churn rules -> **level 1 (archive-only, Class D)**:

| rule | description | old level | new level |
|---|---|---|---|
| 120505 | station anomaly | 3 | 1 |
| 120506 | station event | 3 | 1 |
| 120509 | client connected | 4 | 1 |
| 120510 | client disconnected | 5 | 1 |
| 120512 | station tracker | 3 | 1 |
| 120517 | kernel station | 3 | 1 |
| 120520 | 802.11r roaming handoff | 3 | 1 |
| 120531 | client kicked by kernel | 3 | 1 |
| 120532 | client kicked (rssi) | 3 | 1 |

**UNCHANGED (security-relevant):**
- 120527 unknown device (level 4, Class B)
- 120521 WPA replay failure (level 6, B)
- 120524 WPA replay storm (level 7, B)
- 120501 WAN blocked drop (level 6 + MITRE T1046, B)
- 120518 link down (level 5, B)
- 120528 unknown DHCP lease (level 4, B)

## Procedure followed

1. Backup: `local_rules.xml.bak-unifi-20260811`
2. Override group appended (full rule bodies preserved with level change)
3. File synced to master + worker containers
4. analysisd restarted both nodes (PIDs changed: master 511, worker 506)
5. Rules loaded: 8508, no errors
6. Cluster green, 3 nodes
7. Live verification: churn rules = 1 alert since restart (07:32Z);
   security UniFi rules still alerting (1,766 in 1h)

## Class A protection

- OpenCanary 1210xx, MISP 1211xx, unknown exporter, lateral movement: untouched.
- WAN drop flood rule (1205xx flood) still active at B.

## Rollback

```bash
sudo cp /opt/wazuh-docker/multi-node/config/wazuh_cluster/etc/rules/local_rules.xml.bak-unifi-20260811 \
       /opt/wazuh-docker/multi-node/config/wazuh_cluster/etc/rules/local_rules.xml
docker cp <file> multi-node-wazuh.master-1:/var/ossec/etc/rules/local_rules.xml
docker cp <file> multi-node-wazuh.worker-1:/var/ossec/etc/rules/local_rules.xml
docker compose restart wazuh.master wazuh.worker
```
