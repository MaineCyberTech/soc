# Sysmon Saved Search Backlog

Status: PENDING DATA

## Saved searches to create (OpenSearch saved searches)

| # | Name | Query |
|---|---|---|
| S1 | sysmon-process-creation | data.win.system.eventID:1 AND agent.name:<pilot> |
| S2 | sysmon-network | data.win.system.eventID:3 AND agent.name:<pilot> |
| S3 | sysmon-dns | data.win.system.eventID:22 AND agent.name:<pilot> |
| S4 | sysmon-registry | data.win.system.eventID:12 OR 13 OR 14 |
| S5 | sysmon-file-create | data.win.system.eventID:11 |
| S6 | sysmon-lolbins | data.win.eventdata.image:(certutil OR mshta OR wmic OR bitsadmin) |

## Note

- Field names to be confirmed from first real data (eventchannel parsing varies).
- Searches target wazuh-archives-* during collection-only phase.
