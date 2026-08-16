# Sysmon Test Event Checklist

Generate safe events on the pilot endpoint and verify each arrives in Wazuh.

## Event 1 - Process creation

```powershell
# elevated
Copy-Item C:\Windows\System32\notepad.exe C:\Windows\Temp\notepad.exe
C:\Windows\Temp\notepad.exe   # launch then close
```

Expected: Sysmon Event 1 (image C:\Windows\Temp\notepad.exe), Wazuh archive.

## Event 3 - Network connection

```powershell
# connects to the local Shuffle/IRIS host webhook (LAN, safe)
Test-NetConnection 192.168.222.149 -Port 3001
```

Expected: Event 3 (network), dest 192.168.222.149:3001.

## Event 22 - DNS query

```powershell
nslookup canary.test.invalid 127.0.0.1
```

Expected: Event 22 (DNS), name canary.test.invalid.

## Event 11 - File create

```powershell
Set-Content -Path C:\Users\public\Downloads\malware-sim.docx -Value 'test'
```

Expected: Event 11 (file create) if downloads dir is in Sysmon config.

## Event 12-14 - Registry persistence

```powershell
New-Item -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Run -Name TestRun -Value 'notepad.exe' -Force
Remove-Item -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Run -Name TestRun
```

Expected: Events 12/13/14 registry modification.

## Event 8/10 - Injection / process access

```powershell
# optional, only with elevated test tooling; skip in pilot phase A
```

## Verification

```bash
# from Wazuh host
docker exec multi-node-wazuh.master-1 grep -c 'sysmon\|eventchannel' /var/ossec/logs/archives/archives.json
# or via OpenSearch: event.id:1 AND agent.name:<pilot-host>
```

## Cleanup

- Delete test artifacts (temp notepad, downloads file, registry key).
- Record test times in ops/reports to exclude from noise baselines.

## Safety

- All test actions local and benign; no malware, no internet C2, no scanning.
