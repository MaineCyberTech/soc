# Greenbone Operational Status - Phase 3

Date: 2026-08-11

## What was created

- `ops/runbooks/vulnerability-management.md` - access, scan procedure, report export, exclusions, critical triage.
- `integrations/greenbone/scan-target-groups.md` - 4 target groups (core-infrastructure, cloud, network-appliances, client-like) with members, profiles, windows.
- `integrations/greenbone/scan-window-policy.md` - 5 profiles + schedule windows.
- `integrations/greenbone/critical-finding-workflow.md` - notify/manual mode route to IRIS.
- `reporting/templates/vulnerability-review.md` - monthly review template.

## Status summary

| Item | Status |
|---|---|
| Scan profiles defined | DONE (5 profiles) |
| Target groups defined | DONE (4 groups) |
| Scan windows defined | DONE |
| Critical finding workflow | DONE (notify-only, manual approval) |
| Report export workflow | DONE |
| Infrastructure device caution | DONE (gateways non-invasive, PVE discovery only) |
| No scan credentials in docs | VERIFIED (none written) |

## Deployment state

- Greenbone CE on mct-soc-scan VM (192.168.222.154) - running (20 containers, 184,646 NVTs per Phase 2).
- Test scan executed in Phase 2 (MCT-Wazuh-host-149, Discovery config).
- Scheduled recurring scans not yet enabled - operator action required to create schedules in Greenbone UI.

## Open items

- Create Greenbone schedule objects per window policy (manual UI/CLI step).
- Provision svc-openvas-scan account for authenticated scans (staging test first).
- Verify critical-finding webhook (drill D5 pending).
