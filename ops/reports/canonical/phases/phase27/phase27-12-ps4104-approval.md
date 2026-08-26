# Phase 27 PowerShell 4104 Pilot Approval

Date: 2026-08-24
Status: **PREPARED - APPROVAL PENDING** (C3).

## Pilot parameters (012 MCT-WIN11PILOT only)

| Item | Value |
|---|---|
| Endpoint | 012 (non-billable) |
| Policy | GPO ScriptBlockLogging enabled (Event 4104); InvocationLogging disabled |
| Privacy notice | 4104 records script text (may embed credentials/automation content) - documented; access SOC-only |
| Least access | log read restricted; retention 14d (archives) |
| Expected content | PowerShell commands/functions/scripts on pilot |
| Rule scope | 4104 EventChannel rule on windows-clients |
| Rollback | disable GPO + remove rule + verify no new 4104 |

## Approval

- **PENDING** (operator). No fleet-wide rollout before pilot privacy/volume review.

## No secrets