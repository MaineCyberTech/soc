# Phase 31v2 Lab Deploy

Date: 2026-08-24
- Sensor deployed on mct-soc-scan (Debian 13): Suricata 7.0.10 (apt), systemd mct-suricata
  (MemoryMax 1536M), capture ens19, config gate PASS. Rollback: systemctl disable --now
  mct-suricata + remove /etc/suricata.

## No secrets
