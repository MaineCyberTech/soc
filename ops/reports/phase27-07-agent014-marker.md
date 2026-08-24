# Phase 27 Agent 014 Effective Marker

Date: 2026-08-24
Status: **PENDING OPERATOR `-s` DUMP** (C1).

## Certification checks (operator)

1. `sysmon -s` after restart -> marker + schema 4.91.
2. Include rules present (LOLBin/Signed/AppData-Temp-Downloads-ProgramData-WindowsTemp).
3. Service/driver RUNNING; config hash recorded.
4. Backup retained; rollback ready.

## Acceptance

- PASS when marker confirmed + restart-persistent + EID1/10 continuity in Wazuh.

## No secrets