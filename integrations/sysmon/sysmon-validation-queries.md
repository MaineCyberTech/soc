# Sysmon Validation Queries (Phase 4)

Run from the Wazuh host after the pilot endpoint produces test events.

## Prereq

```bash
WAZUH_ADMIN_PASSWORD=...  # from creds.env, never printed
```

## 1. Event 1 - process creation (per image)

```json
{
  "size": 0,
  "query": {
    "bool": {
      "filter": [
        { "term": { "data.win.system.eventID": 1 } },
        { "term": { "agent.name": "<pilot>" } }
      ]
    }
  },
  "aggs": {
    "by_image": { "terms": { "field": "data.win.eventdata.image.keyword", "size": 10 } }
  }
}
```

## 2. Event 3 - network connection (per dest)

```json
{
  "size": 0,
  "query": {
    "bool": {
      "filter": [
        { "term": { "data.win.system.eventID": 3 } },
        { "term": { "agent.name": "<pilot>" } }
      ]
    }
  },
  "aggs": {
    "by_dest": { "terms": { "field": "data.win.eventdata.destinationIp.keyword", "size": 10 } }
  }
}
```

## 3. Event 22 - DNS query

```json
{
  "size": 0,
  "query": {
    "bool": {
      "filter": [
        { "term": { "data.win.system.eventID": 22 } },
        { "term": { "agent.name": "<pilot>" } }
      ]
    }
  },
  "aggs": {
    "by_query": { "terms": { "field": "data.win.eventdata.queryName.keyword", "size": 10 } }
  }
}
```

## 4. Archives reachability (collection-only, no rules yet)

```json
{
  "size": 1,
  "query": { "term": { "agent.name": "<pilot>" } },
  "sort": [{ "timestamp": "desc" }]
}
```

Index: `wazuh-archives-*` (events land here before rules are enabled).

## 5. Rule-fire check (after tune-in phase)

```json
{
  "size": 0,
  "query": {
    "bool": {
      "filter": [
        { "range": { "timestamp": { "gte": "now-7d" } } },
        { "terms": { "rule.id": ["101001","101002","101003","101010","101011","101020","101021","101030","101031","101040","101050","101060","101070"] } }
      ]
    }
  }
}
```

Index: `wazuh-alerts-*`.

## Pass criteria

- Events 1/3/22 present in archives for the pilot agent.
- After tune-in: rule 101xxx hits recorded; FP rate reviewed weekly.
