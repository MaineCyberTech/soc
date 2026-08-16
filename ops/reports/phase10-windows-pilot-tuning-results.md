# Phase 10 Windows Pilot Tuning Results

Date: 2026-08-15
Target: VM 201 mct-win11-pilot01, Wazuh agent 012, windows-clients group

## Sysmon visibility: CONFIRMED (archives caught up)

- Sysmon channel configured on agent 012 (Microsoft-Windows-Sysmon/Operational).
- Filebeat archives shipping: ENABLED.
- Archive backlog: **CAUGHT UP** (filebeat offset at file end; 2.4GB drained).
- Sysmon events indexed: 24,268 today (10k+ query cap; latest at 23:53 current).
- **Preflight fix**: agent 012 logcollector had stalled at 21:00 UTC; WazuhSvc
  restart restored event flow.

## Event breakdown (24h)

| EventID | Count | Meaning |
|---|---|---|
| 7 | 23,229 | ImageLoad (DOMINANT - noise) |
| 5 | 653 | ProcessTerminate |
| 1 | 358 | ProcessCreate |
| 10 | 11 | ProcessAccess (lsass) |
| 2 | 8 | FileCreateTime |

## Noise analysis (EventID 7 ImageLoad)

- Top loaded images: winnsi.dll (1000), NetSetupEngine.dll (993), ntdll.dll (640),
  kernel.appcore.dll (403), ucrtbase.dll (402), sechost.dll (395), msvcrt.dll (390),
  KernelBase.dll (387) - all System32 DLLs, expected baseline noise.
- Tuning action: restrict ImageLoad to non-Microsoft images in sysmon-mct.xml
  (keep images with signed=false or non-System32 paths).

## Detection-relevant signals

- EventID 1 (ProcessCreate): 358 - useful (excludes common tools by config).
- EventID 10 (ProcessAccess on lsass): 11 - credential access watch.
- PowerShell visibility: script block logging NOT enabled (backlog item).

## Tuning recommendations

1. Reduce EventID 7 noise: exclude Microsoft-signed System32 images.
2. Enable PowerShell ScriptBlockLogging (EID 4104) on the pilot.
3. Add ProcessCreate includes for LOLBins (powershell, wscript, mshta, regsvr32).
4. Keep EventID 10 (lsass access) as-is - low volume, high value.

## No secrets

No secret values printed.
