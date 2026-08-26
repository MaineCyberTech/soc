# Phase 30 Compose and Container Audit

Date: 2026-08-24
Tooling: p30-runtime-drift-audit.sh + docker stats.

## Compose roots

- multi-node (3 files), mct-security-stack (3 files), iris-web, portainer, shuffle (swarm).
- Images: all active runtime digest-pinned (8 mutable) or versioned exceptions; image-gate PASS.

## Desired vs running vs cache

- Desired (compose pins) == running (recreated P29) == registry/cache digests. No drift.

## Limits / healthchecks / networks / volumes

| Area | State |
|---|---|
| Limits | opencanary 128MiB, shuffle-frontend 256MiB, backend 768MiB, orborus 384MiB, opensearch 1.5GiB; **indexers unlimited** (finding) |
| Healthchecks | IRIS nginx healthy, syslog-ng healthy; indexers via cluster health |
| Networks | multi-node_default, iris_backend/frontend, mct-security, tenzir-network, overlay swarm |
| Volumes | ~40 named; indexer data + iris + shuffle db critical |
| Privileges/caps | minimal (not privileged); host-net for elastiflow/cloudflared (documented) |
| Logging | docker default (json); Wazuh file logs |
| Restart | unless-stopped/always; swarm converge |

## Findings

- Indexer containers unbounded (mem_limit=0) - add limits at next restart (P1, with RAM).
- tenzir-node standalone (no compose def) - pin recorded; consider compose-managing (P2).

## Verdict

- **PASS** with 2 backlog items.

## No secrets