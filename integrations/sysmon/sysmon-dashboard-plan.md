# Sysmon Dashboard Plan (planned)

Create saved searches + visualizations in the Wazuh dashboard (OpenSearch) for Sysmon telemetry.

## Saved searches

| Saved search | Query |
|---|---|
| sysmon-all | `data.win.system.event_id:* AND data.win.system.provider_name:"Microsoft-Windows-Sysmon"` |
| sysmon-process-creation | `data.win.system.event_id:1` |
| sysmon-network | `data.win.system.event_id:3` |
| sysmon-injection | `data.win.system.event_id:8 OR data.win.system.event_id:10` |
| sysmon-persistence | `data.win.system.event_id:(12 OR 13 OR 14)` |
| sysmon-file-events | `data.win.system.event_id:(11 OR 15 OR 25)` |
| sysmon-drivers | `data.win.system.event_id:6` |
| sysmon-dns | `data.win.system.event_id:22` |

## Dashboard layout (per client)

- Row 1: top processes by count (Event 1), top source IPs, top executables
- Row 2: network connections by process, outbound by dest port
- Row 3: injection indicators (8/10), persistence changes (12-14), timestomping (25)
- Row 4: Sysmon health — events per host per hour (coverage check)

## Fields used by the Wazuh Sysmon decoder

The Wazuh built-in sysmon decoder maps to `data.win.system.event_id`, `data.win.eventdata.image`, `data.win.eventdata.commandLine`, `data.win.eventdata.destinationIp`, etc. Confirm exact field names with a sample event before saving visualizations.

## Export/backup

- Export saved searches/dashboards via `ops/dashboards/restore-dashboards.sh` pattern (existing Wazuh ops tooling) and store in `ops/backups`.
