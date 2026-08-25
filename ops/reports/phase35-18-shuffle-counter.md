# Phase 35: Shuffle Native Daily Counter

Date: 2026-08-25

## Status: BLOCKED — requires Shuffle workflow creation via UI

## Design (for Phase 36 execution)
- **Persistent count**: Shuffle datastore daily counter key `MCT_COUNTER_YYYY-MM-DD`
- **Route limit**: 20/day (configurable)
- **Notification**: When count reaches 80% (16/day), send operator notification
- **Suppression**: When count reaches limit (20/day), suppress all routing
- **Reset**: Automatic via TTL (24h) or manual override
- **Test isolation**: Counter keys prefixed `MCT_P35_`
- **Override**: Operator can manually reset via datastore edit

## Current state
- No counter workflow exists
- No datastore entries for MCT_COUNTER
- All 2 of today's rule 86601 alerts are uncontrolled (observe-only)

## Recommendation
Implement in Phase 36 after dedup workflow is live.

## No secrets
