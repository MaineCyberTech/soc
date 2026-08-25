# Phase 32 Suricata-Update Governance

Date: 2026-08-25
- suricata-update 1.3.4 manages: sources, enable.conf, disable.conf, modify.conf, thresholds.
- Default enable state = 544 (safe subset); NO wholesale ET activation (safety).
- Update cadence: manual/scheduled with config gate + drift check; rollback = restore prior
  suricata.rules (suricata-update backs up).

## No secrets
