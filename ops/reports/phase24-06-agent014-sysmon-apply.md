# Phase 24 Agent 014 (and 013) Include-Oriented Sysmon Apply

Date: 2026-08-22
Status: **BLOCKED - ENDPOINT ACCESS + APPROVAL** (C1 pending).

## 1. Approval + access

- Approval: pending (C1). Access: unavailable. **No apply performed.**

## 2. Config to apply (both Windows clients)

- `integrations/sysmon/phase23-eventid7-policy.xml` (include-oriented: LOLBin processes,
  unsigned modules, non-system module paths). Fallback: exclusion-list config.

## 3. Operator steps (per endpoint, 014 + 013)

New automation (Phase 24): `integrations/sysmon/apply-sysmon-tune.ps1` (elevated PowerShell on the endpoint).

```powershell
# 1. Pre-check (no changes)
.\apply-sysmon-tune.ps1 -Mode check

# 2. Copy the include-oriented policy to the endpoint, then apply:
#    (script backs up + hashes current config, copies policy, reloads Sysmon, verifies)
Copy-Item <share>\integrations\sysmon\phase23-eventid7-policy.xml C:\Windows\Sysmon\mct-eid7-policy.xml
.\apply-sysmon-tune.ps1 -Mode apply

# 3. Rollback (if needed)
.\apply-sysmon-tune.ps1 -Mode rollback            # newest backup
.\apply-sysmon-tune.ps1 -Mode rollback -BackupPath C:\Windows\Sysmon\mct-backups\sysmon-config.<TS>.xml
```

Manual fallback (script unavailable):

```powershell
certutil -hashfile C:\Windows\Sysmon\sysmon-config.xml SHA256
Copy-Item C:\Windows\Sysmon\sysmon-config.xml C:\Windows\Sysmon\sysmon-config.xml.pre-p24.xml
# copy phase23-eventid7-policy.xml -> C:\Windows\Sysmon\
.\Sysmon64.exe -c C:\Windows\Sysmon\phase23-eventid7-policy.xml
sc query Sysmon64
Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational -MaxEvents 5
```

Log: `C:\Windows\Sysmon\mct-sysmon-tune.log` (no secrets).

## 4. Validation (SOC-side post-apply)

- EID7 >=99% drop; EID1/10 continuity; buffer clean; throttle retirement criteria (phase24-08).

## 5. Decision

- **BLOCKED**. Operator steps delivered; no success claimed.

## No secrets