# Phase 9 Windows Sysmon Tuning

Date: 2026-08-15
Target: VM 201 mct-win11-pilot01 (192.168.222.244), Wazuh agent 012 (windows-clients)

## Status

- Agent 012: **Active**
- Sysmon 4.91: **Running**, channel has 48,047 records
- Sysmon events reaching the master: **CONFIRMED** (492+ recent entries in archives.json, e.g. EventID 7 ImageLoad with processGuid/image data)
- **MAJOR FIX in this phase**: filebeat archive shipping was `enabled: false` on the master -> Sysmon events (which are archives, not alerts) never reached the indexer/dashboard. Enabled -> events will index (backlog ~2.4GB draining).

## Telemetry (agent 012, 24h - alerts only)

| Metric | Value |
|---|---|
| Total alerts | 755 |
| By level | lvl7: 352, lvl3: 311, lvl4: 43, lvl6: 36, lvl9: 6, lvl5: 3, lvl10: 2, lvl12: 2 |
| Top rules | 19007 (352), 19008 (121), 61104 (13), 60137 (12), 60642 (11) |

## Process creation visibility

- Sysmon config (sysmon-mct.xml) excludes System32 cmd.exe/powershell/notepad etc.
  from ProcessCreate -> process creation for common tools is NOT alerted
  (intentional noise reduction, but reduces visibility).
- ImageLoad (ID 7) events ARE captured (confirmed in archives.json).

## Noisy events / tuning backlog

1. **19007/19008 (lvl 7) - 473 events/24h**: Windows event log related rules (likely
   the Security channel flood). Review if these are actionable or noise.
2. **EventID 7 ImageLoad volume**: Sysmon ImageLoad is high-volume; consider
   restricting in sysmon-mct.xml if it floods the archives.
3. **61104/60137/60642 (service/logon changes)**: small counts, keep.
4. **Level 9/10/12 events (10 total)**: review for SOC attention (potential detections).

## PowerShell visibility

- **Not yet validated**: the config excludes cmd.exe but PowerShell (powershell.exe)
  is NOT excluded from ProcessCreate in the config... however the current
  sysmon-mct.xml only captures specific events. PowerShell script block logging
  (EventID 4104) requires separate Windows config - NOT enabled. Recommend
  enabling PS script block logging on the pilot for detection value.

## Rule/dashboard backlog (see integrations/sysmon/phase9-rule-backlog.md)

## No secrets

No secret values printed.
