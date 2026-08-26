# Phase 27 Agent 013 Effective Marker

Date: 2026-08-24
Status: **PENDING OPERATOR `-s` DUMP** (C1).

## Certification checks (operator, via check-sysmon-tune.ps1)

1. `sysmon -s` dump -> `image-load-include` marker + schema 4.91.
2. `sysmon -c` accept (rc=0) already proven pattern; config hash recorded.
3. Service/driver: Sysmon64 RUNNING.
4. Restart persistence: marker still present after service restart.

## Intended include rules (verify in dump)

- LOLBin process conditions (rundll32/regsvr32/mshta/wscript/cscript/wmic/certutil/cmd/pwsh)
- `Signed is not true`
- ImageLoaded AppData/Temp/Downloads/ProgramData/Windows-Temp

## Acceptance

- PASS when marker + schema 4.91 + service RUNNING + restart-persistent.

## No secrets