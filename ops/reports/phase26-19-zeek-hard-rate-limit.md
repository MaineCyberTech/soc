# Phase 26 Zeek Hard Rate Limit

Date: 2026-08-23
Status: **IMPLEMENTED + TESTED** (stack-level guardrail; threshold branch = kill switch).

## Implementation

- `ops/scripts/zeek-classa-guardrail.sh` (cron every 15 min):
  - Counts workflow executions (FINISHED) for eb937a37 in the last 24h via Shuffle API.
  - `COUNT >= 5` -> comments the Wazui Zeek Class A integration block (kill switch),
    restarts the master container, logs to `zeek-classa-guardrail-state.log`.
  - Manual modes: `disable` / `enable`.
  - Sources creds from .env + creds.env (no hardcoded values).

## Threshold branch

- >= 5 posts/24h: route disabled + state log entry (operator notification required -
  email hook staged for Phase 27).

## Fail-safe

- Counting failure (API error) returns -1 -> treated as 0 (no false kill); integration state
  re-checked each cycle.

## Test

- Kill-switch mechanism verified end-to-end (disable comments live config + analysisd -t rc=0;
  enable restores). See phase26-20.

## No secrets