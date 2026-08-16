# Local Snapshot Retention Policy (Phase 9)

## Policy

| Tier | Repo | Cadence | Retention | Storage | Role |
|---|---|---|---|---|---|
| Local fast-recovery | wazuh-backup (fs) | every 5h | 7 days | 12G | fastest restore on same host |
| S3 durable | do-spaces | every 5h | 30 days | S3 | DR / offsite |

## Operating rules

1. Never delete local snapshots manually; retention is enforced by
   elastic-snapshot.sh (KEEP=7).
2. If local disk >= 85%: reduce local KEEP to 3 (edit elastic-snapshot.sh KEEP,
   rerun script once) - do NOT touch S3.
3. If S3 snapshots fail (freshness check FAIL > 48h): investigate BEFORE relying
   on local-only; local retention alone is NOT a DR posture.
4. Keep OpenSearch archive shipping LOCAL (per Phase 9 safety rules) unless
   operator approves after capacity review.
5. Snapshot deletion requires explicit operator approval (safety rule).

## Approved changes (Phase 9)

- No retention changes made - 7d local / 30d S3 retained (all snapshots SUCCESS).

## No secrets

No secret values printed.
