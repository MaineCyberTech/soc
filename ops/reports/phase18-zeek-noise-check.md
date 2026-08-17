# Phase 18 Zeek Noise Check

Date: 2026-08-17

## Baseline (24h after deploy - measure)

- Expected alert volume by rule (to measure after 24h):
  - 122001-122003: low (external SSH/SMB/RDP rare in lab)
  - 122004: moderate (admin ports)
  - 122005: level 3 baseline (informational)
  - 122006: HIGHEST RISK (UDP/DNS/QUIC) - watch

## Gate

- If 122006 > 500/day: tighten (require known ports, exclude DNS 53).
- If any rule noisy: adjust level or add negates.
- Re-check 24h post-deploy.

## No secrets
