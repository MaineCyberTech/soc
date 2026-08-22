> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 7 Scorecard Generation Status

Date: 2026-08-12

## Generated

- reporting/output/client/phase7-client-ready-scorecard.md - LIVE (2,085,268 alerts/30d, Class A 452, agents 4/4, canary 10)
- reporting/output/client/phase7-sample-external-scorecard.md - template with placeholders for first external client
- reporting/output/internal/phase7-alert-quality-snapshot.md - LIVE alert quality

## Acceptance

- Client-ready report exists: YES
- No secrets/sensitive internals: VERIFIED
- Executive summary non-technical: YES

## Data sources

- Wazuh alerts (live query), agent_control, canary counts, backup audit.
