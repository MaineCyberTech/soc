# Phase 9 Sysmon Rule Backlog

## Priority 1 (enable visibility)

| # | Rule/watcher | Why | Action |
|---|---|---|---|
| 1 | PowerShell script block logging (EID 4104) | detect PS-based attacks | Enable via GPO/registry on VM 201: `HKLM\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging\EnableScriptBlockLogging=1` |
| 2 | Sysmon EventID 1 (ProcessCreate) for powershell.exe, wscript, mshta, regsvr32 | LOLBin detection | Add include for these images in sysmon-mct.xml (currently only excludes common tools) |
| 3 | Sysmon EventID 11 (FileCreate) for %TEMP% + .exe/.dll | payload staging | Add rule 92050-class watcher |

## Priority 2 (reduce noise)

| # | Rule | Volume | Action |
|---|---|---|---|
| 4 | 19007/19008 (lvl 7) | 473/24h | Review source; if Security channel noise, extend the agent Security query filter |
| 5 | EventID 7 ImageLoad | high | Consider limiting ImageLoad to non-Microsoft images |

## Priority 3 (SOC detections - Wazuh rules to add)

| # | Detection | Rule suggestion |
|---|---|---|
| 6 | Sysmon EID 1 with cmd.exe /c + encoded | lvl 10 |
| 7 | Sysmon EID 3 (network) outbound to known-bad | lvl 12 (needs feed) |
| 8 | Sysmon EID 13 (registry) Run keys modification | lvl 10 |

## Status

- Items 1-3, 6-8: NOT yet applied (pilot is one endpoint; apply to pilot, validate
  volume, then fold into client template).
- Items 4-5: review after archive shipping completes (2.4GB backlog draining).

## No secrets

No secret values printed.
