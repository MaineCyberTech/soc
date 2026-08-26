# Phase 35: Shuffle Malformed Branch

Date: 2026-08-25

## Status: BLOCKED — requires Shuffle workflow creation via UI

## Design (for Phase 36 execution)
- **Reject**: Events missing required fields (rule.id, agent.id, timestamp, rule.description)
- **Preserve**: Store rejected event in datastore with `MCT_MALFORMED_` prefix for audit
- **Metrics**: Increment malformed counter per rejection reason
- **Prohibit**: Malformed events never reach routing or IRIS case creation
- **Evidence**: Each malformed event stored with timestamp + reason + original data (redacted)

## Required fields
- rule.id (integer)
- agent.id (string)
- timestamp (ISO 8601)
- rule.description (string)
- location (string — must be in allowlist: eve.json, eve-alert.json)

## Current state
- No malformed-handling workflow exists
- All events currently pass through Wazuh analysisd (which validates JSON structure)
- A malformed event from Suricata stats (522 fields) triggers "Too many fields" error but still reaches archives — this is analysisd behavior, not Shuffle

## Recommendation
Implement in Phase 36 as part of the Shuffle workflow suite.

## No secrets
