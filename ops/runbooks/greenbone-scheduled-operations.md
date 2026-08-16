# Greenbone Scheduled Operations Runbook

## Status

- Target groups: FINALIZED (integrations/greenbone/target-groups-phase4.md)
- Profiles: FINALIZED (5 - scan-schedule-phase4.md)
- Schedule plan: FINALIZED (5 tasks, scan-schedule-phase4.md)
- Remediation/verification workflow: FINALIZED
- **Lab schedule CREATED + VALIDATED 2026-08-15**: `MCT-lab-weekly-sun-0600`
  (weekly Sunday 06:00 UTC, attached to task MCT-lab-scan-242 on target
  MCT-lab-vuln-target-242 / 192.168.222.242). Production schedule
  `MCT-Weekly-Sunday-0200` also in use. See
  ops/reports/phase9-greenbone-recurring-schedule.md.
- **Critical alert config: ACTIVE** - `MCT-Critical-to-Shuffle`
  (severity >= 9.0 -> Shuffle webhook, validated 2026-08-15).

## Creating schedules

Follow integrations/greenbone/scan-schedule-phase4.md task list. Each schedule:

1. Target group (from target-groups-phase4.md)
2. Profile (from scan-schedule-phase4.md)
3. Window per scan-window-policy
4. Attach critical-finding alert (webhook to Shuffle) to critical tasks

## Operational cadence

- Monthly: core-infra + cloud scans; review results; update vulnerability-review.
- Quarterly: network-appliances scans.
- On-demand: post-remediation verification.
- After each scan: check FP suppression held (scanner IP alerts), export reports.

## Reporting

- Monthly aggregate: reporting/templates/phase4-vulnerability-review.md
- Critical findings: IRIS case + client notification per template criteria.

## Readiness

| Item | Status |
|---|---|
| Schedules defined | YES |
| Risky device guidance (non-invasive) | YES (gateways/PVE) |
| Critical path to IRIS | TESTED (D5) / alert ACTIVE (MCT-Critical-to-Shuffle) |
| Scan credentials in docs | NO (verified) |
