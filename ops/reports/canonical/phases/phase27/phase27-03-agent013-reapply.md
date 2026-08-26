# Phase 27 Agent 013 Policy Re-apply

Date: 2026-08-24
Status: **PENDING OPERATOR RMM RUN** (C1).

## Procedure (Level.io action, no args)

1. Upload updated `apply-sysmon-tune.ps1` -> run on 013.
2. Expect: Policy file written (4.91 content, BCA0EB...-style hash); `sysmon -c` rc=0;
   VERIFIED marker (`image-load-include`); service RUNNING.
3. Follow with `sc stop Sysmon64; sc start Sysmon64` + `check-sysmon-tune.ps1` for the
   definitive `-s` dump.

## Backup / rollback

- Effective config dumps retained (FDA3C032...). rollback-sysmon-tune.ps1 ready.

## Current evidence

- EID7 0/30m (sustained quiet), EID1 39/30m - supports certification once marker confirmed.

## No secrets