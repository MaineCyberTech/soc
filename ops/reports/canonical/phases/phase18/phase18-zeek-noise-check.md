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

## UPDATE (1h post-deploy): noise found + tightened

- Rule 122006 (UDP) fired 2,286/1h - TOO NOISY.
- FIX: excluded DNS(53)/NTP(123)/QUIC(443)/SSDP(1900)/mDNS(5353)/LLMNR(5355)/
  WireGuard(51820).
- Re-measure after fix.
