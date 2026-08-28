# Phase 46: Auth Failure Documentation

## Purpose
Document what happens when IRIS authentication fails during workflow execution.

## Findings

### Current Failure State
- **Token used:** `[REDACTED-IRIS-TOKEN]` (placeholder literal)
- **HTTP response:** `401 Unauthorized`
- **Workflow path:** IRIS returns non-200 → `DEADLETTER-target-fail`

### Error Message
```
DEADLETTER-target-fail: IRIS delivery failed sid={sid}, status=401
```

### Behavior
- Event is still logged in the workflow execution
- Not lost — execution record persists in Shuffle
- Failure path is correctly triggered and handled
- No data loss occurs

### Resolution Path
- Fix: Create real auth object (Phase 46-22)
- After fix: IRIS returns 200/201, delivery succeeds

### Regression Risk
- **None** — failure path is correct behavior for invalid credentials
- Tests validate that authentication failure is handled gracefully
- Switching to valid credentials improves the happy path without affecting error handling

## Verification
- [x] 401 response confirmed with placeholder token
- [x] DEADLETTER-target-fail path triggers correctly
- [x] Error message includes sid and status code
- [x] Event logging confirmed (not lost)
- [x] Failure path is correct behavior, not a bug
- [x] No regression risk identified

---
*Generated: 2026-08-27T06:25:00Z (UTC) / 2026-08-27T02:25:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
