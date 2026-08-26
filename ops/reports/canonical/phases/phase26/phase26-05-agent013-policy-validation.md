# Phase 26 Agent 013 Effective Policy Validation

Date: 2026-08-23
Status: **PENDING OPERATOR CHECK OUTPUT** (C1).

## Validation steps (operator, via check-sysmon-tune.ps1)

- Effective config dump (`sysmon -s`) -> expect `image-load-include` marker + schema 4.91.
- Service/driver: Sysmon64 RUNNING.
- Config hash: policy file (BCA0EB...-style) vs deployed.
- Include rules present: LOLBin processes, Signed is not true, AppData/Temp/Downloads/
  ProgramData/Windows-Temp module paths.

## Acceptance

- PASS when marker present + service RUNNING + EID1/10 observed in Wazuh.

## No secrets