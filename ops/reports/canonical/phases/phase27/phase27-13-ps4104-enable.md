# Phase 27 PowerShell 4104 Pilot Enable

Date: 2026-08-24
Status: **NOT ENABLED - APPROVAL PENDING** (C3).

## Enable procedure (on approval)

1. Enable ScriptBlockLogging GPO on 012 only; gpupdate /force.
2. Verify Event 4104 provider/channel (Microsoft-Windows-PowerShell/Operational, id 4104).
3. Confirm Wazuh collection (EventChannel) + rule mapped.
4. Record 24h volume baseline.

## Rollback

- Disable GPO; gpupdate; remove rule; verify no new 4104 events.

## No secrets