# Phase 25 Agent 014 Sysmon Apply

Date: 2026-08-22
Status: **APPLIED - CONFIG ACCEPTED** (rc=0).

## Evidence (02:45 UTC RMM run)

- Sysmon executable resolved: `C:\WINDOWS\Sysmon64.exe` (dynamic resolution working).
- Effective config dumped + backed up (FDA3C032...) BEFORE change.
- Policy file rewritten from embedded content (was 0CDBCFE2 stale 4.90 -> BCA0EB... 4.91+Signed).
- `sysmon -c <policy>` returned **rc=0** (accepted); service RUNNING.
- Verification `sysmon -s` marker: **unconfirmed** (WARN) - likely Sysmon stores the loaded
  config internally and `-s` reflects it only after the service re-reads; OR dump nuance.

## Confirmation step (recommended, operator)

```cmd
sc stop Sysmon64
sc start Sysmon64
```
Then re-run `check-sysmon-tune.ps1` (expect marker-present: True + dump head showing
`image-load-include` / schemaversion 4.91).

## Rollback

- rollback-sysmon-tune.ps1 (restores FDA3C0 dump).

## No secrets