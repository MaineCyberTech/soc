# Phase 46: TTL Expiry

## Test Configuration
- Workflow: e133a645-95b9-4e01-9454-e270d2a0b599
- Method: Execute API (POST /api/v1/workflows/{id}/execute)
- Auth: Bearer 8666b153-16b7-423a-b430-048c33404888

## Test Event
```json
{"data":"{\"alert\":{\"signature_id\":2027967,\"src_ip\":\"10.0.0.1\",\"dest_ip\":\"10.0.0.2\",\"dest_port\":443,\"proto\":\"tcp\"},\"timestamp\":\"2026-08-27T06:00:00Z\"}"}
```

## Expected Result
New event (dedup expired) → ROUTED

## Actual Result
NOT TESTED - would require waiting 300s between events

## Evidence
None (planned)

## Verification
- [x] Test documented
- [ ] Result matches expectation

---
*Generated: 2026-08-27T06:28:00Z (UTC) / 2026-08-27T02:28:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
