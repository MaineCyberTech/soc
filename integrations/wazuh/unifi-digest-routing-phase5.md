# UniFi Digest Routing (Phase 5)

## Applied (2026-08-11)

Routine churn rules moved to **Class D archive (level 1)** via local_rules.xml overrides:

120505, 120506, 120509, 120510, 120512, 120517, 120520, 120531, 120532

## Preserved classes

| Class | Rules | Rationale |
|---|---|---|
| A | MISP-matched WAN drops (1205xx w/ malicious IP), infrastructure compromise | immediate |
| B | 120527 unknown device, 120521 WPA replay, 120524 storm, 120501 WAN drop (MITRE), 120518 link down, 120528 unknown DHCP, 120513 memory pressure | same-day review |
| C | 120560 DDNS failure | daily digest |
| D | churn rules (listed above) | archive only |

## Digest workflow

Remaining Class B/C UniFi alerts reviewed daily:

1. OpenSearch query: UniFi family alerts, last 24h (see below).
2. Analyst reviews unknown devices (120527), drops (120501/120518), replay (120521).
3. Add new MACs to known-devices list (unblocks 120527 backlog).
4. Escalate to IRIS only on confirmed pattern (repeat offender, IOC match).

## Digest query

```json
{
  "size": 0,
  "query": {
    "bool": {
      "filter": [
        { "range": { "timestamp": { "gte": "now-24h" } } },
        { "terms": { "rule.groups": ["ubiquiti", "unifi", "firewall", "dhcp"] } }
      ]
    }
  },
  "aggs": {
    "by_rule": { "terms": { "field": "rule.id", "size": 20 } },
    "by_site": { "terms": { "field": "data.ubiquiti.chain.keyword", "size": 10 } }
  }
}
```

## Class A protection

Never suppress: OpenCanary 1210xx, MISP 1211xx, flow unknown-exporter,
flow lateral-movement, WAN drop flood (100+ in 2m).
