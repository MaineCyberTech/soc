# Phase 20 macOS Volume Validation

Date: 2026-08-19
Status: **BEFORE-FIX BASELINE** (agent 015 offline, fix pending Mac access).

## Pre-fix archive volume (agent 015)

| Day | Archive docs | Notes |
|---|---|---|
| 08-16 | 1,387,891 | flood (P18 measured) |
| 08-17 | 1,195,709 | flood |
| 08-18 | 308,130 | until 09:04 disconnect |
| 08-19 (to 05:44) | ~0 | offline all day |

Peak hourly (flood window): **127,504 docs @ 01:00 UTC** (08-18).

## Post-fix measurement plan

| Window | Target |
|---|---|
| 15 min after restart | < 3,000 docs |
| 1 h | < 10,000 docs/h |
| 24 h | <= 50,000 docs/day (>=95% drop) |

## Verdict

- **FAIL (pre-fix)**. Flood not remediated; agent offline. No volume to compare until fix applied.
- Health for scorecard: macOS 015 telemetry **not usable** until reconnect + bounded config.

## No secrets