# Phase 26 Agent 014 Restart and Marker Check

Date: 2026-08-23
Status: **RESTART + MARKER CHECK PENDING OPERATOR** (policy accepted rc=0 in P25).

## Procedure (operator)

```cmd
sc stop Sysmon64
sc start Sysmon64
```
Then re-run `check-sysmon-tune.ps1` -> expect `marker-present: True` and dump head showing
`image-load-include` / schema 4.91.

## Current evidence

- P25 apply: `sysmon -c` accepted (rc=0); policy file = 4.91+Signed (BCA0EB...); effective
  config backup retained (FDA3C032...). EID1/10 flowing; EID7 0/30m.

## Acceptance

- PASS when marker present in `sysmon -s` dump + service RUNNING + EID1/10 continuity.

## No secrets