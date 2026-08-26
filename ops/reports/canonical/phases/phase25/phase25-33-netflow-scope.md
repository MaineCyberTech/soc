# Phase 25 NetFlow Scope Decision

Date: 2026-08-22
Status: **BLOCKED - OPERATOR CLASSIFICATION NOT RECEIVED** (unchanged).

## 1. State

- Unknown subnets: ~424K flows/24h (13 subnets). Exporters: 23.150.201.36 + 192.168.222.1.
- Alerts: unarmed.

## 2. Classification needed

- Expected/unknown/ignored per subnet (operator) -> enables allowlist + alerting.

## 3. Evidence

- Classification tables maintained (phase20-24 netflow docs); no operator decision yet.

## No secrets