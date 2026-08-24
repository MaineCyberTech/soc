# Phase 30 Performance and Capacity Audit

Date: 2026-08-24

## Evidence

| Metric | Value |
|---|---|
| CPU | idle 74-86%; no sustained load |
| RAM | 12/15GiB used, 2.4GiB available |
| Swap | 8GiB full but **stale** (PSI 0, si/so 0); swappiness 60->10 |
| JVM | 3 indexer (~1.5GB RSS each) + shuffle-opensearch 1.4GB; indexers unbounded |
| Shards | 264 (3 nodes); cluster green |
| Disk | 82%; daily growth ~100MB (collapsed) |
| I/O | low (vmstat bi/bo small) |
| Queues | guardrail executions 4/24h (limit 5) |
| NetFlow | ~424K flows/24h (unclassified) |

## Forecast

- Disk plateau ~76-78% after 08-15..18 wave (~2 days). RAM is the constraint: durable fix =
  expansion (Phase 31). JVM limits at next restart.

## Verdict

- **PASS** (stable; RAM capacity item for Phase 31).

## No secrets