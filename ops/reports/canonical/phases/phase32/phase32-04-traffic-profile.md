# Phase 32 Traffic Profile

Date: 2026-08-25
- SPAN multi-VLAN: 192.168.111.0/24 (client) + 192.168.123/222 + 10.10.202 + broadcast.
- Protocols observed: mDNS (5353), SSDP (1900), UDP broadcast, ARP, STP, HTTP/DNS.
- Rate: ~90pps sustained (peaks observed). Profile is broadcast/benign-heavy; detection
  value requires rules matching malicious indicators within this mix.

## No secrets
