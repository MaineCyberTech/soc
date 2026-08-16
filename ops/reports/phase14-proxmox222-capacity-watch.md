# Phase 14 Proxmox .222 Capacity Watch

Date: 2026-08-16 06:34 UTC

## Status: STABLE WARN (87.84%)

| Metric | P13 | P14 now | Trend |
|---|---|---|---|
| Thin pool | 87.84% | 87.84% | FLAT (5 checks) |
| PV free | 4.75G | 4.75G | FLAT |
| vm-202 canary disk | 90.92% | 90.95% | +0.03% (negligible) |
| Unused disks | 0 | 0 | OK |

## Assessment

- Pool flat for 5th consecutive check over ~6h.
- vm-202 canary disk micro-growth (+0.03%) - not actionable.
- Thresholds: WARN 85 / ACTION 90 / EMERGENCY 95. Currently WARN.
- No resize or extension needed.

## Recommendation

- Continue weekly reports (scripted).
- Action only if vm-202 > 95% of its 3G disk, or pool > 90%.

## No secrets
