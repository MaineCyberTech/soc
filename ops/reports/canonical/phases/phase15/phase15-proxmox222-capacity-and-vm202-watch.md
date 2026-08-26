# Phase 15 Proxmox .222 Capacity and VM202 Watch

Date: 2026-08-16 07:06 UTC

## Status: STABLE WARN

| Metric | P14 | P15 now | Trend |
|---|---|---|---|
| Thin pool | 87.84% | 87.84% | FLAT (6 checks) |
| vm-202 canary disk | 90.95% | 90.95% | FLAT |
| PV free | 4.75G | 4.75G | FLAT |
| Unused disks | 0 | 0 | OK |

## VM202 (canary) watch

- Canary disk at 90.95% of 3G - FLAT since P14 (no growth).
- Canary service: OpenCanary container up; rule 121012 last fired 08-15 23:25.
- Action only if > 95%: resize (+1-2G) or reduce canary retention.

## Recommendation

- Weekly report (scripted) - no action needed.
- Pool extension only if > 90% sustained.

## No secrets
