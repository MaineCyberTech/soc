# Phase 22 Container Image Classification

Date: 2026-08-22
Categories: **R** runtime-pin (digest) | **F** feed-tracking | **V** versioned-exception | **C** cache-only

## Classified images (was 25 unpinned refs)

| Image | Category | Action |
|---|---|---|
| thinkst/opencanary:latest | R | **PINNED** @sha256:db6bf9... (P22) |
| cloudflare/cloudflared:latest | R | **PINNED** @sha256:e39ee8... (P22) |
| nginx:stable (wazuh-docker) | R | **PINNED** @sha256:46ccc4... (P22) |
| elastiflow/flow-collector:7.26.2 | R | **PINNED** @sha256:c66842... (P22) |
| python:3-alpine (flow-relay) | R | **PINNED** @sha256:a13215... (P22) |
| registry.community.greenbone.net/community/{vulnerability-tests, notus-data, scap-data, cert-bund-data, dfn-cert-data, data-objects, report-formats, gpg-data} | F | exception (feed images, float by design) |
| registry.community.greenbone.net/community/{openvas-scanner, ospd-openvas, gsad, gsa, pg-gvm, pg-gvm-migrator, gvm-config, gvm-tools, nginx, redis-server}:stable/latest | V | exception (vendor stable channel) |
| ghcr.io/misp/misp-docker/misp-modules:latest | V | exception (sidecar; pin next release) |
| balabit/syslog-ng:latest | V | exception (helper; pin next release) |
| velociraptor:latest | C | exception (locally built image, not registry) |

## Policy mechanics

- Runtime images (R): must carry `@sha256` -> enforced by checker (violations exit 1).
- Feed (F) / versioned (V) / cache (C): listed in `ops/config/unpinned-image-exceptions.txt` ->
  warn only (exit 0).
- Pinned digests captured from the RUNNING containers (no image change, no recreation).

## Verification

- Checker: **0 violations**, 21 exceptions allowed, PASS.
- `docker compose config` resolves with digest refs (RC=0).

## Files

- `ops/reports/phase22-container-image-classification.md` (this)
- `ops/reports/phase22-image-pinning-results.md`
- `docs/CONTAINER-IMAGE-POLICY.md`

## No secrets