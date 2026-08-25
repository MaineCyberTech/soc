# Phase 36: Shuffle Dependency Audit

Date: 2026-08-25

## Containers
| Container | Image | Status |
|---|---|---|
| shuffle-backend | ghcr.io/shuffle/shuffle | Up 22h |
| shuffle-frontend | ghcr.io/shuffle/shuffle | Up 10min (recent restart) |
| shuffle-orborus | ghcr.io/shuffle/shuffle-orborus | Up 22h |
| shuffle-opensearch | opensearchproject/opensearch | Up 3 days |
| shuffle-workers | ghcr.io/shuffle/shuffle-worker | Up 22h |
| shuffle-ai | frikky/shuffle:shuffle-ai_1.1.0 | Up 23h (x2) |
| shuffle-tools | frikky/shuffle:shuffle-tools_1.2.0 | Up 23h (x2) |
| shuffle-subflow | frikky/shuffle:shuffle-subflow_1.1.0 | Up 23h (x2) |
| shufflehealthcheck | frikky/shuffle:shufflehealthcheck_1.1.0 | Up 14min (x2) |

## Swarm services
- shuffle-workers: 1/1 replicated
- shuffle-ai, shuffle-tools, shuffle-subflow, shufflehealthcheck: 2/2 replicated

## Dependencies
- No external database (using Shuffle OpenSearch)
- No Redis
- Network: shuffle_swarm_executions (overlay)

## Assessment: ALL HEALTHY
## No secrets
