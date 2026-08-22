# Phase 24 NetFlow Scope Decision

Date: 2026-08-22
Status: **BLOCKED - OPERATOR CLASSIFICATION NOT RECEIVED** (unchanged).

## 1. State

- Unknown subnets: ~424K flows/24h (13 subnets). Exporters: 23.150.201.36 + 192.168.222.1.
- Alerts: **unarmed** (new-subnet/unknown-exporter disabled pending scope approval).

## 2. Retention/reporting

- Flow retention 14d (ISM); unknown flows still indexed - dashboard (phase24-31) exposes the
  unknown-subnet watch for operator review.

## 3. Decision

- **BLOCKED**. Classification required from operator before any alerting.

## No secrets