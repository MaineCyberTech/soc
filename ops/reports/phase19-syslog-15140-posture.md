# Phase 19 Syslog 15140 Posture Validation

Date: 2026-08-18

## 1. Client subnet allowlist state

- **Running** master `ossec.conf` remote block: 9 entries incl. **192.168.111.0/24** (client) and **100.64.1.107** (UniFi gateway) - confirmed inside the container.
- **Repo** `wazuh_manager.conf`: was missing the 2 P18 additions - **RECONCILED this run** (backup: `ops/backups/wazuh_manager.conf.phase19-20260818-213400.bak`). Repo now matches running state.

## 2. UniFi gateway state

- 100.64.1.107 (UniFi gateway, CGNAT) pingable from host: OK.
- 192.168.222.1 (UniFi/lab gateway) actively sending syslog: **163,978 alerts/7d** (location = source IP).
- UniFi syslog flow is healthy.

## 3. UDP listener behavior

- Host publish: `0.0.0.0:15140->15140/udp` (master container) - **UP**.
- Wazuh remote: `<protocol>udp</protocol>` port 15140 - active. Observed senders last 7d (location = srcip):
  - 23.150.201.36: 386,814 (public device)
  - 192.168.222.1: 163,978 (UniFi gateway)
  - 23.150.200.5: 49,414 (public device)
  - 10.11.12.218 / 10.11.12.97 / 10.11.12.204: 25,718 / 21,294 / 388 (VPN/mgmt)
  - 192.168.123.159: 1,509 (mgmt)
- All observed senders fall inside the allowlist - posture intact. No allowlisted-but-silent surprises except client subnet (no client device sends syslog yet; entry is forward-looking).

## 4. TCP 15140

- Host publish: `0.0.0.0:15140->15140/tcp` **exists** (docker compose publishes both), BUT Wazuh remoted has no TCP 15140 remote block (udp-only). TCP 15140 connections are **not serviced** - effectively unused.
- Recommendation: leave documented as UNUSED; optionally remove the TCP port publish to reduce surface. No behavioral impact either way.

## 5. Quarterly review doc

Created: `integrations/syslog/phase19-15140-quarterly-review.md` (template + this quarter's data).

## Decision

- Posture: **VALIDATED** (allowlist matches running+repo, UDP listener healthy, senders within scope, TCP intentionally unused).
- Action item: review client subnet 192.168.111.0/24 allowlist entry at next quarterly review; consider removing TCP publish.

## No secrets