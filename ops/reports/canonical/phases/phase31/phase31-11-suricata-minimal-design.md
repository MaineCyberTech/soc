# Phase 31 Suricata Minimal Sensor Design

Date: 2026-08-24

## Architecture (standalone, no Security Onion)

- Sensor host: designated low-resource target (lab: mct-soc-scan, Debian 13).
- One capture interface (eth0) via AF_PACKET; Wazuh agent collects `/var/log/suricata/eve.json`.
- Output: EVE JSON (alert + stats only) -> Wazuh agent file collection -> decoders/rules ->
  alerts (bounded) -> Shuffle/IRIS (guardrailed).
- Least privilege: suricata runs as its own user; no file-store, no pcap-log, no payload.
- Bounded resources: systemd MemoryMax=1536M (sub-2GiB), MemorySwapMax=1024M, memory accounting.

## Components (repo)

- integrations/suricata-minimal/suricata.yaml (low-memory profile)
- integrations/suricata-minimal/mct-alerts.rules (focused, 4 rules)
- systemd unit mct-suricata.service (bounded)

## Rollback

- `systemctl disable --now mct-suricata` + remove config/rules; no production impact (lab).

## No secrets