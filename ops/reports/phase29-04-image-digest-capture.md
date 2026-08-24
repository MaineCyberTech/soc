# Phase 29 Image Digest Capture

Date: 2026-08-24
Method: `docker buildx imagetools inspect` (registry manifest digests) 2026-08-24.

## Resolved digests (mutable refs)

| Ref | Registry manifest digest | Running ID | Compose current | Verdict |
|---|---|---|---|---|
| tenzir/tenzir:main | sha256:fff163ce... | 5dc1dbd43857 | `tenzir/tenzir:main` | PIN fff163ce |
| thinkst/opencanary:latest | sha256:c374c68b... | 07bf63d835c9 | `:latest@sha256:db6bf96d...` | PIN c374c68b (fix stale pin) |
| balabit/syslog-ng:latest | sha256:8f6fe389... | f10b2331efe5 | `:latest` | PIN 8f6fe389 |
| python:3-alpine | sha256:05b2b8b7... | d72efe4a0d6f | `python:3-alpine` | PIN 05b2b8b7 |
| shuffle-backend:latest | sha256:d4a5d2bf... | e5a9c7b0a7f0 | `@sha256:d4a5d2bf...` | ALREADY PINNED (compose) |
| shuffle-frontend:latest | sha256:4d700a6f... | a8cfa786c84a | `@sha256:4d700a6f...` | ALREADY PINNED (compose) |
| shuffle-orborus:latest | sha256:5c300bcb... | ec1b8df1131a | `@sha256:94e61e79...` | PIN 5c300bcb (compose pin stale) |
| shuffle-worker:latest | sha256:fd0d420a... | 17dbe56c9f57 | env `:latest` | PIN fd0d420a |

## Provenance

- All from trusted upstream registries (docker.io, ghcr.io, tenzir).
- Swarm runtime images (backend/frontend/orborus/worker) run with `:latest` despite compose
  pins - swarm services were deployed from an older/different config; pinning must be
  applied to the swarm service definitions on approval.

## Ambiguity

- No multi-arch ambiguity (all amd64); mismatch running-vs-pin documented per image
  (drift is expected; pin freezes registry resolution at apply time).

## No secrets