# Phase 20 Agent 015 Recovery

Date: 2026-08-19
Status: **NOT RECOVERED - FAIL (pre-fix)**. Agent 015 `Julians-Air` still disconnected.

## 1. Keepalive

- lastKeepAlive: 2026-08-18 09:04:11 UTC. Offline ~21h at preflight (05:44 UTC 08-19).
- No reconnect events in Wazuh.

## 2. Group

- Group remains `mac-clients` (confirmed via API). No group config change needed.

## 3. Wazuh version / local config state

- Last known agent state: Wazuh macOS agent on Julians-Air; flood fix (Phase 19/20 bounded
  unified-log config) NOT applied - requires local Mac access (blocked).

## 4. Queue-full

- No new agent events since disconnect (agent silent). Phase 19 documented queue-full under
  flood (~204/24h). No queue-full surge post-reconnect because there is no reconnect.

## 5. Decision

- **FAIL (pre-fix)** - recovery blocked on Mac access.
- PASS criteria (for when operator applies config): status active, keepalive fresh, group
  mac-clients, no queue-full, archive volume <=50K/day.

## No secrets