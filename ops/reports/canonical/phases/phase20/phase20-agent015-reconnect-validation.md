# Phase 20 Agent 015 Reconnect Validation

Date: 2026-08-19
Status: **NOT VALIDATED - agent offline** (fix blocked on Mac access).

## Checks

| Check | Result | Evidence |
|---|---|---|
| Agent 015 status | disconnected | lastKeepAlive 08-18 09:04 UTC |
| Offline duration | ~21h+ | preflight 05:44 UTC |
| Group | mac-clients | API (unchanged) |
| Queue-full since reconnect | N/A | no reconnect |
| Wazuh version/local config | unknown remotely; fix not applied | blocked |

## Re-validation procedure (post-fix)

1. API: 015 active, lastKeepAlive < 5 min.
2. Indexer: agent 015 wazuh-agent location - exactly one restart event at fix time, no error cascade.
3. 24h continuous keepalive (no gap > 5 min).
4. No queue-full events (alerts + archives + on-device ossec.log).

## Decision

- **FAIL (pre-fix)**. Re-run after operator applies `integrations/macos/phase20-agent015-final-config.md`.

## No secrets