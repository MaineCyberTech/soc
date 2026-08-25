# Phase 37-20: Packet Validation Design

**Date:** 2026-08-25
**Status:** DESIGN
**Owner:** 39dd09d3

## Purpose

Validate required fields in normalized packet events before routing. Events missing required fields are rejected and routed to the malformed branch.

## Required Fields

| Field | Type | Validation |
|---|---|---|
| `timestamp` | string | Present, non-empty, parseable as ISO8601 |
| `agent_id` | string | Present, non-empty |
| `event_type` | string | Present, non-empty |

## Rejection Behavior

On validation failure:
1. Route event to **malformed branch** (see phase37-25)
2. Log rejection with reason and original payload (truncated)
3. Increment `rejected_count` metric
4. **Fail closed:** rejected events never reach routing, dedup, or counter logic

## Metrics

| Metric | Description |
|---|---|
| `validated_count` | Events passing validation |
| `rejected_count` | Events failing validation |

## Bounded Rejection Threshold

- **Max rejections per day:** 1,000 (configurable)
- **On threshold exceeded:** Operator notification via test group
- **Purpose:** Prevent silent malformed floods from filling queues without operator awareness

## Fail-Closed Guarantee

```
Event received
  → Normalize
  → Validate required fields
    → FAIL → malformed branch, log, counter, STOP
    → PASS → proceed to dedup check
```

No event bypasses validation. No malformed event reaches routing, dedup, or IRIS.

## No secrets
