# Phase 28 Scratch Cluster Plan (Recovery Test Target)

Date: 2026-08-24
Status: **PLAN - NO ISOLATED TARGET AVAILABLE** (no-go input to 27).

## Scratch cluster specification

| Dimension | Requirement |
|---|---|
| Compute | 1+ node, same-major wazuh-indexer 4.14.x / OpenSearch 2.19.x |
| Disk | >= 40GB (21GB data + headroom) |
| Network | isolated bridge/LAN; no route to production clients; dedicated ports (9200+ offset) |
| DNS | scratch-only names; no reliance on prod DNS |
| TLS | scratch certs (self-signed OK), no prod CA |
| Secrets | ephemeral admin password; never reuse prod values |
| Access | SOC-only; no client access |
| Repository | read-only mount of snapshot volume OR S3 repo (nyc3) with scratch creds |
| Teardown | remove containers + volumes + secrets + firewall rules after drill |

## Preconditions

- Approved go/no-go (27); operator provides/allocates target or confirms absence.

## Result this phase

- No target available -> plan only. Execution deferred to an approved drill window.

## No secrets