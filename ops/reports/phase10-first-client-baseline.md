# Phase 10 First Client Baseline (Internal Reference)

Date: 2026-08-15
Status: External client baseline pending client engagement. Internal pilot
        baseline captured as the reference template.

## Internal pilot baseline (reference for first client)

| Metric | Value |
|---|---|
| Endpoints monitored | 6 agents active (006, 007, 008, 011, 012, + master 000) |
| Linux pilot (VM 204 / agent 011) | Active, verify PASS |
| Alerts (24h) | ~118k total (production stack) |
| Agent 011 alert share | 241 (2.2%) |
| Alert levels (24h) | lvl4: 50k, lvl6: 38k, lvl5: 37k, lvl3: 9k, lvl10: 4k, lvl12: 322 |
| Indexer cluster | green |
| Backup freshness | PASS (except weekly config log - runs Sun) |
| DR snapshots | 35 S3 + 42 local |

## Client baseline template (when engaged)

1. Agent coverage: N endpoints / N active (target 100%).
2. Alert baseline: 7-day average by level (compare monthly).
3. Vulnerability baseline: first Greenbone Discovery scan (authorized).
4. Endpoint health: FIM baseline complete, syscollector inventory.
5. Onboarding summary + 30-day scorecard cycle start.

## No secrets

No secret values printed.
