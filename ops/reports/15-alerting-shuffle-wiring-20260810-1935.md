# OpenSearch Alerting → Shuffle Webhook Wiring — DONE (2026-08-10)

## What was wired

| Shuffle webhook | Hook UUID | Destination (config doc) | Monitors |
|---|---|---|---|
| wazuh-high-severity (Class A) | d1e66f3f-c970-4817-8998-3610ad96e49f | shuffle-webhook-classA (NXsn7Z8BrR5di7YESBuW) | flow-unknown-exporter, flow-lateral-movement |
| wazuh-flow-classb (Class B) | 2nd hook | shuffle-webhook-classB (7Hso7Z8BrR5di7YEIh4O) | flow-icmp-flood, flow-high-outbound-bytes, flow-unusual-ports |

Workflow: `wazuh-high-severity-to-iris` (id eb937a37-5244-46dc-95ff-62ad4c681322), notify-only (Log action).

## How (quirk summary for future ops)

1. **Shuffle webhook creation** is NOT the workflow trigger — it's a separate hook: `POST /api/v1/hooks/new` with `{"type":"webhook","id":"<36-char uuid>","name":"...","workflow":"<wf id>","start":"<start node id>"}`. The webhook URL is `http://<host>/api/v1/hooks/webhook_<uuid>` (backend adds the prefix). Auth: `Authorization: Bearer <SHUFFLE_API_KEY>`.
2. **OpenSearch destination API writes are disabled** in this Wazuh indexer build (POST → 405, GET only). Workaround: create destination docs directly in `.opendistro-alerting-config` with `{"destination": {"name": "...", "type": "custom_webhook", "custom_webhook": {"url": "...", "method": "POST", "header_params": {...}}}}` (type must be `custom_webhook`, not `webhook`).
3. **Monitor actions** are added via `PUT /_plugins/_alerting/monitors/{id}` with the full monitor doc; actions live under `triggers[0].query_level_trigger.actions` (the trigger is wrapped).
4. The shuffle-frontend container joined the `multi-node_default` network so OpenSearch resolves `shuffle-frontend` by name (nginx re-resolves on restart — remember `docker restart shuffle-frontend` after backend moves).

## Verified end-to-end

- Temp always-firing monitor → `_execute` → action POST → **Shuffle backend log: "Running webhook for workflow eb937a37... with startnode cc9f3618..."** ✅ (temp monitor deleted after test)
- Real monitors still fire on their own thresholds every 10 min.

## Remaining (documented)

- Workflow body is notify-only (logs the alert). Add the Shuffle → IRIS HTTP action (`/api/alert`, Bearer IRIS API key) after validation per approval-gates.md.
- IRIS binds 127.0.0.1:8443 on the host — Shuffle containers cannot reach host loopback. For the IRIS action, publish IRIS on the mct-security network (add `mct-security` network to iris-web compose nginx service) before wiring.
