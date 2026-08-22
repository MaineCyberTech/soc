# Phase 24 Agent 014 (and 013) Include-Oriented Sysmon Apply

Date: 2026-08-22
Status: **BLOCKED - ENDPOINT ACCESS + APPROVAL** (C1 pending).

## 1. Approval + access

- Approval: pending (C1). Access: unavailable. **No apply performed.**

## 2. Config to apply (both Windows clients)

- `integrations/sysmon/phase23-eventid7-policy.xml` (include-oriented: LOLBin processes,
  unsigned modules, non-system module paths). Fallback: exclusion-list config.

## 3. Operator steps (per endpoint, 014 + 013)

```powershell
certutil -hashfile C:\Windows\Sysmon\sysmon-config.xml SHA256
Copy-Item C:\Windows\Sysmon\sysmon-config.xml C:\Windows\Sysmon\sysmon-config.xml.pre-p24.xml
# copy phase23-eventid7-policy.xml -> C:\Windows\Sysmon\
.\Sysmon64.exe -c C:\Windows\Sysmon\phase23-eventid7-policy.xml
sc query Sysmon64
Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational -MaxEvents 5
```

## 4. Validation (SOC-side post-apply)

- EID7 >=99% drop; EID1/10 continuity; buffer clean; throttle retirement criteria (phase24-08).

## 5. Decision

- **BLOCKED**. Operator steps delivered; no success claimed.

## No secrets