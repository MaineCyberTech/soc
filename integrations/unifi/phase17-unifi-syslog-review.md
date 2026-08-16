# Phase 17 UniFi Syslog Review

Date: 2026-08-16

## Status: IDLE

- 0 uniFi decoder docs in 24h - no UniFi devices sending syslog currently.
- Decoder (unifi-cef) + rules present.

## Watch

- If UniFi gear comes online, confirm it sends to 15140 and is allowlisted.

## No secrets

## UPDATE (2026-08-16): new UniFi gateway allowed

- Added **100.64.1.107** to the 15140 syslog allowlist (master ossec.conf).
- Gateway NetFlow already flows to ElastiFlow on 2055 (3 flow records seen).
- Syslog target for the gateway: **15140/udp** (514 retired - not listened).
- Validated: remoted config test 0 errors, 15140 tcp+udp mapped, allowed-ips
  updated, manager restarted.
