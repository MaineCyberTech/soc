# Phase 21 Windows 014 Sysmon Rollback

Date: 2026-08-19

## Trigger

- EventID 1 or 10 volume drops unexpectedly after tuning.
- EventID 7 exclusion removes events that later prove needed.
- Agent 014 disconnects / Sysmon service unhealthy after reload.

## Rollback steps (operator on 014)

```powershell
# Restore previous config (if a copy was saved before tuning)
.\Sysmon64.exe -c sysmon-mct-previous.xml

# If no previous copy: reload the stock config or re-install default
.\Sysmon64.exe -u            # uninstall (last resort)
.\Sysmon64.exe -accepteula -i sysmon-mct.xml   # reinstall baseline
```

Verify:
```powershell
sc query Sysmon64
Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational -MaxEvents 5
```

## Wazuh-side confirmation

- Agent 014 keepalive continuous; buffer events normal.
- EventID 7 volume returns to ~574K/24h (flood pattern) - expected if rolled back; confirm with SOC.

## Notes

- Keep a copy of the pre-tune Sysmon config on 014 and in the repo before applying.
- Rollback restores the flood; if rollback required, re-plan tuning before re-apply.

## No secrets