# Windows Endpoint Telemetry Summary

Endpoint: {{ hostname }}
Period: {{ period }}

## Collection status

- Wazuh agent: {{ agent_status }}
- Sysmon: {{ sysmon_status }} (Event IDs: 1,3,11,12-14,22)
- Velociraptor: {{ velociraptor_status }}

## Telemetry volume (24h)

| Event ID | Count | Notes |
|---|---|---|
| 1 process creation | {{ e1_count }} | |
| 3 network | {{ e3_count }} | |
| 11 file create | {{ e11_count }} | |
| 12-14 registry | {{ e1214_count }} | |
| 22 DNS | {{ e22_count }} | |

## Detection hits (post tune-in)

| Rule | Count | FP rate |
|---|---|---|
| 101001 suspicious image path | {{ r101001 }} | |
| 101002 LOLBins | {{ r101002 }} | |
| 101010 unknown executable outbound | {{ r101010 }} | |

## Notes

- Collection-only until 2-week tune-in completes.
- Rollback procedure: windows-sysmon-velociraptor-pilot.md.
