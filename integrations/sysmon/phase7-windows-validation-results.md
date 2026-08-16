# Windows Sysmon Validation Results (Phase 7)

Date: 2026-08-12
Status: PENDING - no Windows endpoint

## Planned validation (when device available)

| Event | Test | Expected |
|---|---|---|
| 1 | notepad from temp | archive event |
| 3 | Test-NetConnection 142.105.190.25:1514 | archive event |
| 22 | nslookup canary.test.invalid | archive event |
| 12-14 | HKLM Run key test | archive events |

## Queries

integrations/sysmon/sysmon-validation-queries.md

## Acceptance

- Events 1/3/22 in wazuh-archives for pilot agent.
- Velociraptor check-in via GUI (post port-8002 fix).
