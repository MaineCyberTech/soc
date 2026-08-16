# Phase 16 Proxmox .222 and VM202 Capacity

Date: 2026-08-16 07:31 UTC

## Status: STABLE WARN

| Metric | Value | Trend |
|---|---|---|
| Thin pool | 87.84% | FLAT (7 checks) |
| vm-202 canary disk | 90.95% | FLAT |
| PV free | 4.75G | FLAT |
| Unused disks | 0 | OK |

## Assessment

- No growth across 7 consecutive checks (~7h).
- vm-202: no action needed (action only > 95%).
- ES snapshot cleanup (P16.03) freed 4.3G of HOST disk (not pool) - host / at 65%.

## No secrets
