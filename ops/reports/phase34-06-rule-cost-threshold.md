# Phase 34 Rule Cost and Threshold Review

Date: 2026-08-25

## Resource cost
- 529 active rules, 74MB memory, ~1.2% CPU
- Rule cost: negligible (well under 2GiB budget)
- 15 rules failed to load (investigated under ruleset-age)

## ET thresholds
- 148 alerts suppressed by ET thresholds (proves engine fires + suppresses correctly)
- Threshold config: /var/lib/suricata/threshold.config (ET defaults)
- No custom thresholds applied

## Detection impact
- Thresholds may suppress some high-frequency rules (research)
- Gate: guardrail is the routing backstop (5/24h limit)
- No threshold changes recommended (observe-only posture)

## No secrets
