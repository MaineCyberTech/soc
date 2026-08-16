# Sysmon Dashboard Backlog (Phase 6)

Status: PENDING DATA - no Windows endpoint yet. Backlog defined; dashboards
created only after field names confirmed from real data.

## Panels (defined)

| # | Panel | Data source | Filters |
|---|---|---|---|
| P1 | Windows Sysmon Overview | wazuh-archives/alerts | data.win.system.eventID counts per agent |
| P2 | PowerShell Activity | Event 1 | data.win.eventdata.image: powershell.exe |
| P3 | LOLBins | Event 1 | image: certutil/mshta/wmic/bitsadmin |
| P4 | Parent/child process chains | Event 1 | data.win.eventdata.parentImage + Image |
| P5 | External connections by process | Event 3 | destinationIp not in private ranges |
| P6 | New service/scheduled task | Events 6/7/12-14 | service name / task |
| P7 | Defender exclusions | Event 12-14 | HKLM Defender ExclusionPath |
| P8 | Admin tool usage | Events 1/8/10 | psexec/mimikatz etc. |

## Prereq

- Confirm Sysmon event field names from real data (data.win.eventdata.*) before building.
- Data lands in wazuh-archives-* (collection-only) until rules enabled.

## Rules backlog (from sysmon-rule-plan.md)

101001-101031 (log-only start, 2-week tune-in), CDB rules 101011/101070 after CDB validated.
