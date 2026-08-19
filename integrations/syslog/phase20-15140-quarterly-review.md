# Phase 20 Syslog 15140 Quarterly Review

Frequency: quarterly. Owner: SOC operator.
Last review: Phase 20 (2026-08-19). Next: Phase 24 (target 2026-11).

## Purpose

Recurring review of the remote syslog listener on UDP 15140: allowlist correctness,
traffic health, and drift between running config and repo.

## 1. Allowlist registry (current, 9 entries, all UDP)

| Source | Purpose | Added |
|---|---|---|
| 192.168.222.0/24 | lab | P4 |
| 10.11.12.0/24 | VPN/mgmt | P4 |
| 192.168.123.0/24 | mgmt | P4 |
| 23.150.201.165 | public device | P4 |
| 23.150.201.36 | public device | P4 |
| 23.150.200.5 | public device | P4 |
| 172.18.0.0/24 | docker/OpenCanary | P17 |
| 100.64.1.107 | UniFi gateway (CGNAT) | P18 |
| 192.168.111.0/24 | CLIENT network | P18 |

## 2. Traffic health (Phase 19 measurements)

- Active senders last 7d (all inside allowlist): 23.150.201.36 (386,814), 192.168.222.1
  (163,978), 23.150.200.5 (49,414), 10.11.12.218/97/204, 192.168.123.159.
- Client subnet 192.168.111.0/24: allowlisted, **no syslog traffic observed** (endpoints are
  Wazuh agents, not syslog senders) - entry is forward-looking for client network gear.
- TCP 15140: docker port publish exists but Wazuh remoted is udp-only -> **TCP unused**.

## 3. Review checklist (run each quarter)

- [ ] Repo `wazuh_manager.conf` remote block == running ossec.conf remote block (drift check).
- [ ] All active senders within allowlist; no allowlisted source sending unexpectedly high/low.
- [ ] UDP 15140 listener up; no errors in ossec-remoted log.
- [ ] OpenCanary (172.18.0.0/24) syslog path still flowing.
- [ ] Decide: keep, trim, or add allowlist entries; revisit client subnet entry.
- [ ] Decide: remove TCP 15140 publish (surface reduction) if unused.

## 4. Changes since last review

- P19: reconciled repo `wazuh_manager.conf` to match running config (added 100.64.1.107 and
  192.168.111.0/24). No allowlist changes this quarter.

## No secrets