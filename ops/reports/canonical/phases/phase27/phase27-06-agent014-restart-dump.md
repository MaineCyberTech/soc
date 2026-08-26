# Phase 27 Agent 014 Restart and Config Dump

Date: 2026-08-24
Status: **PENDING OPERATOR RESTART + DUMP** (C1).

## Procedure (operator)

```cmd
sc stop Sysmon64
sc start Sysmon64
```
Then `check-sysmon-tune.ps1` -> capture `-s` dump (size, marker, head).

## Context

- P25 apply accepted the 4.91+Signed policy (rc=0); effective-config backups retained
  (FDA3C032...). EID7 0/30m; EID1 7/30m.

## Acceptance

- Dump contains `image-load-include` + schema 4.91 after restart (restart persistence proven).

## No secrets