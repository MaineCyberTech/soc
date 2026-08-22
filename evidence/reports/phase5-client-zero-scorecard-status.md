> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 5 Client Zero Scorecard Status

Date: 2026-08-11

## Generated

- reporting/output/client/client-zero-scorecard.md - LIVE data (1,957,691 alerts/30d, Class A 448, agents 4/4, canary hits 11)
- reporting/output/client/client-zero-vulnerability-review.md - LIVE alert quality summary

## Acceptance criteria

- Scorecard exists: YES (live data)
- Client-safe formatting: YES (plain language, no internal tool internals, no secrets)
- No secrets: VERIFIED (auth via env only; report contains metrics only)

## Data sources used

- Wazuh alerts index (live query)
- agent_control (4 active agents)
- Canary hits (rule 1210xx counts)
- Backup freshness (PASS)

## Gaps noted in scorecard

- IRIS case count API path not yet wired (would use /api/v1/cases - endpoint path varies by IRIS build; 0 incidents stated from triage)
- Vulnerability count 0 = pre-scan (first Greenbone scan pending)
