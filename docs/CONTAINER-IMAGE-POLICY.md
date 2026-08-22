# Container Image Policy

Applies to all compose roots: `/opt/mct-security-stack/compose` and
`/opt/wazuh-docker/multi-node`. Effective Phase 22.

## Classification

| Category | Meaning | Policy |
|---|---|---|
| **R - runtime-pin** | application runtime images | MUST carry `@sha256` digest in compose |
| **F - feed-tracking** | vendor feed/data images (Greenbone feeds) | floating allowed by design; re-verified each release |
| **V - versioned-exception** | versioned/stable tags or sidecars | tag allowed, documented; pin when next image change occurs |
| **C - cache-only** | locally built / cache-delivered images | not registry; documented |

## Enforcement

- `ops/scripts/check-unpinned-docker-images.sh` scans BOTH compose roots.
- Images not in the allowed baseline (`alpine/mariadb/postgres/redis/valkey/opensearchproject/wazuh`) and not `@sha256`-pinned are checked against `ops/config/unpinned-image-exceptions.txt`.
- **Violations (unclassified unpinned)**: exit 1 -> local CI + GitHub CI FAIL.
- **Classified exceptions (F/V/C)**: warn only, exit 0.

## Exceptions list

`ops/config/unpinned-image-exceptions.txt` (one `image category` per line). Adding a new
exception requires: classification rationale + this policy review. Removing an exception makes
the image a hard violation until pinned.

## Rotation guidance

- When any runtime image is next pulled for update, pin the new digest at the same time.
- Greenbone feeds: keep floating (vendor model), document the feed update cadence.

## Verify

```bash
bash ops/scripts/check-unpinned-docker-images.sh   # expect PASS, 0 violations
```

## No secrets