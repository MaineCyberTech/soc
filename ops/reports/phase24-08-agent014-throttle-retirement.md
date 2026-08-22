# Phase 24 Rule-11 Throttle Retirement

Date: 2026-08-22
Status: **RETAIN (pre-tune) - retirement criteria defined**.

## Current

- 014: rule-11 throttle active (bounds EID7 flood). 013: flood active (not yet throttled).

## Retirement criteria (post include-oriented tuning on both endpoints)

- EID7 < 2K/day endpoint-side + buffer clean 24h -> **RETIRE** (suppression self-clears; no
  rule change needed).
- Volume still high -> RETAIN + re-tune.
- EID1/10 degraded -> RETAIN + rollback.

## Verification

- No "average number of logs" (rule 11) messages for 48h; archives resume with reduced EID7;
  alert latency normal.

## No secrets