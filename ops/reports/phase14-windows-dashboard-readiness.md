# Phase 14 Windows Dashboard Readiness

Date: 2026-08-16

## Status: DATA READY - UI BUILD REQUIRED

| Dashboard | Data ready | Buildable | Blocked by |
|---|---|---|---|
| W1 Windows endpoint health | YES (channels, agent, alerts fields verified) | YES (manual UI) | none |
| W2 Sysmon overview | YES (EID, image, process fields verified) | YES (manual UI) | none |
| W3 Windows auth | YES (Security 4624/4625) | YES | priority |
| W4 Process detections | PARTIAL | NO | D1-D4 rules backlog |
| W5 PowerShell | NO | NO | PS ScriptBlockLogging off |

## Procedure

- Manual UI import (integrations/sysmon/phase14-dashboard-w1-w2-readiness.md).
- No saved-object API import tooling in the stack (documented).

## Expansion gate

External Windows monitoring remains blocked until:
1. 7-day FP re-measure: < 10 level>=9/day (in progress, P14.07).
2. W1/W2 dashboards built (operator UI task).
3. Non-system VaultCli variant alerting proven.

## No secrets
