# Phase 24 Agent 014 (and 013) Include-Oriented Sysmon Apply

Date: 2026-08-22
Status: **BLOCKED - ENDPOINT ACCESS + APPROVAL** (C1 pending).

## 1. Approval + access

- Approval: pending (C1). Access: unavailable. **No apply performed.**

## 2. Config to apply (both Windows clients)

- `integrations/sysmon/phase23-eventid7-policy.xml` (include-oriented: LOLBin processes,
  unsigned modules, non-system module paths). Fallback: exclusion-list config.

## 3. Operator steps (per endpoint, 014 + 013)

**Level.io/RMM-safe automation (Phase 24):** three self-contained scripts - **no arguments
required** (runners that execute scripts without parameters, e.g.
`ScriptBlock::Create(stdin)`, are fully supported):

| Script | Purpose |
|---|---|
| `integrations/sysmon/check-sysmon-tune.ps1` | report only (service, hashes, backups, EID7 activity) - no changes |
| `integrations/sysmon/apply-sysmon-tune.ps1` | **creates the policy file** (embedded XML), backs up + hashes current config, loads include-oriented policy, reloads Sysmon, verifies |
| `integrations/sysmon/rollback-sysmon-tune.ps1` | restore newest backup + reload |

Each script embeds everything it needs - upload any of them to the endpoint and run with no
arguments:

```powershell
.\check-sysmon-tune.ps1          # safe pre-check
.\apply-sysmon-tune.ps1          # apply (creates mct-eid7-policy.xml automatically)
.\rollback-sysmon-tune.ps1       # rollback
```

Log: `C:\Windows\Sysmon\mct-sysmon-tune.log` (no secrets).
Docs: `integrations/sysmon/README-sysmon-tuning.md`.

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