# Sysmon Event Validation Results

Date: 2026-08-11
Status: **PENDING - no Windows endpoint**

## Validation matrix (when VM deployed)

| Event | Test | Expected | Result |
|---|---|---|---|
| 1 | notepad from temp | archive event image=temp | pending |
| 3 | Test-NetConnection 192.168.222.149:3001 | archive event dest LAN | pending |
| 22 | nslookup canary.test.invalid | archive event queryName | pending |
| 12-14 | HKLM Run key add/remove | archive events | pending |
| 8/10 | (skip pilot A) | - | - |

## Query reference

integrations/sysmon/sysmon-validation-queries.md

## Acceptance

- Events 1/3/22 present in wazuh-archives for the pilot agent.
- Post tune-in: rule 101xxx hits + FP review.
