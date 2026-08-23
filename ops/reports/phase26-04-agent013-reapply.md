# Phase 26 Agent 013 Sysmon Re-apply

Date: 2026-08-23
Status: **PENDING OPERATOR RMM RUN** (C1; script ready).

## Procedure (Level.io action, no args)

1. Upload updated `apply-sysmon-tune.ps1` -> run on 013.
2. Expected log: Policy file written (was 0CDBCF..., now BCA0EB...-style 4.91 hash);
   `sysmon -c` rc=0; VERIFIED marker (`image-load-include`); service RUNNING.
3. Optionally: `sc stop Sysmon64; sc start Sysmon64` then `check-sysmon-tune.ps1`.

## Backup / rollback

- Effective config dump retained (FDA3C032...). rollback-sysmon-tune.ps1 available.

## Current evidence

- EID7 0/30m (quiet cycle) - volume alone cannot confirm load; marker check is the proof.

## No secrets