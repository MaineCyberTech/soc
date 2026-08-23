# Phase 26 PowerShell 4104 Pilot Apply

Date: 2026-08-23
Status: **NOT APPLIED - APPROVAL PENDING** (C5).

## Apply procedure (on approval)

1. Enable ScriptBlockLogging GPO on **012 only**; gpupdate /force.
2. Verify Event 4104 generated (test: `Write-Host 'pilot-test-4104'` in a script block).
3. Wazuh: confirm 4104 events collected (EventChannel) + rule mapped.
4. Record volume baseline (24h).

## Rollback

- Disable GPO setting; gpupdate; remove 4104 rule; verify no new 4104 events.

## Decision

- **PENDING approval** - not enabled.

## No secrets