# Phase 8 Windows Event Validation

Status: PENDING (no VM)

| Event | Test | Expected | Result |
|---|---|---|---|
| 1 process | notepad from temp | archive image=temp | pending |
| 3 network | Test-NetConnection 142.105.190.25:1514 | archive dest | pending |
| 22 DNS | nslookup canary.test.invalid | archive query | pending |
| 12-14 reg | HKLM Run test | archive | pending |

## Queries

sysmon-validation-queries.md

## Acceptance

Events 1/3/22 in wazuh-archives for pilot agent; Velociraptor check-in.
