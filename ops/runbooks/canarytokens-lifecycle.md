# Canarytokens Lifecycle

## States

create -> place (record inventory) -> monitor -> triggered -> investigate ->
rotate/expire -> offboard

## Operations

1. Create token (hosted/self-hosted) with webhook -> Shuffle.
2. Record placement in canarytokens-inventory.md BEFORE deploying.
3. Alert response: IRIS case (opencanary-hit, tag source:canarytokens).
4. Maintenance: verify not self-triggered (inventory check).
5. Rotation: annually or after trigger.
6. Offboarding: destroy artifact, revoke token.

## Safety

- Fake artifacts only (no real credentials).
- Alert-only; no blocking.
- Admin training: don't open unknown files/URLs in canary paths.
