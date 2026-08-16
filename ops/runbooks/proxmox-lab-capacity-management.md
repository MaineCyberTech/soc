# Proxmox Lab Capacity Management

Host: 192.168.222.222

## Thresholds

- WARN: 85%
- ACTION: 90%
- EMERGENCY: 95%

## Weekly monitoring

- Script: ops/scripts/proxmox-thinpool-report.sh
- Output: ops/reports/proxmox-thinpool-report-<ts>.md
- Run weekly (Sunday, before/after Greenbone schedule) and after any VM disk changes.

## Actions

1. Identify VM disk growth (report lists LVs sorted by data%).
2. Remove unused disks only after verification (qm config shows unusedN entries;
   confirm disk not referenced by any active device line).
3. Expand pool if repeated growth exceeds 90%:
   - lvextend -l +100%FREE pve/data
   - Extend underlying PV or add PV if physical space required
   - PVE .222 PV free was 4.75G at 2026-08-16 - limited headroom.
4. Avoid Windows Update growth by policy on pilot VMs (guest-side Windows Update
   disabled; monitor vm-201 disk growth).
5. Emergency (>=95%): stop write-heavy workloads, remove unused disks, extend pool.

## Current disk watch list (2026-08-16)

- vm-202-disk-1 (3G, 90.9%): canary disk - top consumer; growing ~2.4%/day risk.
  Options if sustained: grow disk (qm resize vm-202 scsi0 +3G) or reduce canary
  log retention.
- vm-201-disk-0 (80G, 61.3%): Windows pilot; growth controlled (Update disabled).
- Other disks low.

## No secrets

No secret values printed.
