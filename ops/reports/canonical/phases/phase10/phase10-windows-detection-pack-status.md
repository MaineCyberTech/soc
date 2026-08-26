# Phase 10 Windows Detection Pack Status

Date: 2026-08-15

## Status: BACKLOG CREATED (12 detections, 10 saved searches, 8 dashboards)

## What's ready vs pending

| Item | Status |
|---|---|
| Detection backlog (D1-D12) | CREATED (not deployed - measurement first) |
| Saved searches (S1-S10) | CREATED (build in dashboard) |
| Dashboard backlog (W1-W8) | CREATED (W1/W2 buildable now) |
| Sysmon telemetry baseline | COMPLETE (24k events/day, EID profile) |
| Archive visibility | COMPLETE (caught up) |
| PowerShell script block logging | NOT enabled (D5/D6 pending) |
| Threat feed for D12 | NOT present |

## Deployment plan

1. Build W1 + W2 dashboards (data ready).
2. Enable PS ScriptBlockLogging on pilot -> measure EID 4104 volume.
3. Deploy D1-D4 + D7 + D10 to pilot only -> measure 7 days.
4. Promote measured rules to windows-clients group.
5. No high-volume alerting without measurement (safety).

## No secrets

No secret values printed.
