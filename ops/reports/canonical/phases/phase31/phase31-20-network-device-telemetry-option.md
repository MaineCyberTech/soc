# Phase 31 Network Device Telemetry Option

Date: 2026-08-24

## Existing / available (no local packet inspection)

| Source | Status | Coverage |
|---|---|---|
| NetFlow/IPFIX (elastiflow flowcoll) | running (~424K flows/24h) | traffic metadata - **unclassified subnets** (59) |
| Device syslog (routers/firewalls IDS alerts) | portal VPS (Redis issue 60); client devices unverified | unknown |
| DNS/DHCP/VPN logs | not collected centrally | gap |
| Endpoint agents (Wazuh) | 3/3 coverage | host-level |

## Assessment

- Device telemetry is a **complement** (low-resource) but does not replace packet inspection
  for IDS coverage. NetFlow already provides flow metadata; arming alerts gated on scope
  classification (59).

## No secrets