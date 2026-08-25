# Phase 34 Wazuh Sensor Ingest Freshness

Date: 2026-08-25

## Implementation
- Check: agent 016 events in Wazuh API (last 15min)
- Alert: 0 events for > 30min (excluding eve-alert.json gap)
- Note: agent 016 monitors eve-alert.json (created on-demand)

## Current state
- Agent 016: active, keepalive 17:35Z
- Wazuh events: 0 (eve-alert.json not created = 0 live alerts = correct)
- Ingest path: Suricata -> eve-alert.json -> agent 016 -> Wazuh

## Gap
- Agent 016 does NOT forward eve.json (stats events)
- Only monitors eve-alert.json (alerts only)
- For canary E2E: synthetic trigger must fire an alert

## Runbook
- Add eve.json forwarding to agent 016 ossec.conf (if approved)
- Verify agent 016 enrollment and localfile config

## No secrets
