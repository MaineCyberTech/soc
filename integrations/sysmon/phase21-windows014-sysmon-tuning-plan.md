# Phase 21 Windows 014 Sysmon Tuning Plan

Date: 2026-08-19
Status: APPROVED-PLAN (apply gated on endpoint access + operator approval).

## Change

Deploy `integrations/sysmon/sysmon-mct.xml` on 014 (additive EventID 7 targeted excludes).
Preserves EventID 1/10 and all other detections; excludes ImageLoad for verified-known paths.

## Config file

`integrations/sysmon/sysmon-mct.xml` (versioned, stored in repo per deployment doc).

## Apply steps (operator)

1. Copy `sysmon-mct.xml` to 014.
2. Validate: `.\Sysmon64.exe -c sysmon-mct.xml` (on a test/pilot first if available).
3. Apply: `.\Sysmon64.exe -c sysmon-mct.xml` (reload config; service stays running).
4. Verify: `sc query Sysmon64` = RUNNING; `Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational -MaxEvents 5` healthy.
5. Wazuh agent 014 stays active (keepalive continuous).

## Expected effect (to be measured)

- EventID 7 archive volume: ~574K/24h -> < 60K/24h (>=90% drop).
- EventID 1 (15K/24h) and EventID 10 (1.5K/24h) unchanged.
- Agent buffer: no 'flooded'/'full' events.

## Rollback

See `integrations/sysmon/phase21-windows014-sysmon-rollback.md`.

## No secrets