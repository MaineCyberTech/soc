# Phase 9 Disk Growth Report

Generated: 2026-08-15 20:13 (via ops/scripts/disk-growth-report.sh)

## Current state

- Root disk: 148G total, 91G used (63%), 52G free
- Growth drivers:
  1. **OpenSearch data**: ~9.1G across indices (elastiflow 1.3G, archives 4.2G, alerts 1.6G, misc)
  2. **Local snapshots**: 12G (/opt/wazuh-backups/elasticsearch, 63 indices, 86 files)
  3. **Docker volumes**: 41.6G (39 volumes, all active)
  4. **Docker images**: 17.7G (169 images)
  5. **mct-security-stack**: 2.7G

## 7-day snapshot growth trend (local, by size)

Latest local snapshots (snap-*.dat in /opt/wazuh-backups/elasticsearch): each snapshot
is a full-index snapshot; 63 indices retained. Snapshot schedule: every 5h local
(17 */5), every 5h S3 (47 */5), 7d local retention, 30d S3 retention.

## Projection

- At current rates (~0.5-1G/week index growth + snapshot churn), root disk stays
  under 70% for the next 60-90 days.
- If OpenSearch archive shipping were re-enabled (kept OFF per safety rules),
  growth would accelerate significantly.
- Thin pool .222: VM 201 alone holds ~48G real data (Windows). Pool 64G at 88% ->
  approx 7.7G headroom; one more Windows feature update could exceed it.

## Recommendations

1. Run disk-growth-report.sh weekly (candidate for cron).
2. Monitor thin pool with capacity-threshold-check.sh (WARN 85 / CRIT 95).
3. Keep Windows Update disabled on VM 201 (approved) until pool >100G or S3-only VM disks.
4. Consider exporting VM 201 disk to S3 for archive (optional, Phase 10).
5. Watch elastiflow index (1.3G) - if >3G, review retention.

## No secrets

No secret values printed.
