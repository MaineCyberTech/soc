# Phase 17 Remote Syslog 15140, Canary, and UniFi Review

Date: 2026-08-16

## Status: CANARY PATH WORKS - ALLOWLIST GAP + TCP/UDP MISMATCH

## 15140 listener

| Item | Value |
|---|---|
| Docker port | tcp + udp -> 0.0.0.0:15140 |
| Wazuh remoted | **UDP only** (syslog connection) |
| Allowed-ips | 192.168.222.0/24, 10.11.12.0/24, 192.168.123.0/24, 23.150.201.165, 23.150.201.36, 23.150.200.5, 172.18.0.0/24 |
| Port | 15140 |

## Canary syslog path - WORKING

- Local OpenCanary (172.18.0.8, docker network - in allowlist) -> 15140 -> master
  (agent 000) -> canary rules 121007/121012/121014.
- Last hit: 2026-08-15 23:25:58 (rule 121012).
- Canary01 (VM 202, 192.168.222.241 - in allowlist): configured.

## UniFi

- 0 uniFi docs in 24h (no UniFi syslog traffic - devices idle/absent).

## FINDINGS - syslog traffic being DROPPED

### Finding 1: Client network NOT in allowlist (HIGH)

- The 15140 syslog allowlist does NOT include 192.168.111.0/24 (client network)
  or the other networks seen in flows (192.168.169.x, 192.168.9.x, etc.).
- If any client-network device/gateway sends syslog to 15140, Wazuh SILENTLY
  DROPS it (allowed-ips check).
- This is the primary syslog-drop vector identified this phase.

### Finding 2: TCP 15140 mapped but not listened (MEDIUM)

- docker-compose maps 15140/tcp, but Wazuh remoted listens UDP-only.
- TCP syslog senders connect -> get no response/drop (no listener).

### Finding 3: Canary archive docs low (9/24h)

- Canary is quiet (no triggers) - expected; last real hit 08-15 23:25.

## Recommendations

1. Add client subnet(s) to allowed-ips once confirmed (192.168.111.0/24 + any
   client syslog senders) - requires operator confirmation of scope.
2. Align TCP: either remove 15140/tcp mapping or add a TCP syslog remote.
3. Keep canary path verified (weekly check).

## Files

- integrations/opencanary/phase17-canary-syslog-review.md (created)
- integrations/unifi/phase17-unifi-syslog-review.md (created)

## No secrets

No secret values printed.
