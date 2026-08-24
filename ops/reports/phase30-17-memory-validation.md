# Phase 30 Memory Validation

Date: 2026-08-24

## Before vs after (swappiness 60 -> 10)

| Metric | Before | After |
|---|---|---|
| vm.swappiness | 60 | **10** |
| Swap used | 8.0GiB | 8.0GiB (stale - not actively reclaimed; no active pressure) |
| PSI memory | 0.00 | 0.00 |
| si/so | 0/0 | 0/0 |
| Available | 2.4GiB | 2.4GiB |
| Cluster | green | green |
| Ingest / workflows | healthy | healthy |
| Healthcheck | 2 FAIL (SO VM) | 2 FAIL (SO VM, unchanged) |

## Conclusion

- Swappiness reduction applied with **zero regression** (cluster, data, workflows intact).
  Stale swap will drain naturally as pages age; no further action needed now.
- Durable fix: RAM expansion (operator, Phase 31).

## No secrets