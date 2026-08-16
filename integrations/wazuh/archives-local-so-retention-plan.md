# Archives Retention (Local + Indexed - Option B, REVISED 2026-08-15)

## Retention model

| Store | Contents | Freshness | Queryable |
|---|---|---|---|
| /var/ossec/logs/archives/archives.json (master) | all raw events | FRESH (continuous) | grep/python on host |
| OpenSearch wazuh-archives-* | all raw events | **FRESH (since 2026-08-15)** | YES - dashboard/API |
| Security Onion | (REMOVED 2026-08-15) | n/a | n/a |

## Changes on 2026-08-15

- Master filebeat archive shipping ENABLED (was `archives: enabled: false`).
  Sysmon + zeek + all non-alert events now index to wazuh-archives-*.
- The syslog-ng sidecar that forwarded raw archives to Security Onion was
  STOPPED + DISABLED (#DISABLED-P9 in docker-compose.override.yml).
- SO no longer receives Wazuh archives; SO is a packet-ingestion box feeding
  Wazuh via agent 008 (zeek-forward.log).

## Operations

- Archive queries: wazuh-alerts-* (alerts) + wazuh-archives-* (all events, now
  indexed) or master archives.json (raw).
- Health-check monitors local archives freshness (PASS) and archive index.
- The 2.4GB filebeat backlog drained 2026-08-15; indexer archives current.

## Warning to operators

- Pre-2026-08-15 wazuh-archives-* data was stale (shipping disabled); any
  historical analysis before that date should use master archives.json.
- Documentation pointers updated in runbooks.

## Retention

- Local archives.json grows ~2.6 GB buffer; rotate per Wazuh (logall_json).
- Indexer retention follows OpenSearch index lifecycle (review periodically).
- Revisit archive shipping policy when storage allows.

## See also

- ops/runbooks/wazuh-archives-shipping-options.md (updated)
- ops/runbooks/phase9-change-control.md (change record)
