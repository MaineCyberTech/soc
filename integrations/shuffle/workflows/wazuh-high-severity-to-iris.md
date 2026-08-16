# Workflow: wazuh-high-severity-to-iris

- Mode: notify-only
- Trigger: Shuffle Webhook `wazuh-high-severity` (from OpenSearch Alerting notification)
- Payload: `integrations/shuffle/webhook-contracts/wazuh-high-severity.json`

## Steps

1. Receive alert payload (rule_id, level, agent, srcip, dstip, timestamp).
2. Enrich: MISP lookup on srcip/dstip (`misp-ioc-enrichment` sub-flow).
3. If level >= 10 or enrichment match confidence:high -> POST DFIR-IRIS `/api/alert`.
4. Log outcome to local file + notify channel (Class A/B).
5. If IRIS unavailable: retry with backoff (3 attempts), then log to file.

## Failure modes

- Bad payload -> validation error logged; alert stays in OpenSearch.
- IRIS 401 -> check `IRIS_API_KEY` app config; log to file.

## Acceptance

- POST `wazuh-high-severity.json` to webhook; IRIS alert appears with matching title.
- No blocking action in this workflow.
