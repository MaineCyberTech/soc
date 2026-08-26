# Phase 37-27: Counter Test Design

**Date:** 2026-08-25
**Status:** DESIGN
**Owner:** 39dd09d3

## Purpose

Prove daily counter behavior: increment, threshold, suppression, reset, isolation, notification, override, and guardrail independence.

## Test Cases

### 1. Increment on First Event
- Submit 1 synthetic event
- Verify `synthetic_count` increments from 0 to 1
- Verify `real_count` unchanged

### 2. Threshold at 100
- Submit 100 synthetic events (unique dedup keys)
- Verify `synthetic_count` = 100
- Verify all 100 events routed to test group
- Verify `real_count` unchanged

### 3. Suppression Beyond Threshold
- Submit event #101 (synthetic, unique key)
- Verify routing is suppressed
- Verify operator notification triggered
- Verify `synthetic_count` = 101 (counted but not routed)

### 4. Daily Reset at 00:00 UTC
- After threshold test, advance to 00:00 UTC
- Verify counters reset to 0
- Verify next event routes normally
- Verify `real_count` also reset independently

### 5. Test Isolation (Synthetic vs Real)
- Submit 1 synthetic event → `synthetic_count` +1, `real_count` unchanged
- Submit 1 production event → `real_count` +1, `synthetic_count` unchanged
- Prove counters are fully independent

### 6. Notification on Threshold
- When `synthetic_count` hits 100, verify operator notification
- Notification includes: current count, threshold, timestamp, namespace

### 7. Override Audit Trail
- Set `override_flag` = true
- Submit event #101 → verify routing proceeds despite threshold
- Verify override logged with timestamp and operator ID
- Clear override → verify threshold enforcement resumes

### 8. No External-Guardrail Conflict
- P33 cron (`0 3 * * *`, `alert-runner.sh`) runs independently
- Shuffle counter reset and P33 threshold check do not interfere
- Both systems operate on separate schedules and thresholds
- Verify no race conditions or duplicate notifications

## Expected Proof

| Test | Pass Criteria |
|---|---|
| Increment | `synthetic_count` = 1 after first event |
| Threshold | `synthetic_count` = 100 after 100 events |
| Suppression | 101st event not routed, notification sent |
| Reset | Counters = 0 after 00:00 UTC |
| Isolation | Synthetic and real counters independent |
| Notification | Operator notified at threshold |
| Override | Override bypasses threshold, audit logged |
| Guardrail | P33 cron independent, no conflict |

## No secrets
