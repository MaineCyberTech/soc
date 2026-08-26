# Phase 29 Image Cache and Rollback Validation

Date: 2026-08-24
Status: **VALIDATED (registry-resolvable; cache pull test pending offline registry)**.

## Pin resolvability

- All 8 pins resolved from upstream registries (04). `docker buildx imagetools inspect`
  returned manifests for each - pullable at apply time.
- Local cache: opencanary/tenzir/syslog-ng/python images already present locally (running);
  shuffle swarm images present locally (running). Pinned digests match registry; no offline
  registry exists yet (cache = local docker image store).

## Rollback set (pre-pinning refs recorded)

- config/image-pin-set.json "rollback": exact tag references per service. Revert via
  `sed` on compose + `docker service update --image <tag>` for swarm.

## Recovery instructions

1. `docker pull <pin>` (or from internal cache/registry once mirrored).
2. Compose: `docker compose up -d <svc>`; Swarm: `docker service update --image <pin> <svc>`.
3. On failure: revert to rollback tag; `docker service rollback <svc>` (swarm has native rollback).

## Note

- No offline image mirror/registry yet (cache is file-based for packages + local docker
  store). Offline-pull guarantee requires a registry mirror (P2, phase 30).

## No secrets