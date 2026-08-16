# Security Onion Integration (SO -> Wazuh)

Updated: 2026-08-15 — SO role reversed: SO is a PACKET-INGESTION box that FEEDS
Wazuh. The previous Wazuh -> SO forwarding (syslog_output + syslog-ng sidecar)
was REMOVED. See ops/runbooks/phase9-change-control.md.

## Components

| Component | Role | Where |
|---|---|---|
| SO VM | NSM/IDS (Suricata + Zeek packet capture) | 192.168.222.116 |
| Monitor NIC | mirror/SPAN input -> Suricata/Zeek | ens19 (vmbr1, USB NIC enx3c18a0993f5a on PVE .187) |
| zeek-forward service | tails Zeek conn.log, tags lines `ZEEK {...}` -> /nsm/zeek/zeek-forward.log | SO VM (systemd, enabled) |
| Wazuh agent 008 | collects /nsm/zeek/zeek-forward.log + /nsm/suricata/eve.json | SO VM (ossec.conf localfiles) |
| Shuffle workflow | Wazuh high-severity -> IRIS route | wazuh-high-severity-to-iris |

## Architecture (current)

```
mirror/SPAN -> ens19 (SO) -> Suricata/Zeek (containers)
                                  |
Zeek conn.log -> zeek-forward (ZEEK tag) -> /nsm/zeek/zeek-forward.log
                                  |
Wazuh agent 008 (localfile syslog) -> wazuh.master -> indexer (decoder zeek-conn)
                                  |
Shuffle wazuh-high-severity-to-iris -> DFIR-IRIS
```

## Validation checks

```bash
# 1. SO reachable
ping -c1 192.168.222.116

# 2. Suricata capturing (via SO VM)
sshpass -e ssh user@192.168.222.116 "echo PW | sudo -S docker exec so-suricata sh -c 'grep capture.kernel_packets /var/log/suricata/stats.log'"

# 3. zeek-forward active (SO VM)
sshpass -e ssh user@192.168.222.116 "echo PW | sudo -S systemctl is-active zeek-forward"

# 4. SO agent active in Wazuh
docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -i 008

# 5. Zeek events arriving (indexer)
curl -sk -u admin:$WAZUH_ADMIN_PASSWORD "https://127.0.0.1:9200/wazuh-archives-*/_search" -H 'Content-Type: application/json' \
  -d '{"query":{"term":{"location":"/nsm/zeek/zeek-forward.log"}}}'
```

## SO -> IRIS route

- SO events arrive inside Wazuh via agent 008 -> Shuffle `wazuh-high-severity-to-iris` -> IRIS.
- IRIS case template: security-onion-suricata-alert.
- No dedicated SO->Shuffle webhook bridge (retired with the old model).

## Notes

- The zeek-forward wrapper prefixes `ZEEK` so the builtin json decoder does not
  create a `data.id` object (collides with the archives index mapping).
- Suricata eve.json is collected by the agent but only populates when alerts
  fire (config verified 2026-08-15; eve file path /nsm/suricata/eve.json).
- Worker config still carries a legacy <syslog_output> to SO:514 (inactive;
  master's was removed) - see known gap below.

## Known gaps (2026-08-15)

- Suricata alert -> IRIS end-to-end not yet exercised with a real signature hit
  (eve.json still empty - no alerts fired on the lab mirror traffic).
- wazuh_worker.conf still contains <syslog_output> to 192.168.222.116:514
  (master's was removed). Should be removed from the worker template for
  consistency.
- docker-compose.override.yml flow-relay comment still says 514/udp (actual
  SYSLOG_PORT=15140) - cosmetic.

## Safety

- No real IDS evasion/attack traffic generated for validation.
- Notify-only mode: no automated blocking from SO alerts.
