# Phase 22 Agent 015 Volume and Queue Validation

Date: 2026-08-22
Status: **BEFORE-FIX BASELINE** (agent offline, repair blocked).

## Volume

| Day | Archive docs (015) | Notes |
|---|---|---|
| 08-16 | 1,387,891 | flood |
| 08-17 | 1,195,709 | flood |
| 08-18 | 308,130 | until 09:04 disconnect |
| 08-19..08-22 | ~0 | offline |

## Queue

- Flood-era queue-full ~204/24h (P18); currently silent (offline).

## Validation plan (post-repair)

- 15m < 3K, 1h < 10K, 24h <= 50K; 0 queue-full; bounded events present; keepalive continuous.

## Verdict

- **FAIL (pre-repair)**. Re-validate after operator applies the bundle.

## No secrets