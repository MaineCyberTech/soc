# Greenbone Schedule Readiness

Date: 2026-08-11

## Status: READY TO SCHEDULE (Greenbone-side config pending operator on VM103)

## Deliverables

- integrations/greenbone/target-groups-phase4.md - 4 finalized groups
- integrations/greenbone/scan-schedule-phase4.md - 5 profiles + 5 schedule tasks
- integrations/greenbone/remediation-verification-workflow.md - triage -> fix -> verify -> report
- ops/runbooks/greenbone-scheduled-operations.md - runbook + cadence
- reporting/templates/phase4-vulnerability-review.md - monthly review template

## Checks

| Item | Status |
|---|---|
| Schedules defined | YES (plan) |
| Profiles defined | YES (5) |
| Risky devices non-invasive | YES |
| Critical path to IRIS | Tested (D5 synthetic payload); alert config pending VM103 |
| Scan credentials in docs | NO |

## Blocker

- Greenbone schedule objects + critical-finding alert need creation via
  gvm-cli/UI on mct-soc-scan VM (operator action, documented steps provided).
