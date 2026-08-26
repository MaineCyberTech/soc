# Phase 37-23: Daily Counter Design

**Date:** 2026-08-25
**Status:** DESIGN
**Owner:** 39dd09d3

## Purpose

Track daily event volumes with separate synthetic and real counters to enforce thresholds and trigger operator notifications.

## Persistent Counters

| Counter | Scope | Storage |
|---|---|---|
| `synthetic_count` | Daily synthetic events | Shuffle datastore |
| `real_count` | Daily production events | Shuffle datastore |

Both counters persist across workflow executions and survive restarts.

## Threshold

- **Default:** 100 synthetic events/day (configurable)
- **On threshold exceeded:** Stop routing synthetic events, notify operator
- **Purpose:** Prevent unbounded test volume from consuming resources

## Suppression Behavior

```
synthetic_count < 100  → route normally
synthetic_count >= 100 → suppress routing, notify operator
```

Suppressed events are logged but not forwarded to any group.

## Daily Reset

- **Reset schedule:** Daily at 00:00 UTC
- **Method:** Counter set to 0 at UTC midnight
- Counters are independent per day

## Override

- **Operator override flag:** `override_flag` in datastore
- When set, threshold suppression is bypassed
- Override is audited with timestamp and operator ID
- Override persists until explicitly cleared

## External Guardrail Interaction (P33 Cron)

- The P33 cron-based guardrail (`0 3 * * *` host cron, `alert-runner.sh`) is **independent**
- Shuffle-native counters and external guardrail operate on separate thresholds and schedules
- No conflict between the two systems
- Both can coexist safely

## No secrets
