# Phase 20 Rule 120537 Status

Date: 2026-08-19

## Rule

`120537` - mct-portal app log warning/error (json decoder), group `mctportal`.

## Level

- Running + repo: **level 3** (drift reconciled in P19; holds).
- Restore to level 5 only after VPS-side Redis/DNS fix verified.

## Volume

| Day | Count |
|---|---|
| 08-17 | 10,332 |
| 08-18 | 9,323 |
| 08-19 (24h to preflight) | 10,379 |

Constant ~10K/day. Redis DNS loop unchanged, owner-blocked.

## Sample

`getaddrinfo EAI_AGAIN redis` / `BullMQ worker error` (agent mct-portal-dev 007).

## No secrets