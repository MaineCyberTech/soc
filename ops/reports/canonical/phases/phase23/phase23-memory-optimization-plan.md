# Phase 23 Indexer and Shuffle Memory Review

Date: 2026-08-22

## Current state

| Service | RSS | Cap | Swapping |
|---|---|---|---|
| wazuh indexer x3 | ~1.7-1.8GB each | 15.19GB (container) | no (si=0) |
| shuffle-opensearch | 1.42GB | 1.5GB | no (VmSwap 7MB) |
| elastiflow | 695MB | - | no |
| master/worker/dashboard | 180-273MB | - | no |

## Assessment

- Indexers: healthy heap behavior (P17 tuning intact); no shard-count issue (266 shards, 3 nodes).
- shuffle-opensearch: near its 1.5GB cap (94%) - not swapping but headroom is thin. Raising the
  cap adds memory pressure; lowering risks eviction. Leave as-is (no pressure signals).
- PSI ~0, si=0 -> no cache/memory pressure requiring change.

## Staged changes (with rollback + health gates) - NONE this phase

- No safe change identified that improves measured performance; changes would be speculative.
  Re-review if: si > 0 sustained, shuffle-opensearch evictions, or indexer GC pauses observed.

## Watch items

- Indexer GC logs (pause > 1s = heap review trigger).
- shuffle-opensearch heap usage trend (persistent >95% = raise cap to 2GB with container limit).
- Swap si counter weekly.

## No secrets