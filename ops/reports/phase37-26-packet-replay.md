# Phase 37-26: Replay Idempotency Design

**Date:** 2026-08-25
**Status:** DESIGN
**Owner:** 39dd09d3

## Purpose

Prove that duplicate/replayed events are suppressed by dedup logic, ensuring idempotent behavior.

## Test Procedure

1. Submit **3 identical marked events** to webhook `mct-suricata-packet`
2. Each event carries the same `suricata_sid`, `source_ip`, `dest_ip`, `dest_port`, and `hour_bucket`
3. All events arrive within the same hour (same dedup key)

## Expected Results

| Execution | Behavior | Route | Counter Impact |
|---|---|---|---|
| 1st event | First-seen | Routed to test group | `synthetic_count` +1 |
| 2nd event | Duplicate | Suppressed | `dup_counter` +1 |
| 3rd event | Duplicate | Suppressed | `dup_counter` +1 |

**Totals:** 3 executions, 1 route, 2 suppressions

## Dedup Key

```
SHA256(suricata_sid + source_ip + dest_ip + dest_port + hour_bucket)
```

All 3 events produce the same SHA256 key. The first event writes the key to the datastore; subsequent events find the key and are suppressed.

## TTL

- Dedup TTL: 1 hour
- After 1 hour, the same key is eligible for re-routing
- Ensures legitimate recurring alerts are not permanently suppressed

## Real-Counter Contamination

- Synthetic namespace: `mct-soc-test`
- `real_count`: **unchanged** — zero contamination
- `synthetic_count`: incremented only once (1st event)
- `dup_counter`: incremented twice (2nd and 3rd events)

## Proof Requirements

- All 3 webhook calls return 200
- Shuffle execution log shows 3 executions
- Only 1 execution shows route action
- 2 executions show suppression action
- `synthetic_count` = 1
- `dup_counter` = 2
- `real_count` = 0

## No secrets
