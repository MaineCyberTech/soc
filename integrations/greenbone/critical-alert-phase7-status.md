# Critical Alert Phase 7 Status

Date: 2026-08-12
Status: **CONFIG PENDING (operator GSA action)**

## Definition (ready)

- Name: MCT-critical-to-shuffle
- Condition: severity >= 9.0
- Method: HTTP POST -> Shuffle webhook
  (wazuh-high-severity trigger 24636c49-a2d0-40c2-887e-ccecdf22fc5c)
- Payload: d5-final-test-payload.json fields

## Verify after creation

1. GSA -> Alerts -> Test.
2. Shuffle UI -> Runs -> FINISHED.
3. IRIS alert created (critical-vulnerability template).

## Fallback

- Static title + raw payload (shuffle-templating-degraded tag).
