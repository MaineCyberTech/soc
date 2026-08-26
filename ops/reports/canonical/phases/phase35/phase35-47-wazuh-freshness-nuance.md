# Phase 35: Wazuh/EVE Freshness Semantics

Date: 2026-08-25

## Eve freshness
- `eve-fresh` state on sensor: **HEALTHY**
- eve.json last modified: current (actively writing)
- eve.json line count: 1,125+ (stats events every 5s)
- Kernel drops: 0

## Wazuh logcollector
- eve.json: events=14, bytes=109,802 (since last agent start)
- eve-alert.json: events=1, bytes=666 (since last agent start)
- Both monitoring active and forwarding

## Analysisd
- events_received: 895,501
- events_dropped: 0
- "Too many fields" errors from stats records (522 fields > 256 limit) — non-fatal

## Freshness guarantees
- eve.json: real-time (5s stats interval)
- eve-alert.json: on-demand (only when Suricata generates alerts)
- Agent forwarding: near-real-time (no significant latency observed)
- Alert indexing: <60s end-to-end (canary measured)

## No secrets
