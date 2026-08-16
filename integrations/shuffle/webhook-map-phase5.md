# Shuffle Webhook Map (Phase 5)

Canonical mapping of alert sources -> Shuffle webhook triggers -> workflows.

## Shuffle workflows (verified 2026-08-11 via API)

| Workflow | ID | Webhook trigger | Purpose |
|---|---|---|---|
| wazuh-high-severity-to-iris | eb937a37-5244-46dc-95ff-62ad4c681322 | `wazuh-high-severity` | Class A alerts -> IRIS alert (notify-only) |
| wazuh-flow-classb-to-iris | e951db98-9a57-4328-8344-09f8b5b9a69f | (no webhook trigger) | Class B flow alerts -> IRIS alert |

## OpenSearch monitor -> Shuffle webhook (verified)

| Monitor | Destination ID | Webhook URL pattern | Class |
|---|---|---|---|
| flow-unknown-exporter | NXsn7Z8BrR5di7YESBuW | /api/v1/hooks/webhook_<trigger> | A |
| flow-lateral-movement | NXsn7Z8BrR5di7YESBuW | (same Class A dest) | A |
| opencanary-hit | NXsn7Z8BrR5di7YESBuW | (same Class A dest) | A |
| flow-unusual-ports | 7Hso7Z8BrR5di7YEIh4O | (Class B dest) | B |
| flow-icmp-flood | 7Hso7Z8BrR5di7YEIh4O | (same) | B |
| flow-high-outbound-bytes | 7Hso7Z8BrR5di7YEIh4O | (same) | B |

Webhook URL pattern: `http://shuffle-frontend/api/v1/hooks/webhook_<trigger-id>`
(host-side: `http://127.0.0.1:3001/api/v1/hooks/webhook_<trigger-id>`).

## D5 / D8 webhook status

| Drill | Webhook | Status |
|---|---|---|
| D5 Greenbone critical | No dedicated greenbone trigger exists | BLOCKER documented (reuse wazuh-high-severity trigger or create workflow) |
| D8 Security Onion | SO alerts route via agent 008 -> Wazuh -> (monitor path) | SO->Shuffle webhook not configured - use wazuh-high-severity trigger for SO bridge events |

## Gaps

1. Only 2 workflows; Phase 2 docs reference more (opencanary-hit-to-case,
   critical-vuln-to-case, security-onion-alert-to-iris) - not deployed.
2. wazuh-flow-classb-to-iris has NO webhook trigger - Class B monitors write
   to it via destination but the workflow may not fire.
3. Trigger IDs must be obtained from Shuffle UI (webhook page) when creating
   new workflows.

## Canonical webhook URLs (host-side, for tests)

```text
Class A:  http://127.0.0.1:3001/api/v1/hooks/webhook_24636c49-a2d0-40c2-887e-ccecdf22fc5c
           (wazuh-high-severity trigger)
```

## Fallback (variable substitution unreliable)

- Static title + raw payload body (see variable-substitution-fallback-final.md).
- Never drop events because templating failed.
