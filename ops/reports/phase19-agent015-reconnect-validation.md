# Phase 19 Agent 015 Reconnect Validation

Date: 2026-08-18
Status: **NOT VALIDATED - agent still disconnected, fix pending Mac-side apply**

## Current state

| Check | Result | Evidence |
|---|---|---|
| Agent 015 status | **disconnected** | lastKeepAlive 2026-08-18 09:04 UTC |
| Duration offline | ~12.5h+ | API lastKeepAlive vs preflight 21:33 UTC |
| Other agents | 7 active (000/006/007/008/011/012/014) | API |

## Pass criteria (to be re-checked after Mac fix applied)

- Agent 015 status `active` and lastKeepAlive within last 5 min.
- Continuous uptime: no repeat disconnect within 24h window.
- Agent restart event logged (wazuh-agent location) exactly once at apply time.

## How to re-validate (command, no secrets)

```bash
# Wazuh API agent status
# expect: 015 Julians-Air active
# Query: indexer wazuh-alerts-*, agent.id=015, location=wazuh-agent, last 24h -> expect
#   a single restart event at fix time, no further disconnect patterns
```

## Decision

- **Before fix: FAIL** (agent offline since 09:04 UTC).
- After fix applied by operator: re-run this check -> PASS expected within 2 min of `wazuh-control restart`.

## No secrets