# Phase 56: Capacity Metrics

**Prompt:** 229-os-capacity
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Verdict:** DONE

## Summary
Captured capacity metrics (docs/bytes/shards/node) for the Shuffle OpenSearch datastore.

## Evidence
- EV-OS-CAP-1 (VERIFIED): `GET /_cat/nodes` → single node `shuffle-opensearch` (172.20.0.8), roles `dimr`, `heap.percent: 72`, `ram.percent: 81`, `cpu: 24`, `disk.used_percent: 67.38`, `load_1m: 4.79`.
- EV-OS-CAP-2 (VERIFIED): `GET /_cat/allocation` → node holds `76` shards; `UNASSIGNED: 64`; `disk.used: 132.5gb`, `disk.avail: 64.1gb`, `disk.total: 196.6gb` (67% used).
- EV-OS-CAP-3 (VERIFIED): Total docs across indices include `workflowexecution-000001` 1197, `files` 1243, `hooks` 6, `workflow_revisions-000001` 491, `org_cache_revisions-000001` 1353, `top_queries-*` ~4.3k–6.0k/day (see 230).
- EV-OS-DISK-1 (VERIFIED): `GET /_cluster/settings?include_defaults` for `routing.allocation.disk.*` returns empty → default watermarks apply (threshold_enabled default true). NOTE: the root AGENTS.md disk-watermark-DISABLED note applies to the **Wazuh indexer**, not this Shuffle OpenSearch cluster.

## Backup/Rollback
Read-only; no changes.

## Stop conditions
None. Disk/capacity changes (watermark, scaling, shard tuning) are mutation gates and were NOT taken.

## Limitations
Single-node; 64 unassigned shards are replicas (see 224/228).

## Verdict rationale
Capacity metrics captured live (docs/bytes/shards/node/disk). DONE.
