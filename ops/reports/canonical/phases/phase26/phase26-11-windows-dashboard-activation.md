# Phase 26 W1/W2 Dashboard Activation

Date: 2026-08-23
Status: **GATED ON POLICY CONFIRMATION** (C1; C5 pending).

## Gate

- Activate W1 (Windows events) / W2 (Sysmon) dashboards only after 013/014 policy confirmed
  (marker) + EID7 quiet 24h.

## Quality-aware requirements

- Dashboards must surface: rule-11 throttle state, policy marker status, buffer health,
  telemetry freshness (lastEvent) - throttled absence must NOT read as health.

## Ready

- Query/dashboard definitions exist (phase24-31 dashboard JSONs + sysmon backlog). Wiring in
  OpenSearch Dashboards pending gate.

## No secrets