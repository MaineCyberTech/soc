# Phase 21 Windows 014 Sysmon Operator Steps

Date: 2026-08-19
Run on: DESKTOP-MI54LFT (014). No secrets.

## Prereqs

- Access to 014 (RDP/console/Velociraptor client action authorized by operator).
- Copy of `integrations/sysmon/sysmon-mct.xml` and a backup of the current Sysmon config.

## Steps

```powershell
# 1. Save current config (rollback copy)
Copy-Item C:\Windows\Sysmon\sysmon-config.xml C:\Windows\Sysmon\sysmon-config.xml.pre-eid7tune.xml

# 2. Copy tuned config to 014
#    (transfer sysmon-mct.xml to C:\Windows\Sysmon\sysmon-mct.xml)

# 3. Validate + apply (reload; service stays running)
.\Sysmon64.exe -c C:\Windows\Sysmon\sysmon-mct.xml

# 4. Verify service + recent events
sc query Sysmon64
Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational -MaxEvents 5
```

## What to check after

- `sc query Sysmon64` = RUNNING.
- Wazuh agent 014 stays active (keepalive fresh).
- EventID 1 (Process Create) still flowing.

## SOC will verify (no operator action)

- EventID 7 volume >=90% drop (target < 60K/24h vs ~574K).
- EventID 1 (15K/24h) + EventID 10 (1.5K/24h) unchanged.
- No agent buffer flood/full events.

## Rollback

`.\Sysmon64.exe -c C:\Windows\Sysmon\sysmon-config.xml.pre-eid7tune.xml` (or `.\Sysmon64.exe -u`).

## No secrets