# Phase 28 Agent 014 Sysmon Marker

Date: 2026-08-24
Status: **BLOCKED - OPERATOR RMM PENDING** (C1).

## Requirement

`sysmon -s` effective dump + `-c` rc + service/driver state + restart persistence +
rollback evidence after apply/restart.

## Current state

- 014 active (last alert 18:28Z). EID1 99/24h (6/30m), EID7 0/24h, EID10 0 - clean.
- Operator RMM step pending: `apply-sysmon-tune.ps1` (idempotent, verifies policy file hash
  BCA0EB...), `sc stop/start Sysmon64`, `check-sysmon-tune.ps1` posts `-s` dump.

## Unblock

- Operator runs the two no-arg scripts on 014; dump verified -> marker PASS.

## No secrets