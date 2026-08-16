# Sysmon Validation Results

Date: 2026-08-11
Status: **NOT RUN - pilot not deployed (no Windows endpoint; PVE API 401 blocker)**

## Planned validation (when deployed)

| Event | Test | Expected |
|---|---|---|
| 1 process creation | run notepad from temp | archive event, image=temp path |
| 3 network | Test-NetConnection 192.168.222.149:3001 | archive event, dest LAN |
| 22 DNS | nslookup canary.test.invalid | archive event, query name |
| 12-14 registry | add/remove HKLM Run TestRun | archive events |
| PowerShell | -enc encoded command (safe local) | post tune-in rule 101002 |

## Query reference

integrations/sysmon/sysmon-validation-queries.md (events 1/3/22 + archives + rules).

## Acceptance

- One endpoint only: CONFIRMED (scope)
- No broad deployment: CONFIRMED
- Validation results recorded when run: pending endpoint
