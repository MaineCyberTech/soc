# Phase 12 Agent 009 Disposition

Date: 2026-08-16

## Investigation

| Item | Value |
|---|---|
| Agent ID | 009 |
| Name | ospd-openvas.local |
| Registered | 2026-08-10 16:48 UTC (Greenbone deployment day, Phase 7) |
| Status | never_connected (since registration) |
| IP | any |
| OS/version | none |
| Last keepalive | never |

## Finding

- No system carries this registration: VM 103 (mct-soc-scan, Greenbone host) has
  NO Wazuh agent installed; Greenbone runs in Docker containers (no agent in
  containers); no other lab VM (240-244) matches this registration.
- Phantom registration from the Phase 7 Greenbone deployment attempt - an agent
  was registered (name ospd-openvas.local = container hostname) but never
  actually installed/started anywhere.

## Disposition: REMOVE (applied)

- Removed via manage_agents (2026-08-16). Deletion confirmed - agent no longer
  listed; summary now 5 active / 0 never_connected / 6 total.
- No data loss risk: agent never connected, sent no events.

## Why not other options

- Re-enroll: no target system exists - nothing to re-enroll.
- Retire/historical: would pollute coverage counts forever; removal is clean.
- Exclude from coverage reporting: removal achieves the same without legacy rows.

## Impact

- Endpoint counts now reflect reality: 6 registered (5 active incl. manager +
  agents 006/007/008/011/012).
- Coverage reporting: 100% of registered agents active (was 86%).

## No secrets

No secret values printed.
