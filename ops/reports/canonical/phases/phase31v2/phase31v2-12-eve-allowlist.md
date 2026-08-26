# Phase 31v2 EVE Event Allowlist

Date: 2026-08-24
- eve.json types: **alert + stats only** (metadata yes, tagged-packets no, deltas no).
- stats events are for freshness/observability; they must NOT route to Wazuh as alerts.
- Wazuh ingest collects eve.json but routes alerts only (decoder verified - agent 016 SCA
  events were CIS baseline, not suricata misclassification).

## No secrets
