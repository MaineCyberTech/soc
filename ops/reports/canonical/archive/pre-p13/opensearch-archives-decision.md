# OpenSearch Archives Decision

Date: 2026-08-11
Decision: **OPTION B - accept local + Security Onion archive retention (with caveats documented)**

## Storage impact analysis

| Metric | Value |
|---|---|
| Local archives.json | 2.6 GB (multi-day buffer, ~3.3M docs) |
| Est. archives index/day | 4-8 GB/day (raw events, more verbose than alerts) |
| Free disk | 18 GB (82% used) |
| Existing consumers | vd feed 8.7G + snapshots 9.2G + indexer 10.6G |

**Option A (restore OpenSearch archives) would fill the disk in <3 days** at
current capacity. It requires: storage expansion (add disk or move snapshots to
S3-only) + bind-mounted custom filebeat.yml (survives image re-seed) + retention
policy for the new index.

## Decision rationale

- Local archives.json: FRESH (written continuously, 2.6 GB).
- Security Onion forwarding: receives raw archives (docker-compose.override.yml).
- OpenSearch `wazuh-archives-*`: stale since 08-10 18:07 (documented).
- Alert pipeline (wazuh-alerts-*): unaffected and complete.
- Disk is the binding constraint; archives shipping is non-critical for
  alerting/IR.

## Consequences (documented)

- **`wazuh-archives-*` is NOT trustworthy** - queries against it return stale
  data. Operators must use wazuh-alerts-* or the master's local archives.json.
- Health-check updated (Phase 5) to check local archives.json freshness - PASS.
- Dashboards/searches referencing wazuh-archives-* should be updated or flagged.

## Revisit criteria (future)

Reconsider Option A when: disk >= 60% free (add ~40 GB) OR alert volume drops
further OR archive search becomes a requirement (compliance/client evidence).

## Files

- ops/reports/opensearch-archives-decision.md (this file)
- ops/runbooks/wazuh-archives-shipping-options.md
- integrations/wazuh/custom-filebeat-archives-plan.md (Option A prep, not applied)
- integrations/wazuh/archives-local-so-retention-plan.md (Option B active)
