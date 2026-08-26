# Phase 22 Image Pinning Results

Date: 2026-08-22

## Pinned (digest added, verified against running containers)

| File | Image ref now |
|---|---|
| compose/docker-compose.opencanary.yml | thinkst/opencanary:latest@sha256:db6bf96d... |
| wazuh-docker docker-compose.cloudflare.yml | cloudflare/cloudflared:latest@sha256:e39ee8da... |
| wazuh-docker docker-compose.yml | nginx:stable@sha256:46ccc48f... |
| wazuh-docker docker-compose.override.yml | elastiflow/flow-collector:7.26.2@sha256:c668429f... |
| wazuh-docker docker-compose.override.yml | python:3-alpine@sha256:a1321512... |

Method: digest taken from `docker image inspect` of the running image (same image as running;
no pull/change/recreate). Compose config re-verified (RC=0).

## Not pinned (classified exceptions - see phase22-container-image-classification.md)

- Greenbone feeds (F) + Greenbone services (V), misp-modules (V), balabit/syslog-ng (V),
  velociraptor (C, locally built).

## Next

- New unpinned refs in compose -> checker flags as VIOLATION (runtime-pin policy) unless
  classified in `ops/config/unpinned-image-exceptions.txt`.

## No secrets