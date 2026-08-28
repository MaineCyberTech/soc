# Phase 46: Malformed Event

## Test Configuration
- Workflow: e133a645-95b9-4e01-9454-e270d2a0b599
- Method: Execute API (POST /api/v1/workflows/{id}/execute)
- Auth: Bearer 8666b153-16b7-423a-b430-048c33404888

## Test Event
```json
{"data":"{\"timestamp\":\"2026-08-27T06:00:00Z\"}"}
```

## Expected Result
DEADLETTER-malformed (missing required fields)

## Actual Result
Missing sid → malformed

## Evidence
Phase 45-35

## Verification
- [x] Test documented
- [x] Result matches expectation

---
*Generated: 2026-08-27T06:32:00Z (UTC) / 2026-08-27T02:32:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
