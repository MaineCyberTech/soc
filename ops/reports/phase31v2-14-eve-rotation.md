# Phase 31v2 EVE Rotation / Governance

Date: 2026-08-24
- logrotate default (/var/log/suricata) bounds eve.json growth (~0.02-1.3MB per ~100K pkts
  measured). No explicit flush interval change (defaults acceptable at current volume).
- Governance: alert-only routing to Wazuh; stats for freshness; no all-event archival.

## No secrets
