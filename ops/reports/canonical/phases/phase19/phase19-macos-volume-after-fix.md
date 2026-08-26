# Phase 19 macOS Volume After Fix

Date: 2026-08-18
Status: **BEFORE-FIX BASELINE** (fix pending operator apply on Julians-Air)

## Before-fix archive volume (agent 015, measured live)

| Day | Archive docs | Notes |
|---|---|---|
| 08-16 | 1,387,891 | full day |
| 08-17 | 1,195,709 | full day |
| 08-18 | 308,130 | until 09:04 UTC disconnect |

Hourly peak (08-18 00-01 UTC): **127,504 docs/h**.

## After-fix measurement windows

| Window | Target | Metric |
|---|---|---|
| 15 min after restart | < 3,000 docs | archive count agent 015 |
| 1 h | < 10,000 docs/h | hourly archive count |
| 24 h | <= 50,000 docs/day (>=95% drop) | daily archive count |

Bounded predicate expectation: only auth (Authorization/SystemConfiguration), sudo,
loginwindow, securityd events flow -> hundreds-to-low-thousands per day instead of 1.4M.

## Validation query (no secrets)

Indexer `wazuh-archives-*`, filter `agent.id=015`, date_histogram by hour over the 24h
after restart; compare against pre-fix hourly buckets above.

## Decision

- Pre-fix: FAIL (flood confirmed, ~1.4M/day).
- Post-fix: PASS if >=95% reduction and no recovery of flood pattern.

## No secrets