# OpenSearch Alerting → Shuffle Webhook Wiring

Purpose: route the 5 existing OpenSearch Alerting monitors (flow-*) into Shuffle so Class A/B alerts reach DFIR-IRIS.

## Prerequisites

- Shuffle logged in (org mct-soc, admin user).
- Shuffle API key: Shuffle UI → Profile/API keys → create key (store in `/opt/mct-security-stack/.env` as `SHUFFLE_API_KEY`, mode 600).

## 1. Create webhook triggers in Shuffle

In Shuffle UI → Workflows → New workflow → add a **Webhook** trigger (one per monitor class):

| Webhook name | Purpose | Used by monitor(s) |
|---|---|---|
| `wazuh-high-severity` | Class A/B alerts | flow-unknown-exporter, flow-lateral-movement |
| `wazuh-flow-classb` | Class B flow alerts | flow-high-outbound-bytes, flow-icmp-flood, flow-unusual-ports |

Copy the webhook URL for each (they look like `http://127.0.0.1:3001/api/v1/webhooks/<id>` — from inside the OpenSearch cluster the hostname is `shuffle-frontend` if joined to the same network, or the Docker gateway).

Note: the existing `integrations/shuffle/webhook-contracts/*.json` files define the expected payload schema; OpenSearch Alerting must POST that JSON shape.

## 2. Wire the monitors

OpenSearch Alerting (dashboard, port 443 localhost) → Monitors → for each monitor:

1. Edit monitor → Notifications → **Add destination**:
   - Method: Webhook
   - URL: the Shuffle webhook URL (use `http://shuffle-frontend:80/api/v1/webhooks/<id>` if OpenSearch can resolve it on the same Docker network; otherwise `http://172.20.0.x` — check `docker network inspect multi-node_default`)
   - Method: POST, Headers: `Content-Type: application/json`
   - Body (JSON, match the contract):
     ```json
     {
       "rule_id": "{{ctx.monitor.name}}",
       "rule_level": "{{ctx.trigger.severity}}",
       "rule_description": "{{ctx.alert.name}}",
       "rule_groups": ["flow"],
       "agent_name": "wazuh",
       "srcip": "{{#ctx.results.0.hits.hits.0._source.client.ip}}{{.}}{{/ctx.results.0.hits.hits.0._source.client.ip}}",
       "dstip": "{{#ctx.results.0.hits.hits.0._source.server.ip}}{{.}}{{/ctx.results.0.hits.hits.0._source.server.ip}}",
       "timestamp": "{{ctx.periodStart}}"
     }
     ```
2. Save; click **Send test message** → verify the workflow fires in Shuffle (Workflows → the workflow → Executions).

## 3. Wire Shuffle → DFIR-IRIS (notify-only)

1. Create Shuffle API key in IRIS: IRIS UI → API keys (admin) → add key → store in `.env` as `IRIS_API_KEY`.
2. In Shuffle, add an HTTP app action to the workflow after the webhook:
   - Method POST, URL `https://127.0.0.1:8443/api/alert`
   - Header `Authorization: Bearer ${IRIS_API_KEY}` (use a Shuffle secret variable)
   - Body per `integrations/payload-contracts/wazuh-to-iris.json` fields
3. Keep the workflow notify-only until validated (see `integrations/shuffle/approval-gates.md`).

## 4. Test

1. OpenSearch Alerting → monitor → **Send test message** → confirm Shuffle execution logs success.
2. Optional end-to-end: `curl` the Shuffle webhook with `integrations/shuffle/webhook-contracts/wazuh-high-severity.json` and confirm the workflow runs.

## Failure modes

- Shuffle webhook 404 → wrong webhook ID (regenerate from the workflow).
- OpenSearch can't resolve the webhook host → use the Docker gateway IP (`ip route` gateway on the multi-node network, e.g. 172.18.0.1) and port 3001.
- IRIS 401 → stale IRIS API key (rotate in IRIS, update Shuffle secret).
