# Alert Volume Baseline - Phase 3

Date: 2026-08-11, window: last 24h, index: wazuh-alerts-*
Script: ops/scripts/alert-volume-by-rule.sh

## Summary

**521,036 alerts/24h** (track_total_hits verified). Two dominant sources:

1. **osquery** rule 24010: **263,613 (50.6%)** - Security Onion osquery open_sockets inventory results (level 3, expected inventory noise).
2. **UniFi/Ubiquiti syslog** family (roaming, firewall drops, client churn): **238,074 (45.7%)** from gateway 23.150.201.36.
3. mct-portal + auditd: ~18,373 (3.5%).

Correction note: initial baseline draft understated volume and missed rule 24010
(first aggregation row was omitted from the hand-written table); corrected 2026-08-11
from alert-volume-by-rule-20260811-044210.md.

## Top 25 noisy rules

| rank | rule.id | count | level | group | top agent | source/location |
|---|---|---|---|---|---|---|
| 1 | 24010 | 263,633 | 3 | osquery | securityonion | osquery - open_sockets inventory |
| 2 | 120520 | 54,725 | 3 | ubiquiti | wazuh.master | 23.150.201.36 - 802.11r roaming handoffs |
| 3 | 120527 | 53,186 | 4 | ubiquiti | wazuh.master | 23.150.201.36 - unknown device (MAC not in known-devices list) |
| 4 | 120518 | 19,039 | 5 | ubiquiti | wazuh.master | 192.168.222.1 - LAN dropped |
| 5 | 120501 | 18,756 | 6 | firewall | wazuh.master | 23.150.201.36 - WAN blocked/drop |
| 6 | 120531 | 15,342 | 3 | ubiquiti | wazuh.master | 23.150.201.36 - client kicked by kernel |
| 7 | 120537 | 10,276 | 5 | mctportal | mct-portal-dev | app json.log - warn/error |
| 8 | 120510 | 8,108 | 5 | ubiquiti | wazuh.master | 23.150.201.36 - client disconnected |
| 9 | 120532 | 7,671 | 3 | ubiquiti | wazuh.master | 23.150.201.36 - client kicked (rssi) |
| 10 | 120506 | 7,461 | 3 | ubiquiti | wazuh.master | 23.150.201.36 - station event |
| 11 | 120528 | 5,891 | 4 | dhcp | wazuh.master | 23.150.201.36 - DHCP |
| 12 | 120512 | 5,515 | 3 | ubiquiti | wazuh.master | 23.150.201.36 - station tracker |
| 13 | 120517 | 4,721 | 3 | ubiquiti | wazuh.master | 23.150.201.36 - kernel station |
| 14 | 120509 | 4,332 | 4 | ubiquiti | wazuh.master | 23.150.201.36 - client connected |
| 15 | 120505 | 4,271 | 3 | ubiquiti | wazuh.master | 10.11.12.218 - station anomaly |
| 16 | 120523 | 3,415 | 3 | ubiquiti | wazuh.master | 23.150.201.36 - hostapd custom |
| 17 | 80710 | 3,221 | 10 | audit | mct-portal-dev | audit.log - auditd events (level 10!) |
| 18 | 120511 | 3,057 | 6 | ubiquiti | wazuh.master | 23.150.201.36 - roaming failure |
| 19 | 120513 | 2,850 | 6 | ubiquiti | wazuh.master | 192.168.222.1 - memory pressure |
| 20 | 120560 | 2,055 | 5 | mctportal | wazuh.master | 192.168.222.1 - DDNS failure |
| 21 | 86003 | 1,750 | 3 | docker | securityonion | journald |
| 22 | 120557 | 1,383 | 5 | mctportal | mct-portal-dev | app json.log |
| 23 | 120556 | 1,378 | 5 | mctportal | wazuh.master | 23.150.201.36 - wireless key/ioctl failure |
| 24 | 120402 | 1,062 | 5 | unifi | wazuh.master | 23.150.201.36 - UniFi infra event |
| 25 | 5710 | 1,028 | 5 | authentication_failed | mct-portal-dev | journald - auth failures |

## Source breakdown

- osquery (rule 24010, Security Onion inventory): ~50.6% (263,613/24h).
- UniFi/Ubiquiti gateway 23.150.201.36: ~45.7% (238,074/24h - roaming, firewall drops, churn).
- mct-portal (app json.log + auditd): ~3.5% (18,373/24h).
- Others (flow, opencanary, SO, docker journald): remainder.

## Notes

- Rule 24010 (osquery) is expected inventory noise - prime Class D archive candidate.
- Rule 80710 (auditd) at **level 10** is the highest-severity noisy rule - 3,221 hits/24h.
- Levels for UniFi noise are mostly 3-6; tuning = lower priority, not necessarily level change.
- Full detail in ops/reports/alert-volume-by-rule-20260811-044210.md
