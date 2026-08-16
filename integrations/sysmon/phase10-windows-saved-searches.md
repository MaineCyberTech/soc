# Phase 10 Windows Saved Searches (Backlog)

Date: 2026-08-15
Source: pilot telemetry. Queries target wazuh-archives-* (data.win fields).

## Saved searches (dashboard-ready)

| # | Name | Query (indexer) |
|---|---|---|
| S1 | Sysmon EventID overview | agent.id:012 AND data.win.system.channel:Microsoft-Windows-Sysmon/Operational - by eventID |
| S2 | Sysmon ProcessCreate | ... AND data.win.system.eventID:1 |
| S3 | Sysmon ImageLoad noise | ... AND data.win.system.eventID:7 - top imageLoaded |
| S4 | lsass access | ... AND data.win.system.eventID:10 |
| S5 | PowerShell events | data.win.system.providerName:PowerShell OR EID 4104 (future) |
| S6 | New services | data.win.system.eventID:6 OR (Security 7045) |
| S7 | Defender exclusions | data.win.system.eventID:4657 AND data.win.eventdata:Exclusions |
| S8 | Sysmon network conns | ... AND data.win.system.eventID:3 - top dst_ip/process |
| S9 | Windows auth failures | Security 4625 by src_ip |
| S10 | Agent 012 level 9+ alerts | wazuh-alerts-* agent.id:012 rule.level>=9 |

## Fields used

- data.win.system.channel, eventID, providerName
- data.win.eventdata.image, imageLoaded, commandLine, dst_ip, dst_port, user

## Rollout

- Build in dashboard once archives fully queryable (verified caught up).
- Group into the windows-clients dashboard backlog (P10.09 dashboard doc).

## No secrets

No secret values printed.
