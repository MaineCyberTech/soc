# Phase 17 Unpinned Image Exceptions

| Image | Reason unpinned | Risk |
|---|---|---|
| opensearchproject/opensearch:3.2.0 | semver-pinned | LOW |
| mariadb:10.11, postgres:16-alpine, redis:7-alpine, valkey:7.2, alpine:3.20 | semver-pinned | LOW |
| greenbone feed/data images (11) | feeds update regularly by design | LOW (immutable-ish) |
| opencanary:latest | pin next | MED |
| velociraptor:latest | deprecated compose (native binary) | LOW |

## No secrets
