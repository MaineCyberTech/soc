# Phase 16 Docker Digest Pinning Results

Date: 2026-08-16

## Status: 6 IMAGES PINNED (no service recreation needed)

## Pinned (digests = currently running images)

| Compose | Image | Digest (sha256:...) |
|---|---|---|
| dfir-iris | iriswebapp_app | d7d23026... |
| shuffle | frontend | 4d700a6f... |
| shuffle | backend | d4a5d2bf... |
| shuffle | orborus | 94e61e79... |
| misp | misp-core | 0eaa4e42... |
| greenbone | gvmd | cb82c501... |

## Validation

- Compose YAML parses (all 4 files).
- Pinned digests verified = running images -> NO recreate required (zero risk).
- Remaining unpinned: 29 refs (greenbone data/feed images, versioned DB images
  alpine/mariadb/postgres/redis/valkey/opensearch, opencanary, velociraptor-
  deprecated compose).

## Backlog

- Pin remaining 29 (mostly already versioned tags - lower priority).
- CI check added (P16.09).

## No secrets
