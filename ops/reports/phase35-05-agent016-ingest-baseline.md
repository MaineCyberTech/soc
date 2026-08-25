# Phase 35 Agent 016 Ingest Baseline

Date: 2026-08-25

## Baseline
- eve.json: 1125 lines, 19 events forwarded to Wazuh (stats)
- eve-alert.json: 0 lines, 0 events (no alerts fired)
- Wazuh API events: 0 (stats events don't match rules - expected behavior)
- Agent 016: active, logcollector monitoring both files

## Semantics
- eve.json forwarding: PROVES agent is alive and collecting
- eve-alert.json: CREATED ON-DEMAND when alerts fire
- Wazuh events=0: CORRECT for 0-alert profile (stats don't match rules)
- For canary: alert will create eve-alert.json entry -> agent forwards -> Wazuh indexes

## Baseline: HEALTHY

## No secrets
