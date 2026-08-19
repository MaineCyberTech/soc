# Phase 21 Agent 015 Volume Validation

Date: 2026-08-19
Status: **BEFORE-FIX BASELINE** (agent offline, fix blocked on Mac access).

## Pre-fix volume

| Day | Archive docs (015) |
|---|---|
| 08-16 | 1,387,891 (flood) |
| 08-17 | 1,195,709 (flood) |
| 08-18 | 308,130 (until 09:04 disconnect) |
| 08-19 | ~0 (offline) |

## Post-fix targets

- 15 min after restart: < 3,000 docs; 1h: < 10K; 24h: <= 50K/day (>=95% drop).

## Verdict

- **FAIL (pre-fix)**. Re-validate after operator applies the bounded config.

## No secrets