# Sysmon Rule / Dashboard Backlog

Detection backlog for the Windows Sysmon pilot. Rules stay log-only until tuned.

## Detection backlog

| # | Detection | Sysmon EventID | Planned rule | Level (final) |
|---|---|---|---|---|
| 1 | PowerShell suspicious flags | 1 | 101002 | 9 |
| 2 | LOLBins (certutil, mshta, wmic, bitsadmin) | 1 | 101002 | 9 |
| 3 | Unexpected parent-child process chains | 1 | 101001 | 8 |
| 4 | External network connections by process | 3 | 101010 | 8 |
| 5 | New service creation | 6/7 | 101060 | 8 |
| 6 | Scheduled task creation | 1/12 | 101030 | 10 |
| 7 | Admin tool use (mimikatz names, psexec) | 1/8/10 | 101020/101021 | 12 |
| 8 | Defender exclusion changes | 12-14 | 101031 | 10 |

## Rule plan source

`integrations/sysmon/sysmon-rule-plan.md` (planned range 101000-101999,
log-only start, CDB-dependent rules disabled until MISP CDB validated).

## Dashboard backlog

1. **Sysmon Overview**: Event 1/3/22 counts per host (last 24h) - index `wazuh-alerts-*`, filter `event.id` / `data.win.system.eventID`.
2. **LOLBin activity**: rule 101002 hits.
3. **Persistence changes**: registry/service/task events.
4. **Outbound connections**: Event 3 by process.
5. **CDB hits**: rule 101011/101070 (after CDB enabled).

## Collection validation queries

```text
# Event 1 counts per agent
GET wazuh-alerts-*/_search
{"size":0,"query":{"bool":{"filter":[{"term":{"data.win.system.eventID":1}},{"term":{"agent.name":"<pilot>"}}]}},"aggs":{"by_image":{"terms":{"field":"data.win.eventdata.image.keyword","size":20}}}}

# Event 22 DNS
GET wazuh-alerts-*/_search
{"size":0,"query":{"bool":{"filter":[{"term":{"data.win.system.eventID":22}},{"term":{"agent.name":"<pilot>"}}]}},"aggs":{"by_query":{"terms":{"field":"data.win.eventdata.queryName.keyword","size":20}}}}

# Archive reachability (no rule match yet)
GET wazuh-archives-*/_search
{"size":1,"query":{"term":{"agent.name":"<pilot>"}},"sort":[{"timestamp":"desc"}]}
```

## Acceptance

- All 8 backlog detections have planned rule + validation query (DONE in plan).
- No broad deployment automatically - pilot group only.
- Rollback procedure exists in windows-sysmon-pilot.md.
