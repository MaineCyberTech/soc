# MCT Sysmon EventID 7 Tuning Scripts

Targets: Windows endpoints **013 SAMSUNG** and **014 DESKTOP-MI54LFT** (windows-clients group).

## Problem

Sysmon EventID 7 (Image Loaded) is intrinsically high volume. Both Windows clients emit
large volumes of benign image loads (conhost, Docker, osquery, signed system modules) which
flood Wazuh archives (~58-574K docs/24h) and trigger analysis throttling.

## Solution: include-oriented policy

`phase23-eventid7-policy.xml` collects ImageLoad events **only** for suspicious combinations:
- Loading process is a LOLBin (rundll32, regsvr32, mshta, wscript, cscript, wmic, certutil,
  cmd, pwsh)
- Module is unsigned
- Module path is in `\AppData\`, `\Temp\`, `\Downloads\`, `\ProgramData\`, or `C:\Windows\Temp\`

EventID 1 (Process Create) and EventID 10 (ProcessAccess) are never touched. EventID 7 is
never globally disabled.

## Scripts (self-contained - NO arguments required)

Designed for RMM runners that execute scripts without parameters (e.g. Level.io
`ScriptBlock::Create(stdin)`). Each file embeds everything it needs; rename/copy as-is.

| Script | Action | Changes made |
|---|---|---|
| `check-sysmon-tune.ps1` | Report state | NONE (service, config hashes, backups, EID7 channel activity) |
| `apply-sysmon-tune.ps1` | Apply tuning | Creates `C:\Windows\Sysmon\mct-eid7-policy.xml` (embedded), backs up + hashes current config, loads policy, reloads Sysmon, verifies service |
| `rollback-sysmon-tune.ps1` | Restore prior config | Restores newest timestamped backup and reloads Sysmon |

## Usage

```powershell
# 1. Check (safe, no changes)
.\check-sysmon-tune.ps1

# 2. Apply (after check passes)
.\apply-sysmon-tune.ps1

# 3. Rollback (if needed)
.\rollback-sysmon-tune.ps1
```

Log: `C:\Windows\Sysmon\mct-sysmon-tune.log` (no secrets).

## Validation (SOC-side, after apply)

- EventID 7 volume >= 99% drop (Wazuh archives/alerts).
- EventID 1 and EventID 10 still flowing.
- Agent buffer clean (no flooded/full events).
- Suspicious samples from the test matrix (phase23-eventid7-design-review.md) still logged.

## Files

- `phase23-eventid7-policy.xml` - the include-oriented policy (source of truth).
- `apply-sysmon-tune.ps1` / `check-sysmon-tune.ps1` / `rollback-sysmon-tune.ps1` - RMM-safe
  mode scripts generated from one shared template (kept in sync).
- `phase24-06-agent014-sysmon-apply.md` - apply/approval record.

## No secrets