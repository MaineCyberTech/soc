# Phase 23 Disk Relief Plan

Date: 2026-08-22
Status: PLAN - per-item approval required (C4). Never delete evidence/snapshots/backups outside policy.

## Approved-eligible actions (non-destructive)

| # | Action | Est. reclaim | Risk | Approval |
|---|---|---|---|---|
| D1 | `docker image prune` (dangling only) | ~0.4GB | none (no container impact) | non-destructive - apply |
| D2 | `docker image prune -a` (unused images only) | ~10GB | low (re-pull on restart; images pinned/digest) | PENDING |
| D3 | Snapshot store trim | 0 (in-policy 7d window) | n/a | not applicable |
| D4 | vm103 dump trim | 0 (in-policy 30d) | n/a | not applicable |
| D5 | swapfile resize 8GB -> 4GB | ~4GB | MED (swapoff/recreate, service-affecting) | PENDING + change window |
| D6 | Docker log rotation | ~0.5GB | low | PENDING |

## Sequencing

1. D1 (now, non-destructive).
2. D2 on approval -> re-verify disk + cluster.
3. D5 only if disk still > 82% after D2 and a maintenance window exists (swapoff brief).

## Targets

- Disk: < 82% (post D2), ultimately < 80%.
- Cluster: green, no write blocks, watermarks unchanged.

## Monitoring

- Re-run disk + watermark checks after each action (23.18).

## No secrets