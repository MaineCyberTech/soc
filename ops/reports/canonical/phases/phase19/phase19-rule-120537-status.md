# Phase 19 Rule 120537 Status

Date: 2026-08-18

## Rule

`120537` - mct-portal application log warning/error (`decoded_as` json, pcre2 on
`"level":40|50|60` / `"msg":...warn|error`), group `mctportal`.

## Current level

- **Running** (master container `local_rules.xml`): **level 3** - "noise-reduced P18: Redis
  DNS loop owner-tracked".
- **Repo** `/opt/wazuh-docker/multi-node/config/wazuh_cluster/etc/rules/local_rules.xml`:
  **level 5** - DRIFT (reconciled in Phase 19, see below).

## Volume

| Period | Count |
|---|---|
| 08-11 | 1,072 |
| 08-12 | 10,425 |
| 08-13 | 10,387 |
| 08-14 | 10,380 |
| 08-15 | 10,428 |
| 08-16 | 11,024 |
| 08-17 | 10,332 |
| 08-18 (to 21:30) | 9,323 |

Constant ~10K/day. No improvement since Phase 18.

## Sample (live)

`getaddrinfo EAI_AGAIN redis` / `BullMQ worker error` from container `b90cc0ee2366`
(agent mct-portal-dev 007) - Redis DNS loop root cause unchanged.

## Phase 19 actions

1. **Reconciled repo drift**: repo `local_rules.xml` updated to level 3 to match running
   config (backup: `ops/backups/local_rules.xml.phase19-20260818.bak`). This closes the
   P18 gap where the documented downgrade was never committed to the repo.
2. **Decision recorded**: restore level 5 only after VPS-side Redis/DNS fix verified
   (0-10 events/24h for 48h). Owner: portal VPS admin.

## No secrets