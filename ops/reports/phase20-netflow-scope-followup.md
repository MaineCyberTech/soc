# Phase 20 NetFlow Scope Decision Follow-up

Date: 2026-08-19
Status: **STILL BLOCKED ON OPERATOR CONFIRMATION** (unchanged from Phase 19).

## 1. Unknown subnet list (carried forward, 24h window fresh measure)

| Subnet | Flows 24h | Status |
|---|---|---|
| 10.10.202.0/24 | 106,196 | unconfirmed |
| 192.168.7.0/24 | 60,161 | unconfirmed |
| 192.168.2.0/24 | 48,583 | unconfirmed |
| 192.168.6.0/24 | 41,065 | unconfirmed |
| 192.168.192.0/24 | 36,991 | unconfirmed |
| 192.168.14.0/24 | 30,317 | unconfirmed |
| 192.168.169.0/24 | 28,334 | unconfirmed |
| 192.168.13.0/24 | 25,831 | unconfirmed |
| 192.168.1.0/24 | 21,669 | unconfirmed |
| 192.168.28.0/24 | 16,721 | unconfirmed |
| 192.168.15.0/24 | 15,169 | unconfirmed |
| 192.168.10.0/24 | 9,216 | unconfirmed |
| 192.168.8.0/24 | 7,574 | unconfirmed |

Unknown total ~448K/24h (~70% of private flows) - unchanged pattern, no operator decision received.

## 2. Operator decisions

- **Not available** as of this phase. The 3 questions from Phase 19 remain open:
  1. Are 192.168.1-15/28/169/192 + 10.10.202 legitimate client/lab/monitored subnets?
  2. Add to allowlist once confirmed?
  3. Enable observer/exporter attribution per subnet?

## 3. Alerting posture

- **UNARMED** - new-subnet/unknown-exporter alerting plan remains prepared but disabled
  (`integrations/elastiflow/phase19-new-subnet-alerting-plan.md`).

## 4. Update to classification

- Classification table refreshed with 24h numbers (this file's companion:
  `integrations/elastiflow/phase20-netflow-subnet-classification.md`). No classification
  changes without operator input.

## No secrets