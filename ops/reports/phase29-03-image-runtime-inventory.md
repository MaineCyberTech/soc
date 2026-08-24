# Phase 29 Image Runtime Inventory

Date: 2026-08-24
Tooling: p29-image-lock-audit.sh + docker ps/inspect.

## Active runtime images (compose projects + swarm)

| Image ref | Compose/service | Running image ID | Arch | Owner | Status |
|---|---|---|---|---|---|
| wazuh/wazuh-manager:4.14.7 | multi-node (master+worker) | 25719a1b9b8a | amd64 | SOC | pinned (tag) |
| wazuh/wazuh-indexer:4.14.7 | multi-node (x3) | a24fdce561f5 | amd64 | SOC | pinned (tag) |
| ghcr.io/dfir-iris/iriswebapp_*:v2.4.29 | iris-web (app/worker/nginx/db) | f6af6018/80a22b93/771e84cc | amd64 | SOC | pinned (tag) |
| rabbitmq:3-management-alpine | iris-web | 1031d41f3f16 | amd64 | SOC | versioned exc |
| elastiflow/flow-collector:7.26.2 | multi-node | c5300c2fb949 | amd64 | SOC | pinned (tag) |
| **tenzir/tenzir:main** | phase2 | 5dc1dbd43857 | amd64 | SOC | **MUTABLE - P0** |
| **thinkst/opencanary:latest** | opencanary | 07bf63d835c9 | amd64 | SOC | **MUTABLE - P0** (compose pin stale) |
| **balabit/syslog-ng:latest** | phase2 | f10b2331efe5 | amd64 | SOC | **MUTABLE - P0** |
| **python:3-alpine** | phase2 (flow-relay) | d72efe4a0d6f | amd64 | SOC | **MUTABLE - P0** |
| **ghcr.io/shuffle/shuffle-backend:latest** | shuffle (swarm) | e5a9c7b0a7f0 | amd64 | SOC | **MUTABLE - P0** |
| **ghcr.io/shuffle/shuffle-frontend:latest** | shuffle (swarm) | a8cfa786c84a | amd64 | SOC | **MUTABLE - P0** |
| **ghcr.io/shuffle/shuffle-orborus:latest** | shuffle (swarm) | ec1b8df1131a | amd64 | SOC | **MUTABLE - P0** |
| **ghcr.io/shuffle/shuffle-worker:latest** | shuffle (swarm) | 17dbe56c9f57 | amd64 | SOC | **MUTABLE - P0** |
| frikky/shuffle:{email,http,ai,subflow,tools,healthcheck}:1.x | shuffle (swarm) | - | amd64 | SOC | versioned exc |
| opensearchproject/opensearch:3.2.0 | shuffle | b6dde07329e6 | amd64 | SOC | versioned exc |
| alpine:3.20 | phase2 | - | amd64 | SOC | versioned exc |

## Optional / feed stacks (NOT active runtime)

- greenbone (stable/feed images), misp (mariadb/valkey/modules), velociraptor (native
  binary v0.77.2 + optional compose `velociraptor:latest`), cloudflared (multi-node override).

## Findings

- **8 mutable active runtime refs** = P0 release blocker (all prepared for pinning, 04/05).
- opencanary compose already carries a digest pin that does NOT match the running image
  (3-way drift) - corrected pin in 05.
- All running images amd64; no multi-arch ambiguity.

## No secrets