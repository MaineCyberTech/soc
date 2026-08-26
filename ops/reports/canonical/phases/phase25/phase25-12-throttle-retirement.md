# Phase 25 Rule-11 Throttle Retirement

Date: 2026-08-22
Status: **RETAIN - per-endpoint retirement criteria defined** (C1 gate).

## Criteria (per endpoint, independently)

| Endpoint | Retire when |
|---|---|
| 014 | EID7 < 2K/day AND buffer clean 24h AND load confirmed (marker) |
| 013 | EID7 < 2K/day AND buffer clean 24h AND load confirmed (marker) |

## Retirement mechanism

- Wazuh rule-11 suppression self-clears when log volume normalizes - no rule change required.
- Verify: no rule-11 "average number of logs" messages for 48h; archives resume with reduced
  EID7; alert latency normal.

## Rollback

- If EID7 volume returns, throttle re-engages automatically; re-apply tuning + investigate.

## Decision

- **RETAIN** (both endpoints still in flood-risk posture until validated).

## No secrets