# Phase 20 Syslog 15140 Quarterly Policy Check

Date: 2026-08-19
Status: **VALIDATED - posture intact.**

## 1. Allowlist matches repo and runtime

- Repo `wazuh_manager.conf` (9 entries) == running master `ossec.conf` remote block (9 entries).
  Phase 19 reconciliation held; no drift.
- Entries: 192.168.222.0/24, 10.11.12.0/24, 192.168.123.0/24, 23.150.201.165, 23.150.201.36,
  23.150.200.5, 172.18.0.0/24, 100.64.1.107, 192.168.111.0/24.

## 2. UDP-only posture intentional

- Wazuh remote: `<protocol>udp</protocol>` port 15140 only. TCP 15140 docker publish exists
  but no Wazuh TCP listener - documented UNUSED (intentional). No change.

## 3. Client subnet and UniFi entries

- 192.168.111.0/24 (client) present in both repo + runtime. No client syslog traffic yet
  (forward-looking entry).
- 100.64.1.107 (UniFi gateway) present; host ping OK. UniFi gateway 192.168.222.1 actively
  sending (163,742 alerts/7d).

## 4. Active senders (7d) - all within allowlist

23.150.201.36 (337,290), 192.168.222.1 (163,742), 23.150.200.5 (47,958), 10.11.12.218 (24,754),
10.11.12.97 (20,315), 192.168.123.159 (1,512). No out-of-scope senders.

## 5. Next review date

- Next quarterly review: **Phase 24 (target 2026-11)** per `integrations/syslog/phase20-15140-quarterly-review.md`.

## No secrets