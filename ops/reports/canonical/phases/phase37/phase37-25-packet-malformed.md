# Phase 37-25: Malformed Event Design

**Date:** 2026-08-25
**Status:** DESIGN
**Owner:** 39dd09d3

## Purpose

Handle events that fail validation (phase37-20) by routing them to a bounded malformed queue with operator notification at threshold.

## Malformed Branch

Events failing required-field validation are routed to `malformed_queue`:
- Timestamp: when rejection occurred
- Error reason: which required field was missing/invalid
- Original payload: truncated to safe limit for debugging

## Evidence Captured

| Field | Description |
|---|---|
| `error_reason` | Specific validation failure (e.g., "missing timestamp") |
| `original_payload` | Raw event payload, truncated for storage safety |

## Threshold

- **Max malformed events per day:** 100 (configurable)
- On threshold exceeded → operator notification
- Prevents silent malformed floods from going undetected

## Recovery

- **Malformed queue drained daily** — events are logged and cleared
- No persistent accumulation
- Drain happens independently of routing

## Fail-Closed Guarantee

```
Malformed event
  → Routed to malformed_queue
  → NEVER routed to test group
  → NEVER routed to production
  → NEVER creates IRIS case
  → NEVER increments real or synthetic counters
```

Malformed events are completely isolated from all routing, dedup, and counter logic.

## No secrets
