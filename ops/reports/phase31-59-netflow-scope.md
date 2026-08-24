# Phase 31 NetFlow Scope Decision

Date: 2026-08-24
Status: **BLOCKED - OPERATOR CLASSIFICATION NOT RECEIVED** (unchanged).

## State

- Unknown subnets ~424K flows/24h (13 subnets). Exporters: 23.150.201.36 + 192.168.222.1.
- Alerts unarmed; classification tables maintained; no operator decision.

## Operator evidence required (Phase 28 acceptance #14)

- Signed classification of each unknown subnet (internal/trusted/client/other) and
  confirmation of the exporter set. Without it, alert arming stays blocked (no broad routing).

## No secrets