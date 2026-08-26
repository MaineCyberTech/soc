# Phase 18 mct-portal Redis Loop Fix

Date: 2026-08-17

## Status: NOISE REDUCED - OWNER TRACKED (not fully fixable from stack)

## Finding

- Rule 120537: 2,548/24h (constant ~430/hr), level 5.
- Source: agent 007 (mct-portal-dev VPS, 138.197.105.82).
- Error: `getaddrinfo EAI_AGAIN redis` - app cannot resolve "redis" hostname
  (DNS failure in portal container network).

## Action taken

- Rule level lowered 5 -> 3 (noise reduction; still visible for monitoring).
- Root cause owner path documented (below).

## Owner path (portal VPS - outside stack SSH)

1. SSH to mct-portal-dev (138.197.105.82) - operator credentials.
2. Check redis service: `docker ps | grep redis` / `systemctl status redis`.
3. Check app->redis DNS: container network `docker network ls`;
   verify "redis" hostname resolves (docker DNS).
4. Fix: restart redis container OR align app REDIS_HOST env to service name.

## Rationale

- EAI_AGAIN = transient DNS failure, NOT a security event.
- Level 3 keeps it visible in dashboards without alert fatigue.

## Files

- ops/reports/phase18-rule-120537-noise-review.md (created)

## No secrets
