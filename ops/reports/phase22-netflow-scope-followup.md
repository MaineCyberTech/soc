# Phase 22 NetFlow Scope Decision Follow-up

Date: 2026-08-22
Status: **STILL BLOCKED ON OPERATOR CONFIRMATION** (unchanged from P19-21).

## 1. Unknown subnet flows (24h)

- **423,212 flows/24h** from the 13 unconfirmed subnets (10.10.202.0 + 192.168.1/2/6/7/8/10/13/14/15/28/169/192.0) - ~70% of private flows. Pattern consistent across P19-22.
- Exporters: 23.150.201.36 + 192.168.222.1 (unchanged).

## 2. Operator questions (still open)

1. Are these client/lab/monitored subnets?
2. Add to allowlist once confirmed?
3. Enable observer/exporter attribution?

## 3. Alerting posture

- **UNARMED** (new-subnet/unknown-exporter alerts disabled pending scope approval).

## 4. Classification

- Table carried forward (`integrations/elastiflow/phase22-netflow-subnet-classification.md` -
  refreshed copy). No operator classifications received.

## 5. Decision

- **BLOCKED**. No scope change; alerting remains unarmed. Re-escalate at monthly ops.

## No secrets