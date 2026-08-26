# Phase 27 Client Fleet Billing Certification

Date: 2026-08-24

## Endpoint certification status

| id | Status | Telemetry | EID7 | EID1 | Buffer | Throttle | Cert |
|---|---|---|---|---|---|---|---|
| 013 SAMSUNG | active | healthy | quiet (0/30m) | 39/30m | clean | - | PARTIAL (marker pending) |
| 014 DESKTOP-MI54LFT | active | healthy | quiet (0/30m) | 7/30m | clean | active | PARTIAL (marker pending) |
| 015 Julians-Air | active | bounded ULS (33 docs/24h) | n/a | n/a | 0 | - | **CERTIFIED** |

## Billing

- 3/3 covered + active. 015 certified. 013/014 coverage counts; quality attestation pending
  marker confirmation (volume evidence strong). Invoice on coverage basis.

## Owner action

- Operator: run re-apply/restart + check on 013/014 -> post `-s` dump -> SOC completes
  certification + throttle retirement.

## No secrets