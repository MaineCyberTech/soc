# Phase 18 Syslog 15140 Allowlist Policy

Date: 2026-08-17

## Policy

- Remote syslog (15140/udp) allowlist is the ONLY syslog ingress.
- Every source must be documented (source/subnet, protocol, purpose,
  expected event type, owner, review date).
- Changes require operator approval + change-control entry.

## Allowlist registry

| Source/Subnet | Protocol | Purpose | Expected events | Owner | Review | Status |
|---|---|---|---|---|---|---|
| 192.168.222.0/24 | udp | lab devices (canary01, UniFi lab) | canary, unifi | MCT SOC | quarterly | ACTIVE |
| 10.11.12.0/24 | udp | VPN/remote mgmt | syslog | MCT SOC | quarterly | ACTIVE |
| 192.168.123.0/24 | udp | mgmt net | syslog | MCT SOC | quarterly | ACTIVE |
| 23.150.201.165 | udp | public device | syslog | MCT SOC | quarterly | ACTIVE |
| 23.150.201.36 | udp | public device | syslog | MCT SOC | quarterly | ACTIVE |
| 23.150.200.5 | udp | public device | syslog | MCT SOC | quarterly | ACTIVE |
| 172.18.0.0/24 | udp | docker (OpenCanary) | canary | MCT SOC | quarterly | ACTIVE |
| 100.64.1.107 | udp | UniFi gateway (client) | unifi | MCT SOC | quarterly | ACTIVE (added P17) |
| 192.168.111.0/24 | udp | CLIENT network | client device syslog | MCT SOC | quarterly | ACTIVE (added P18) |

## Rules

1. No source without a registry entry.
2. TCP 15140: docker port mapped but remoted is UDP-only - TCP documented
   as UNUSED (see P18.09).
3. 514 retired - no listener (P9); docs updated.

## Files

- integrations/syslog/phase18-15140-allowlist.md (created)

## No secrets
