# Phase 23 Rule-11 Throttle Decision

Date: 2026-08-22
Status: **RETAIN (pre-tune) - retirement criteria defined**.

## Current

- Wazuh rule-11 log-flood suppression active on 014 (EID7 flood agent-side). Throttle bounds
  index impact but hides signal.

## Decision matrix (post 014 tuning)

- EID7 < 2K/24h + buffer clean 24h -> **RETIRE** (suppression self-clears; no rule change).
- Volume still high -> RETAIN + re-tune.
- EID1/10 degraded -> RETAIN + rollback.

## Retirement verification

- No "average number of logs" (rule 11) messages for 48h; archives resume with EID7 volume
  visibly reduced; alert latency normal.

## No secrets