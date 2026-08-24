# Phase 29 Image Compose Pinning

Date: 2026-08-24
Status: **PIN SET PREPARED - APPROVAL PENDING** (C-GATE-1). No active compose file modified.

## Pin set (config/image-pin-set.json, registry-resolved 08-24)

| Service | From | To (approved pin) |
|---|---|---|
| tenzir-node | tenzir/tenzir:main | tenzir/tenzir@sha256:fff163ce85984ab1016580798a7c2b94376c906f9cb579ce8556a713a9253352 |
| opencanary | thinkst/opencanary:latest@sha256:db6bf96d... (stale) | thinkst/opencanary@sha256:c374c68b3e0f6b362baa00d6ba5ae4ad8e946383521482c6780b075c7ab41640 |
| syslog-ng | balabit/syslog-ng:latest | balabit/syslog-ng@sha256:8f6fe389151c2dfd4c21a2f82ef80ee17cdc71e7c023c813f3974f4d8575b8c5 |
| flow-relay | python:3-alpine | python@sha256:05b2b8b732ecd268fee8727a369f936f022d1321b59befd13c30ede22769dcdc |
| shuffle-backend | (compose already pinned) | keep @sha256:d4a5d2bf... |
| shuffle-frontend | (compose already pinned) | keep @sha256:4d700a6f... |
| shuffle-orborus | @sha256:94e61e79... (stale) | @sha256:5c300bcbfa4550d8915d01ba0e7c8dacfb6244a7566d5f685469ddd08fc84512 |
| shuffle-worker | env :latest | @sha256:fd0d420a5e0cd41f3979335e51912e8dd423e7ce540d1dfa24efdc98fb6071bd |

## Scope on approval

- compose/docker-compose.phase2.yml (tenzir, syslog-ng, flow-relay), opencanary.yml,
  shuffle.yml (orborus pin fix + worker env), plus the swarm service definitions for
  backend/frontend/orborus/worker (deploy-time `docker service update --image @sha256:`).

## Exceptions preserved (documented, not pinned)

- Versioned/feed tags: greenbone stable/feed images, misp mariadb/valkey/modules,
  frikky/shuffle:1.x, opensearch:3.2.0, alpine:3.20, postgres:16-alpine, redis:7-alpine,
  rabbitmq:3-management-alpine, velociraptor:latest (optional stack).

## Rollback

- Revert image fields to recorded tag refs (config/image-pin-set.json "rollback").

## No secrets