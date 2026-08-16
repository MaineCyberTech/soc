# Storage Expansion - VM101 (Production Host)

Purpose: grow root disk on the production host VM101 when disk crosses thresholds.
Status: Phase 9 baseline is 63% - expansion NOT yet required; procedure documented.

## When to execute

- capacity-threshold-check.sh reports disk CRIT (>= 90%), or
- free space < 15G projected within 30 days (use disk-growth-report.sh trend).

## Procedure (VMware/KVM guest, operator access required)

1. Snapshot VM101 (or VM backup) before resizing (per DR runbook).
2. On the hypervisor, grow the virtual disk by the planned amount (e.g., +40G).
3. Inside VM101:
   ```bash
   # detect the new block device size
   lsblk
   # grow the partition table entry (assuming /dev/sda, partition 1 last)
   sudo parted /dev/sda resizepart 1 100%
   # extend the filesystem
   sudo resize2fs /dev/sda1
   ```
4. Verify:
   ```bash
   df -h / | tail -1          # new size visible
   bash /opt/mct-security-stack/ops/scripts/capacity-threshold-check.sh
   ```

## Options if hypervisor expansion is not possible

- **Reduce local snapshot retention** (see local-snapshot-retention-policy.md):
  keep 7d local (current) or drop to 3d if S3 snapshots are verified; frees ~6-10G.
- **Prune old Docker images**: `docker image prune` (review first - 429MB reclaimable).
- **Move elastiflow/archives retention** down (e.g., archives 14d instead of 30d).

## Validation after expansion

- Run full-stack-healthcheck.sh (disk row PASS).
- Run backup freshness (snapshot + S3 + dr).
- Record before/after in phase9-capacity-after.md.

## No secrets

No secret values printed.
