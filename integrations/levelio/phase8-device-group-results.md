# Phase 8 Device Group Results

Date: 2026-08-15

## Groups

| Group | Devices | Result |
|---|---|---|
| linux-clients | 1 (native agent 006, Phase 7 pilot) | PASS 6/6 |
| mac-clients | 0 | BLOCKED (no device) |
| windows-clients | 0 | BLOCKED (no device) |
| internal-mct | 4 agents | active |
| client-pilot | 0 | pending |

## Learnings to carry forward

1. Verify scripts require root (level.io Linux default OK).
2. Public IP enrollment (142.105.190.25) + registration password: REQUIRED vars.
3. Registration password must be encrypted variable.
4. Agent groups must exist in Wazuh BEFORE rollout.
5. Velociraptor config must be regenerated per server (prepare script).
