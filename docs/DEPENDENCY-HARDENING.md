# Dependency Hardening (Docker Digest Pinning)

Date: 2026-08-16 (Phase 15)

## Status: DIGESTS CAPTURED - compose pinning in progress

## Policy

- Every compose `image:` reference should pin a digest:
  `image: dfir-iris/dfir-iris@sha256:...`
- `latest` tags are NOT reproducible - pin after upgrade decision.
- Pinning workflow: verify running digest -> update compose -> recreate.

## Current deployed digests (2026-08-16, from running containers)

| Image (compose ref) | Running digest |
|---|---|
| dfir-iris/dfir-iris:latest | ghcr.io/dfir-iris/iriswebapp_app@sha256:d7d23026bdde593278075821d3abc8649fe28d618d5784cc9875bd7a3d05699b |
| dfir-iris (db) | ghcr.io/dfir-iris/iriswebapp_db@sha256:081ad194332887ca584a9240e8e9dea94129a235e8b38ff42c1938358be432f5 |
| dfir-iris (nginx) | ghcr.io/dfir-iris/iriswebapp_nginx@sha256:887b1eb8ceae5b1e1483a4a7601d79a6b070e314db5772a617e0a9190c556644 |
| shuffle-backend:latest | ghcr.io/shuffle/shuffle-backend@sha256:d4a5d2bf1f956955b68b099ba1c38997e4b257b2518215e0427f433515bea5c8 |
| shuffle-frontend:latest | ghcr.io/shuffle/shuffle-frontend@sha256:4d700a6f0822cb081822bd2fa6c633080553bdd4313aed2c4bdce75b87e82836 |
| shuffle-orborus:latest | ghcr.io/shuffle/shuffle-orborus@sha256:94e61e7916aea28351fce3851f26f14fb85204f1567a8807d137321418366dba |
| shuffle-worker | ghcr.io/shuffle/shuffle-worker@sha256:fd0d420a5e0cd41f3979335e51912e8dd423e7ce540d1dfa24efdc98fb6071bd |
| cloudflared | cloudflare/cloudflared@sha256:e39ee8da81ad5e05d77f38d2f51c60ca51bf2a8450ac3abab50c17fdb91d91bf |
| elastiflow/flow-collector | elastiflow/flow-collector@sha256:c668429f354f0dcd705d7d4668915896cf369710d3e9aed3ef8143f1b5673eb2 |
| thinkst/opencanary:latest | (capture on next restart; container running) |
| Greenbone images (19) | registry.community.greenbone.net/* (capture on VM103) |
| misp-core/modules:latest | ghcr.io/misp/misp-docker/* (capture on VM103) |

## Pinning procedure (per image)

```bash
# 1. Get digest of the RUNNING image
docker inspect --format '{{index .RepoDigests 0}}' <image>

# 2. Update compose: image: <name>@<digest>

# 3. Recreate + verify
docker compose -f compose/<file>.yml up -d <service>
# verify healthcheck + integration
```

## Priority

1. IRIS + Shuffle (active SOAR/DFIR - already running digests captured above).
2. MISP + Greenbone (VM103 - capture next maintenance window).
3. OpenCanary + valkey + pinned tags (already versioned - low risk).

## Backlog

- Apply digest edits to compose files (approval + recreate window).
- Add digest verification to CI (compose image refs must include @sha256).

## No secrets

No secret values printed.
