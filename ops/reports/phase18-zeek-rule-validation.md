# Phase 18 Zeek Rule Validation

Date: 2026-08-17

## Status: VALIDATED via logtest (real decoder fields)

| Rule | Test event | Result |
|---|---|---|
| 122000 | conn 185.100.1.5->10.10.202.1:22 | FIRES level 3 |
| 122001 | conn ext->192.168.111.50:2222 | FIRES level 8 |
| 122002 | conn 185.100.1.6->:445 | FIRES level 8 |
| 122005 | conn 10.10.202.1->:22 | FIRES level 3 |
| 122006 | UDP :53 from internal | FIRES level 4 |

## Noise estimate (pre-deploy)

- Rule 122006 (UDP non-multicast) is the riskiest - could fire often on
  DNS/QUIC traffic. Monitor first 24h; adjust if noisy.
- 122004 (admin ports) moderate. 122001-122003 low (rare external SSH/SMB/RDP).

## IRIS routing

- NOT routed yet (per pack guardrail - noise must validate first).

## Files

- ops/reports/phase18-zeek-noise-check.md (created)

## No secrets
