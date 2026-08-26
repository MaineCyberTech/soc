# Phase 21 Rule 120537 Status

Date: 2026-08-19

## Rule

`120537` - mct-portal app log warning/error (json decoder), group `mctportal`.

## Level

- Repo + running: **level 3** (consistent; no drift). Restore 5 after VPS fix.

## Volume

- Constant ~10K/day (10,000+ in last 24h). Owner-blocked (Redis DNS loop on portal VPS).

## Sample

`getaddrinfo EAI_AGAIN redis` / `BullMQ worker error` (agent mct-portal-dev 007).

## No secrets