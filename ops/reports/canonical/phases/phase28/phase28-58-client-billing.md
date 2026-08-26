# Phase 28 Client Fleet Billing

Date: 2026-08-24

## Endpoint certification status

| id | Status | Telemetry | Cert | Billable |
|---|---|---|---|---|
| 013 SAMSUNG | disconnected (transient) | EID1 62/24h, EID7 39/24h | PARTIAL (marker + continuity) | coverage billable; quality attestation pending |
| 014 DESKTOP-MI54LFT | active | EID1 99/24h, EID7 0/24h | PARTIAL (marker) | coverage billable; quality attestation pending |
| 015 Julians-Air | disconnected (transient) | bounded (108 alerts/24h) | CERTIFIED | billable |

## Risk / exceptions

- 013/015 transient offline at review (not a coverage failure - telemetry was healthy pre-
  offline). Quality certification pending operator marker confirmation (C1).

## Billing basis

- Coverage (3/3 deployed + active-when-online) billable. Premium quality tier waits on
  cert PASS (acceptance #1/#2).

## No secrets