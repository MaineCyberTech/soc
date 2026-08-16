# Windows Sysmon Pilot Summary

Endpoint: {{ hostname }}
Period: {{ period }}

## Status

- Wazuh agent: {{ agent_status }}
- Sysmon: {{ sysmon_status }}
- Velociraptor: {{ velociraptor_status }}

## Telemetry (24h)

| Event ID | Count |
|---|---|
| 1 process creation | {{ e1 }} |
| 3 network | {{ e3 }} |
| 11 file create | {{ e11 }} |
| 12-14 registry | {{ e1214 }} |
| 22 DNS | {{ e22 }} |

## Detection hits (post tune-in)

| Rule | Count | FP |
|---|---|---|
| 101001 suspicious image | {{ r101001 }} | |
| 101002 LOLBins | {{ r101002 }} | |
| 101010 outbound | {{ r101010 }} | |

## Notes

- Collection-only until 2-week tune-in completes.
- Rollback: windows-sysmon-velociraptor-pilot.md.
