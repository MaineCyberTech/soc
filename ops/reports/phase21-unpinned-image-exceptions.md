# Phase 21 Unpinned Image Exceptions

Date: 2026-08-19
Status: documented exceptions for `check-unpinned-docker-images.sh` (kept informational in CI).

## Accepted floating/versioned-tag refs (with rationale)

| Image | Where | Rationale |
|---|---|---|
| registry.community.greenbone.net/community/{vulnerability-tests, notus-data, scap-data, cert-bund-data, dfn-cert-data, data-objects, report-formats, gpg-data} | compose/docker-compose.greenbone.yml | vendor feed/data images - floating by design; auto-updated on container start |
| registry.community.greenbone.net/community/{openvas-scanner, ospd-openvas, gsad, gsa, pg-gvm, pg-gvm-migrator, gvm-config, gvm-tools, nginx, redis-server}:stable/latest | compose/docker-compose.greenbone.yml | Greenbone service images; `stable` is the vendor-supported channel |
| thinkst/opencanary:latest | compose/docker-compose.opencanary.yml | existing documented exception (P17); pin next release |
| velociraptor:latest | compose/docker-compose.velociraptor.yml | locally built image (not registry); deprecated compose path |
| ghcr.io/misp/misp-docker/misp-modules:latest | compose/docker-compose.misp.yml | misp-modules sidecar; pin next release |
| cloudflare/cloudflared:latest | wazuh-docker docker-compose.cloudflare.yml | tunnel client; pin next release |
| nginx:stable | wazuh-docker docker-compose.yml | agent LB; versioned-stable channel |
| python:3-alpine | wazuh-docker docker-compose.override.yml | helper; semver-tagged |
| elastiflow/flow-collector:7.26.2 | wazuh-docker docker-compose.override.yml | versioned (7.26.2) but not sha-pinned |
| balabit/syslog-ng:latest | wazuh-docker (syslog-ng helper) | helper; pin next release |
| wazuh/wazuh-{manager,indexer,dashboard}:4.14.7 | wazuh-docker docker-compose.yml | versioned (4.14.7); allowed baseline |

## Allowlist (versioned tags, not flagged)

`alpine:`, `mariadb:`, `postgres:`, `redis:`, `valkey:`, `opensearchproject/`, `wazuh/wazuh-*`.

## Policy

- Greenbone feed/data: floating accepted (vendor model), re-verified each release.
- All other non-sha refs: pin to sha256 or document before v1.1.0 (release checklist item).
- New unpinned refs beyond this list must be added here or pinned.

## No secrets