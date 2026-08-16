# Internal Weekly Security Review

Audience: MCT SOC team only. Period: <start> — <end>. Prepared: <date>.

## Summary

- Class A events: <n> — reviewed <n>, false positives <n>
- Class B events: <n> — queued <n>, resolved <n>
- Open IRIS cases: <n> (new <n>, closed <n>)
- Deception hits: <n>
- MISP IOCs added: <n> (exported to CDB <n>)
- Active responses fired: <n>
- Notable flows: <n>

## Case review

| Case | Class | Summary | Status | Owner |
|---|---|---|---|---|
| IRIS-<n> | A | <summary> | Open/Closed | <name> |

## Pipeline health

- Wazuh: cluster <green/yellow/red>, alerts/day <n>
- Elastiflow: flows/day <n>, unknown exporters <n>
- Security Onion: alive <yes/no>, suricata alerts <n>
- OpenCanary: hits <n>
- Shuffle: workflows run <n>, failures <n>
- IRIS: API reachable <yes/no>
- MISP: feeds last sync <date>
- Velociraptor: clients online <n>/<n>, hunts run <n>

## Tuning changes

| Change | Reason | Before | After |
|---|---|---|---|
| <rule/monitor change> | <reason> | <volume> | <volume> |

## Action items

- [ ] <item> (owner, due)

## Decisions needed

- <decision needed from team/management>
