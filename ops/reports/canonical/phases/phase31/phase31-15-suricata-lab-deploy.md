# Phase 31 Suricata Lab Deploy

Date: 2026-08-24
Status: **DEPLOYED (LAB, APPROVED - isolated target, no production routing)**.

## Deploy (evidence)

- Target: mct-soc-scan (Debian 13, isolated, no production SPAN/TAP; no production routing).
- Suricata 7.0.10 installed (apt). Config gate PASS (12). Ruleset 4 rules (13).
- systemd unit mct-suricata.service: MemoryMax 1536M, MemorySwapMax 1024M, accounting on;
  capture eth0 (AF_PACKET, ring 250). Service **active**.
- Rollback: `systemctl disable --now mct-suricata`; remove /etc/suricata; no production impact.

## No secrets