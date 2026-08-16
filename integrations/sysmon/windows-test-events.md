# Sysmon Windows Test Events

Use these to validate that Sysmon telemetry reaches Wazuh after deployment. Run on a PILOT endpoint only, during a maintenance window.

## Test 1: Process creation (Event 1)

```powershell
Start-Process notepad.exe
```

Expected in Wazuh: event_id 1, `data.win.eventdata.image` = `C:\Windows\System32\notepad.exe`.

## Test 2: Network connection (Event 3)

```powershell
Test-NetConnection -ComputerName 1.1.1.1 -Port 443
```

Expected: event_id 3 with destinationIp `1.1.1.1`.

## Test 3: LOLBin pattern (Event 1 + rule 101002)

```powershell
powershell -enc ZQBjAGgAbwAgAHQAZQBzAHQAdAA=
```

Expected: rule 101002 (if deployed) fires; otherwise event 1 with commandLine containing `-enc`.

## Test 4: Registry persistence (Event 13)

```powershell
New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name TestRunKey -Value "C:\Windows\System32\notepad.exe" -Force
Remove-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run\TestRunKey
```

Expected: event_id 13 (or 12) with the run key path. Remove the key afterward.

## Test 5: File create (Event 11)

```powershell
Set-Content -Path "$env:TEMP\sysmon-test.txt" -Value "mct test"
Remove-Item "$env:TEMP\sysmon-test.txt"
```

Expected: event_id 11 with target filename `sysmon-test.txt`.

## Verification in Wazuh

```bash
# From the dashboard Discover:
# filter: data.win.system.event_id:1 AND data.win.system.provider_name:"Microsoft-Windows-Sysmon" AND agent.name:<pilot-host>
# or via API (local only):
curl -sk -u admin:${WAZUH_ADMIN_PASSWORD} "https://127.0.0.1:9200/wazuh-alerts-*/_search?q=data.win.system.event_id:1&size=5"
```

Note: Wazuh events may appear with a few minutes delay; check `wazuh-alerts-*` and `wazuh-archives-*` indices.

## Cleanup

- Remove all test files and registry keys.
- Record test results in `ops/reports` with the pilot hostname.
