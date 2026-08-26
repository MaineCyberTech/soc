# Phase 26 Agent 014 Effective Policy Validation

Date: 2026-08-23
Status: **PENDING OPERATOR CONFIRMATION** (C1).

## Checks

- `sysmon -s` dump: `image-load-include` marker + schema 4.91 (after restart).
- Service/driver: Sysmon64 RUNNING; driver loaded.
- Backup retained: effective-config dumps (FDA3C032...).
- Signature/path conditions present: Signed is not true; AppData/Temp/Downloads/ProgramData/
  Windows-Temp; LOLBin process list.
- Rollback: rollback-sysmon-tune.ps1 restores newest dump.

## Acceptance

- PASS when marker confirmed + service RUNNING + Wazuh shows EID1/10 continuity.

## No secrets