# Phase 21 mct-portal Redis Owner Status

Date: 2026-08-19
Status: **OWNER-BLOCKED - NOT FIXED** (unchanged).

## Rule 120537 volume

- **10,000+/24h** (constant ~10K/day). Level 3 (repo + running consistent).
- Root cause unchanged: `getaddrinfo EAI_AGAIN redis` / `BullMQ worker error` from portal
  container (agent 007). Owner: portal VPS admin.

## Owner action (still outstanding)

- Shared Docker network check between app + redis containers; `getent hosts redis`; recreate
  app container on redis network; verify 0 BullMQ errors.

## Decision

- Keep level 3. Restore level 5 only after VPS fix verified (0-10 events/24h for 48h).

## No secrets