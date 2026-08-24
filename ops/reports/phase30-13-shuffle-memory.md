# Phase 30 Shuffle Memory Review

Date: 2026-08-24

## Evidence

| Item | Value |
|---|---|
| shuffle-opensearch | RSS 1.40GB; limit 1.5GiB (mem_limit 1610612736), memswap 3GiB |
| shuffle-backend | 82MiB / 768MiB limit |
| shuffle-frontend | 6MiB / 256MiB limit |
| shuffle-orborus | 22MiB / 384MiB limit |
| shuffle-workers (swarm) | 61MiB |
| celery workers | ~146MB total VmSwap (stale) |
| Retained data | shuffle-opensearch indices (opensearch 3.2.0) |

## Assessment

- Shuffle containers are within limits; the opensearch JVM is at its 1.5GiB limit (heap
  pressure contained by limit). Shuffle DB small. No Shuffle-specific memory action needed.

## No secrets