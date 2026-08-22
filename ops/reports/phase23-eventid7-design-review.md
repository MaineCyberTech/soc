# Phase 23 EventID 7 Include-vs-Exclude Design Review

Date: 2026-08-22

## Problem

EventID 7 (Image Loaded) is intrinsically very high volume (574K/24h on 014). The prior
P21/22 approach was a growing benign-exclusion list (conhost/docker/osqueryi/powershell/etc.).
An exclusion list must be maintained forever and every new high-volume benign binary is
missed until measured -> unsustainable.

## Design decision: INCLUDE-ORIENTED

Production should collect ImageLoad events **only when a suspicious combination is present**,
rather than everything minus known-good. Detection use cases are preserved explicitly; raw
volume is not a goal.

## Include conditions (phase23-eventid7-policy.xml)

| Condition | Use case |
|---|---|
| Loading process contains a LOLBin (rundll32, regsvr32, mshta, wscript, cscript, wmic, certutil, powershell, pwsh, cmd) | scriptlet/LOLBin execution with module loads |
| Module signature Unsigned | unsigned module loads (supply-chain/lateral movement signal) |
| Module path contains \AppData\, \Temp\, \Downloads\, \ProgramData\, or begins C:\Windows\Temp\ | modules staged outside system dirs |
| Module path not under C:\Windows\ (implicit via the above) | non-standard module locations |

Known-good loads (signed system modules from System32/Docker/osqueryi/etc.) are NOT collected.

## What drops / what remains

- DROPS: conhost (258K), docker.exe (168K), osqueryi (49K), powershell signed-system loads,
  GoogleUpdater, backgroundTaskHost, WmiPrvSE, RuntimeBroker, taskhostw (signed, system paths).
- REMAINS: unsigned loads, LOLBin-process loads, AppData/Temp/Downloads/ProgramData module
  loads, Temp-staged modules. Detection value preserved; volume target < 2K/24h.

## Test matrix (to run when applied)

| Sample | Expected |
|---|---|
| conhost.exe loads System32 module (signed) | NOT logged |
| powershell.exe (system) loads signed System32 DLL | NOT logged (unless LOLBin rule fires for the *process* - decision: process-condition includes powershell; see note) |
| rundll32.exe loads unsigned C:\Users\X\AppData\...dll | LOGGED |
| wscript.exe loads C:\Windows\Temp\...dll | LOGGED |
| any process loads unsigned module from C:\ProgramData\ | LOGGED |
| chrome.exe loads signed system module | NOT logged |

Note on powershell: including powershell as a process condition re-introduces ~35K/24h of
signed system loads. Decision: **exclude powershell.exe from the process-include list**
(keep wscript/cscript/mshta/rundll32/regsvr32/wmic/certutil/cmd) and instead catch PowerShell
via the unsigned/module-path conditions - otherwise the include list becomes as noisy as the
exclude list. PowerShell module loads from non-system paths still fire (module conditions).

## Risk acceptance

- Keep the OLD exclusion-list config (sysmon-mct.xml) as the fallback if include-mode
  under-detection is later proven.
- EID1/10 untouched in all variants.
- Never disable all EventID 7 without explicit risk acceptance.

## Files
- `ops/reports/phase23-eventid7-design-review.md` (this), `integrations/sysmon/phase23-eventid7-policy.xml`

## No secrets