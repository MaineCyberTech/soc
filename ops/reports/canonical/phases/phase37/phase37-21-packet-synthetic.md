# Phase 37-21: Synthetic Isolation Design

**Date:** 2026-08-25
**Status:** DESIGN
**Owner:** 39dd09d3

## Purpose

Isolate synthetic test events from production alerting to prevent test data from contaminating production metrics, cases, billing, and scorecards.

## Namespace

- **Namespace:** `mct-soc-test`
- All synthetic events tagged with `tenant: "mct-soc-test"` and `is_synthetic: true`
- Synthetic events are routed **only** to the test group (notify-only)

## Counters

- Synthetic events use **separate counters** from real events
- `synthetic_count`: incremented per synthetic event
- `real_count`: never incremented by synthetic events
- Counter separation prevents test volume from affecting real alerting thresholds

## Routing

| Event Type | Route | IRIS Case | Billing | Scorecard |
|---|---|---|---|---|
| Synthetic | Test group (notify-only) | No | No | No |
| Production | Production routing (future) | Yes | Yes | Yes |

## Retention

- Synthetic events tagged with `is_synthetic: true`
- Retained for **7 days only**
- After 7 days: eligible for cleanup
- Production events follow standard retention (wazuh-archives-14d)

## Marker

The `is_synthetic` field is set during normalization (phase37-19):
- `is_synthetic = true` when event matches approved test SIDs or carries `test_id`
- `is_synthetic = false` for all other events

## Proof of Isolation

After synthetic events flow through the workflow:
- `synthetic_count` incremented
- `real_count` unchanged
- No IRIS cases created
- No billing impact
- No scorecard impact

## No secrets
