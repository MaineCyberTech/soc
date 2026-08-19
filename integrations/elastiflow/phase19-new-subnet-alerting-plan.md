# Phase 19 New-Subnet Alerting Plan

Date: 2026-08-18
Status: **PLAN ONLY - NOT ARMED.** Gated on operator confirmation of unknown subnets
(see phase19-netflow-scope-decision.md).

## 1. Scope baseline (current known-good set)

Once operator confirms the unknown list, the "known" private set becomes:

- 10.11.12.0/24, 10.10.202.0/24 (pending), 192.168.1-15.0/24 (pending), 192.168.28/29/30/31.0/24,
  192.168.111.0/24, 192.168.123.0/24, 192.168.169.0/24 (pending), 192.168.192.0/24 (pending),
  192.168.222.0/24, plus MCT public ranges 23.150.200.0/23, 23.150.201.0/24, 104.198.46.0/24.

## 2. Alert definitions (ElastiFlow signal - Wazuh rules on flow events)

| Alert | Trigger | Class | Wazuh level | Route |
|---|---|---|---|---|
| New subnet first-seen | source.ip /8-/16 in an IPFIX window that has 0 previous sightings | A | 8 | IRIS (once packet routing approved) |
| Unknown exporter | host.name not in {23.150.201.36, 192.168.222.1} | A | 8 | IRIS |
| Outbound bytes spike | bytes to internet > 5x 24h baseline for a host | B | 6 | monitor |
| Unusual internal port | flows between known subnets on uncommon port (non-allowlisted) | B | 5 | monitor |

## 3. Enabling sequence (approval-gated)

1. Operator confirms/rejects each pending subnet -> update classification table.
2. Load baseline "known" CIDRs into the alerting allowlist.
3. Dry-run the 4 alert queries against last 7d (expected: only genuine first-seens, < 5/day).
4. Create Wazuh local rules + Shuffle webhook for Class A only.
5. Enable with 24h noise capture; revert if > 20 alerts/day.

## 4. Exclusions (do not alert)

- Broadcast/multicast destinations (224/4, 239/4, ff00::/8, 255.255.255.255).
- Well-known discovery ports (5353, 1900, 10001, 56700) consistent with Zeek v2 tuning.
- Cloudflare/DoH/AWS metadata ranges if observed internally.

## 5. Owners

- Baseline allowlist: SOC operator (must answer subnet questions).
- Query + rule development: SOC (this plan).
- Approval to arm: operator (change control).

## No secrets