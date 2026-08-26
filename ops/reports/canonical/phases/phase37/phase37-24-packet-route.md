# Phase 37-24: Test-Group Routing Design

**Date:** 2026-08-25
**Status:** DESIGN
**Owner:** 39dd09d3

## Purpose

Route approved synthetic Suricata alerts to a test group for notification-only observation. Production alerts are observed but not routed during test mode.

## Route Rules

| Condition | Route | IRIS Case |
|---|---|---|
| Approved synthetic SID + explicit test event | Test group (notify-only) | No |
| Production SID | Observe-only, no route | No (test mode) |

## Approved Synthetic SIDs

- **2027967** — sole approved SID for test routing
- Events matching this SID AND carrying `is_synthetic: true` are eligible for routing

## SID Allowlist Check

Before routing, every event passes through the SID allowlist:
1. Extract `suricata_sid` from normalized event
2. Check against approved SID list (`[2027967]`)
3. If SID is in allowlist AND event is synthetic → proceed to route
4. If SID is not in allowlist → observe-only, no route

## IRIS Case Policy

- **No IRIS case creation** for any event in test mode
- Applies to both synthetic and production SIDs
- IRIS integration remains available for future production mode

## Validation

- SID allowlist is checked after dedup (phase37-22) and before routing
- Invalid or unexpected SIDs are logged at observe-only level
- No silent drops — all decisions are logged

## Future Production Mode

When production routing is enabled:
- Production SIDs will route to production group
- IRIS case creation will be enabled for production events
- Synthetic SIDs remain test-only regardless of mode

## No secrets
