# Phase 37-28: Failure Proof Design

**Date:** 2026-08-25
**Status:** DESIGN
**Owner:** 39dd09d3

## Purpose

Prove that infrastructure failures result in safe behavior: no routing, no case creation, no counter contamination, and automatic recovery.

## Failure Injections

### 1. Datastore Read Failure

**Scenario:** Shuffle datastore read fails during dedup check.

**Expected behavior:**
- No route to test group or production
- No IRIS case creation
- No real-counter change
- No synthetic-counter change
- Event logged with failure evidence
- Operator notified

**Fail-closed:** Without dedup confirmation, the system cannot determine if event is duplicate. Routing is unsafe. Therefore, no route.

### 2. Datastore Write Failure

**Scenario:** Shuffle datastore write fails when recording first-seen dedup key.

**Expected behavior:**
- No route (cannot guarantee dedup state)
- No IRIS case creation
- No counter change
- Operator notified of write failure
- Event logged with failure evidence

**Fail-closed:** Without confirmed write, duplicate events may route on retry. Routing is unsafe. Therefore, no route.

### 3. Counter Failure

**Scenario:** Counter increment fails (datastore error during counter update).

**Expected behavior:**
- Log failure with evidence
- **Continue routing** — counter failure is non-critical for routing safety
- Best-effort counting: routing prioritized over precise metrics
- Operator notified

**Graceful degradation:** Counter accuracy is secondary to alert routing. A failed counter does not prevent legitimate event routing.

## Evidence Fields

| Field | Description |
|---|---|
| `failure_type` | Category: `datastore_read`, `datastore_write`, `counter_increment` |
| `timestamp` | ISO8601 timestamp of failure occurrence |
| `recovery_time` | ISO8601 timestamp of first successful operation after failure |

## Recovery

- **Automatic:** Next successful datastore operation restores normal behavior
- No manual intervention required
- Recovery is tracked via `recovery_time` evidence field
- Operator notified of recovery

## Summary Table

| Failure Type | Route? | Case? | Counter? | Operator Notice |
|---|---|---|---|---|
| Datastore read | No | No | No | Yes |
| Datastore write | No | No | No | Yes |
| Counter increment | Yes (best effort) | No | No | Yes |

## No secrets
