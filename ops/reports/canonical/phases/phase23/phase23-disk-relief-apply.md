# Phase 23 Disk Relief Apply

Date: 2026-08-22
Status: **APPLIED (D1+D2)** - logged per item, non-destructive, in-policy.

## Applied

| Item | Action | Bytes reclaimed | Approval |
|---|---|---|---|
| D1 | `docker image prune -f` (dangling) | **2.16GB** | non-destructive (no approval needed) |
| D2 | `docker image prune -a -f` (unused, unreferenced) | **0.62GB** | approved-in-register (rebuildable; none referenced by containers) |

Total: **~2.8GB reclaimed** (85% -> 83%).

## Not applied (pending)

- D5 swapfile resize (service-affecting; deferred).
- D6 docker log rotation (low value; logrotate covers).

## No deletion of

- Evidence, snapshots (in-policy 7d window kept), backups, vm103 dumps (in-policy 30d), indices.

## Verification (post-apply)

- Cluster green (266 shards), 0 read-only blocks, 36 containers running, watermarks unchanged.

## No secrets