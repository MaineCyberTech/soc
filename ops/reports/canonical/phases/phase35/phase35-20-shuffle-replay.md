# Phase 35: Shuffle Replay Idempotency Proof

Date: 2026-08-25

## Status: BLOCKED — requires Shuffle dedup workflow + replay test events

## Design (for Phase 36 execution)
- **Replay**: Send identical marked events twice to the Shuffle workflow
- **Expected**: First event routes (new dedup key), second event suppressed (duplicate key)
- **Evidence**: Dedup counter incremented, route count = 1
- **TTL**: Dedup key expires after 24h
- **Real counter**: No contamination — dedup check happens before counter increment

## Test markers
- MCT_TEST_ID: P35-REPLAY-TEST-001
- MCT_SYNTHETIC: true
- MCT_TEST_ONLY: true

## Current state
- No dedup workflow to test against
- Canary E2E proved Suricata->Wazuh->OpenSearch (prompts 13-15)

## Recommendation
Implement in Phase 36 after dedup workflow is live. Run identical synthetic alert twice, verify one route.

## No secrets
