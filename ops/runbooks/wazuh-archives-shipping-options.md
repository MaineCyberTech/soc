# Wazuh Archives Shipping Options (REVISED 2026-08-15)

## Current state (Option B, updated 2026-08-15)

- **Archives index: ENABLED** - master filebeat now ships archives to
  OpenSearch wazuh-archives-* (was disabled; enabled 2026-08-15, backlog
  drained). Archive search in dashboard now works.
- Local: /var/ossec/logs/archives/archives.json on master (fresh, ~2.4 GB).
- SO leg REMOVED: the syslog-ng sidecar (raw archives -> Security Onion) was
  stopped + disabled (#DISABLED-P9 in docker-compose.override.yml). SO no
  longer receives Wazuh archives.

## Options

### Option A: OpenSearch archives (now ACTIVE - see current state)

Pros: archive search in dashboard, single searchable store.
Cons: +4-8 GB/day storage; needs retention policy + monitoring.

### Option B: Local-only (retired SO leg 2026-08-15)

- Local: /var/ossec/logs/archives/archives.json on master.
- SO: no longer receives archives (removed).
- OpenSearch wazuh-archives-*: NOW indexed (enabled 2026-08-15).

## Decision history

- 2026-08-11: Option B chosen (local + SO) because archives shipping was
  disabled and disk was tight.
- 2026-08-15: Archive shipping ENABLED (backlog drained); SO leg removed.
  Effective model = local + OpenSearch indexed archives.

## Storage impact (2026-08-15)

- wazuh-archives-* growth adds ~1-2 GB/day (archives ~2x alert volume).
- Root disk at 63% - monitor with capacity-threshold-check.sh.
- If disk >= 85%: reduce archive retention or revisit shipping.

## Revert procedure (if archive shipping must be disabled again)

1. Edit filebeat.yml on master: `archives: enabled: false`.
2. Restart master container (s6 restarts filebeat).
3. Verify wazuh-archives-<date> stops growing.
4. Back up compose + filebeat.yml first.
