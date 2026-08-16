# Workflow: flow-unknown-exporter-to-case

- Mode: notify-only
- Trigger: Shuffle Webhook `flow-unknown-exporter` (from Wazuh custom flow rules)
- Payload: `integrations/shuffle/webhook-contracts/wazuh-high-severity.json` (same schema, rule family `flow`)

## Steps

1. Extract exporter IP + device metadata.
2. Query known-devices list (local CSV in Shuffle or Wazuh API).
3. If known: log + end (no notification).
4. If unknown: create IRIS alert via `/api/alert` (template `unknown-flow-exporter`), notify Class A channel.

## Failure modes

- Known-devices query fails -> treat as unknown, notify (fail-open for visibility, fail-safe for case creation).

## Acceptance

- Test payload with unknown exporter IP creates an IRIS alert.
