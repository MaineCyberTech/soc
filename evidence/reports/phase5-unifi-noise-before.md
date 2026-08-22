> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 5 UniFi Noise Before

Date: 2026-08-11, window: 24h (post-osquery-suppression)

## Total

- UniFi family (ubiquiti/unifi/firewall/dhcp groups): **235,717 alerts/24h**
  (was ~238k in Phase 4 - osquery suppression removed 50.6% but UniFi is now
  the dominant source at ~92% of remaining volume)

## Top UniFi rules

| rule.id | count | level | description |
|---|---|---|---|
| 120520 | 55,286 | 3 | 802.11r roaming handoff |
| 120527 | 50,216 | 4 | unknown device (MAC not in known-devices) |
| 120518 | 19,085 | 5 | LAN dropped |
| 120501 | 18,117 | 6 | WAN blocked/drop |
| 120531 | 15,774 | 3 | client kicked by kernel |
| 120521 | 15,149 | 6 | WPA replay failure |
| 120532 | 7,887 | 3 | client kicked (rssi) |
| 120510 | 7,803 | 5 | client disconnected |
| 120506 | 7,037 | 3 | station event |
| 120528 | 5,810 | 4 | DHCP |
| 120512 | 5,225 | 3 | station tracker |
| 120517 | 4,484 | 3 | kernel station |
| 120505 | 4,351 | 3 | station anomaly |
| 120509 | 4,014 | 4 | client connected |

## Classification (proposed)

- **Class C digest**: 120520, 120531, 120532, 120510, 120506, 120512, 120517, 120505, 120509, 120528 (routine churn/lifecycle) - ~117k/24h
- **Class C digest**: 120518, 120501 (routine drops) - ~37k/24h
- **Class B review**: 120527 (unknown device - needs MAC list work first)
- **Class B storm**: 120521 WPA replay (storm rule 120524 stays B)
- **Class A**: MISP-matched drops (1205xx with known malicious IP) - untouched
