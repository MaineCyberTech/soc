# Sysmon Dashboard Readiness

Date: 2026-08-11
Status: **BACKLOG READY - dashboards pending first Sysmon data**

## Acceptance

- Backlog exists: YES (dashboard backlog + saved search backlog + report template)
- No dashboards created until data field names confirmed: CONFIRMED (deferred by design)

## Prereq for building

1. Windows pilot VM provisioned (PVE unblock).
2. Sysmon events landing in wazuh-archives (validation results).
3. Confirm data.win.eventdata.* field names from real docs.
4. Then build P1-P8 + S1-S6 + report template filled.
