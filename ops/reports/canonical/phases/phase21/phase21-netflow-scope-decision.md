# Phase 21 NetFlow Scope Decision

Date: 2026-08-19
Status: **STILL BLOCKED ON OPERATOR CONFIRMATION** (unchanged from Phases 19/20).

## 1. Unknown subnet flows (24h)

- **448,520 flows/24h** from 13 unconfirmed subnets (10.10.202.0 + 192.168.1/2/6/7/8/10/13/14/15/28/169/192.0) - ~70% of private flows.
- Same pattern as P19/P20; no operator decision received.

## 2. Operator decision needed (3 questions, still open)

1. Are these client/lab/monitored subnets?
2. Add to allowlist once confirmed?
3. Enable observer/exporter attribution?

## 3. Alerting posture

- **UNARMED** (new-subnet/unknown-exporter alerting plan prepared; not enabled).

## 4. Classification

- Updated table: `integrations/elastiflow/phase21-netflow-subnet-classification.md`.

## Decision

- **BLOCKED** on operator. No scope change; alerting remains unarmed.

## No secrets