# Phase 23 Windows 014 Sysmon Apply

Date: 2026-08-22
Status: **BLOCKED - ENDPOINT ACCESS + APPROVAL** (no remote path to 014; approval-gated).

## 1. Approval + access

- Approval: required (change register C1, pending). Access: unavailable (precheck 23.03).
- **No apply performed.**

## 2. Config to apply (when access + approval)

- `integrations/sysmon/phase23-eventid7-policy.xml` (include-oriented; design review 23.04).
- Fallback alternative: prior exclusion-list config (`phase22-windows014-applied-config.xml`).

## 3. Operator steps

```powershell
# Backup + hash current config
certutil -hashfile C:\Windows\Sysmon\sysmon-config.xml SHA256
Copy-Item C:\Windows\Sysmon\sysmon-config.xml C:\Windows\Sysmon\sysmon-config.xml.pre-p23.xml
# Copy phase23-eventid7-policy.xml to C:\Windows\Sysmon\ and apply
.\Sysmon64.exe -c C:\Windows\Sysmon\phase23-eventid7-policy.xml
# Verify
sc query Sysmon64
Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational -MaxEvents 5
# Agent check: Wazuh agent 014 keepalive fresh
```

## 4. Validation (SOC-side post-apply)

- EID7 endpoint-side drop >=99% target (include-mode); EID1/10 continuity; buffer clean;
  throttle retirement review (23.06).

## 5. Decision

- **BLOCKED**. Operator steps delivered. No success claimed.

## Files
- `ops/reports/phase23-windows014-sysmon-apply.md` (this), `integrations/sysmon/phase23-windows014-final-config.xml`

## No secrets