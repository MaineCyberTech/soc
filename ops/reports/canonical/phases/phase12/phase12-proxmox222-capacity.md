# Phase 12 Proxmox .222 Capacity Report

Date: 2026-08-16 01:52 UTC
Report file: ops/reports/proxmox-thinpool-report-20260816-015157.md

## Status: WARN (87.84% - above 85% WARN, below 90% ACTION)

| Metric | Value |
|---|---|
| Thin pool data usage | 87.84% (64.19G pool) |
| PV free | 4.75G |
| VMs 201-205 | all running, healthy |
| Unused disks | 0 (cleanup from P11 held - no regression) |

## Disk usage (top consumers)

| LV | Size | Data% | VM |
|---|---|---|---|
| vm-202-disk-1 | 3.00G | 90.92% | 202 canary |
| vm-201-disk-0 | 80.00G | 61.34% | 201 Windows |
| vm-204-disk-1 | 3.00G | 46.78% | 204 |
| vm-205-disk-1 | 3.00G | 40.78% | 205 |

## Assessment

- Post-cleanup pool stable (87.84%, same as P11 close).
- **vm-202 canary disk is the watch item** (90.9% of its 3G, and the disk itself
  was the top consumer in the pre-cleanup view). If canary log growth continues,
  plan: grow disk via qm resize or reduce canary retention; pool has ~4.75G PV
  headroom only.
- Windows Update remains disabled on VM 201 (policy) - no unexpected growth.

## Thresholds (documented in runbook)

WARN 85 / ACTION 90 / EMERGENCY 95. Currently WARN; next ACTION level requires
pool > 90%.

## Recommended action

1. Weekly report script now automated (ops/scripts/proxmox-thinpool-report.sh).
2. Watch vm-202 growth; if it reaches 95%+ of its disk, resize or reduce
   canary retention before the pool itself is stressed.

## No secrets

No secret values printed.
