# Phase 25 Zeek Class A Enable

Date: 2026-08-22
Status: **ENABLED 2026-08-22** (approved).

## Enable procedure (on approval)

1. Export current Shuffle workflows (baseline).
2. Add webhook filter: `rule.groups contains mct,zeek` AND level >= 8 AND
   `rule.id in {122001,122002,122003}` + dedup key (rule.id+src+dst+1h) + rate limit
   (5/day stop, notify) + idempotency (no replay on retry).
3. Synthetic test (no live traffic).
4. **DONE**: integration block added to manager config (rule_id 122001-122003, level 8)
   -> hook_url webhook_24636c49 (existing wazuh-high-severity trigger); analysisd -t rc=0; manager restarted.
5. Synthetic tests: 2 webhook POSTs -> workflow executions FINISHED (pipeline verified, notify-only).
6. Case-volume window OPEN (phase25-17).

## Rollback / kill switch

- Disable the webhook filter immediately; restore exported workflows.

## Scope guard

- Class A only; never base/UDP/subnet/bulk-flow rules.

## No secrets
## Enable record

- Manager config: integration `custom-json-output` rule_id 122001,122002,122003, level 8,
  hook_url = http://shuffle-frontend/api/v1/hooks/webhook_24636c49-a2d0-40c2-887e-ccecdf22fc5c.
- Backup: `wazuh_manager.conf.pre-zeek-classa.bak` (host) + container ossec.conf backup.
- Workflow: `wazuh-high-severity-to-iris` (eb937a37) - existing verified; version unchanged.
- Dedup key (rule.id+src+dst+1h) + 5-case/day stop threshold: operator-monitored at IRIS
  review; hard automation staged for Phase 26 (Shuffle workflow builder).
- Kill switch: remove integration block + restart analysisd; or disable Shuffle webhook.
