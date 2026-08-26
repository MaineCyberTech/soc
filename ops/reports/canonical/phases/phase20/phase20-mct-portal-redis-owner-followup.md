# Phase 20 mct-portal Redis Owner Follow-up

Date: 2026-08-19
Status: **OWNER-BLOCKED - NOT FIXED** (portal VPS 138.197.105.82 / agent 007).

## 1. Rule 120537 count

- **10,379 in last 24h** (~10K/day, constant). Unchanged from Phase 19.

## 2. Root cause (re-confirmed)

- Same pattern: `getaddrinfo EAI_AGAIN redis` / `BullMQ worker error` from portal container
  (hostname b90cc0ee2366). Redis service hostname unresolved in the app container.

## 3. Owner / blocker status

- Owner: portal VPS admin (agent 007 host). Blocker unchanged: no VPS access from this session.
- Phase 19 fix steps still valid (shared Docker network check, `getent hosts redis`,
  recreate app container on redis network, verify 0 BullMQ errors).

## 4. Level decision

- **Keep level 3** (noise-reduced) while loop persists. **Restore to level 5** only after VPS
  fix verified (0-10 events/24h for 48h).
- Repo + runtime both at level 3 (no drift).

## No secrets