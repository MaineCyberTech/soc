# Phase 14 Client 013 Baseline

Date: 2026-08-16 05:47 UTC
Script: ops/scripts/client013-baseline-report.sh (report: client013-baseline-20260816-054747.md)

## Agent health

| Item | Value |
|---|---|
| ID | 013 |
| Name | SAMSUNG |
| Status | ACTIVE (keepalive 05:47Z) |
| OS | Microsoft Windows 11 Pro 10.0.26200.9106 |
| IP / network | 192.168.111.166 (client network, non-lab) |
| Group | windows-clients (config synced) |
| Wazuh version | 4.14.7 |
| Registered | 2026-08-16 04:26:58 UTC |
| Node | worker01 (rebalanced from manager) |

## 24h metrics

| Metric | Value |
|---|---|
| Event volume | 1,243 |
| Sysmon events | 175 (channel flowing post-shared-config fix) |
| Level >= 9 alerts | 112 (dominated by VaultCli FP 92153 - pre-suppression-fix events; see P14.07) |

## Threat assessment

- No actionable threats identified.
- Level>=9 breakdown: VaultCli 92153 FPs (legit system images), SCA CIS summaries.
- Suppression fix applied 05:40 (match-based child rules) - validation pending
  next real events (P14.07).

## Billing category

- Billable (first external client endpoint).

## Onboarding status

- [x] Agent enrolled + Active
- [x] Group correct (windows-clients)
- [x] Sysmon + Windows channels flowing
- [x] Baseline captured (this report)
- [ ] 30-day scorecard cycle (P14.06)

## No secrets

No secret values printed.
