# Phase 24 Flow and Zeek Dashboards

Date: 2026-08-22
Status: **SOURCE-OF-TRUTH DEFINITIONS CREATED** (no new auto-routing; visual/monitoring only).

## 1. Definitions

- `reporting/queries/dashboards/zeek-detections-dashboard.json` - panels:
  volume by rule (122000-122006), Class A (SSH/SMB/RDP) events, top sources/destinations,
  protocol split, 1h rate.
- `reporting/queries/dashboards/netflow-health-dashboard.json` - panels:
  flow volume (1h), top source /24 (unknown-subnet watch), exporters, top destination /24,
  locality split.

## 2. Purpose

- Monitoring/situational awareness for packet/flow health and Zeek detections.
- **No auto-routing** - routing stays Class A approval-gated (C3).

## 3. Usage

- Load definitions in the Wazuh dashboard (OpenSearch Dashboards) or via the saved-searches
  mechanism; run queries against the alert/flow indices documented.

## 4. Note

- Builds on the P19 "flow + zeek dashboards" roadmap item - source-of-truth definitions now
  exist; UI wiring optional.

## No secrets