# Phase 30 Indexer JVM Review

Date: 2026-08-24

## Evidence

| Item | wazuh1/2/3.indexer |
|---|---|
| Heap config | **no explicit -Xmx/-Xms in jvm.options** (default) |
| RSS | ~1.5-1.6GB each |
| VmSwap | 359-465MB each (stale) |
| Container limit | **none** (mem_limit=0) |
| Memory lock | not enabled (would need mlockall) |
| Shard workload | 264 shards / 3 nodes; cluster green |
| GC | no OOM/GC stall observed (PSI 0) |

## Assessment

- Default heap + unbounded container = each JVM can grow; kernel swaps the overflow
  (swappiness was 60). With 3 indexers + shuffle-opensearch + flowcoll on 15GiB, headroom
  is thin.
- Safe tuning options (ranked):
  1. **Set container memory limits** on indexers (e.g., 2.5GiB each) - requires recreate.
  2. **Set explicit -Xmx** (e.g., 1536m) to cap heap - requires restart.
  3. None are warranted now (stable, PSI 0) - capacity expansion is the durable fix.

## Recommendation

- No heap change this phase (no active pressure). RAM expansion (Phase 31) + limits when
  next indexer restart is scheduled.

## No secrets