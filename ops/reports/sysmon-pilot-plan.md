# Sysmon Pilot Plan - Phase 3

Date: 2026-08-11

## Status: PLANNED (no deployment)

No Windows endpoint deployed, no Sysmon installed, no rules activated.

## Deliverables created

- `ops/runbooks/windows-sysmon-pilot.md` - full pilot runbook (provision, deploy, validate, tune-in, rollback).
- `integrations/sysmon/windows-agent-group-plan.md` - Wazuh agent group `windows-sysmon-pilot` + agent.conf draft.
- `integrations/sysmon/test-event-checklist.md` - safe Event 1/3/22/11/12-14 test procedures + verification.
- `integrations/sysmon/rule-dashboard-backlog.md` - 8 detections, planned rules 101001-101031, dashboard backlog, validation queries.

## Detection backlog coverage

| Detection | Planned |
|---|---|
| PowerShell suspicious flags | 101002 |
| LOLBins | 101002 |
| Unexpected parent-child chains | 101001 |
| External network connections by process | 101010 |
| New service creation | 101060 |
| Scheduled task creation | 101030 |
| Admin tool use | 101020/101021 |
| Defender exclusion changes | 101031 |

## Acceptance criteria

- Pilot plan exists: YES
- No broad deployment happens automatically: CONFIRMED (plan only)
- Rollback procedure exists: YES (in runbook)
- Validation queries documented: YES (test-event-checklist + rule-dashboard-backlog)

## Next actions (operator)

1. Provision Windows 11 test VM.
2. Install Wazuh agent + enroll to `windows-sysmon-pilot` group.
3. Deploy Sysmon with sysmon-mct.xml.
4. Run test-event-checklist; confirm collection.
5. 2-week tune-in at log-only levels.
