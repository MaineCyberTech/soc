# Phase 34 Ruleset Age Alert Wiring

Date: 2026-08-25

## Implementation
- Source: /var/lib/suricata/rules/ (generated rules file)
- Check: file age > 7 days OR suricata-update last run > 7 days
- Threshold: rules older than 7 days = DEGRADED
- Evidence: 529 rules loaded, last reload 2026-08-25T00:21Z (fresh)
- Failed rules: 15 (investigated, some expected from ET defaults)

## Current state
- Rules: 529 loaded / 15 failed / 0 skipped
- Last reload: 2026-08-25T00:21Z (17h ago, within 7d window)
- Ruleset source: ET Open via suricata-update (544 total, 529 active)

## Runbook
- Run suricata-update manually
- Check ET source availability
- Investigate failed rules

## No secrets
