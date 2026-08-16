# Wazuh -> DFIR-IRIS Integration

## Flow

```text
Wazuh / OpenSearch alert (class A/B)
  -> Shuffle webhook (HTTP POST)
  -> optional MISP enrichment (tag source, confidence)
  -> DFIR-IRIS alert creation via API
  -> auto-promote to case based on rule level/type
```

## Webhook contract

- Source: Wazuh manager (active response `command: custom-slack` style or OpenSearch Alerting webhook), or Security Onion events (arrive in Wazuh via agent 008 zeek-forward/suricata intake).
- Trigger: alert level >= 8 or listed class A/B rule IDs.
- Payload: see `integrations/shuffle/webhook-contracts/*.json` and `integrations/payload-contracts/wazuh-high-severity.json`.
- Destination: Shuffle webhook endpoint; Shuffle workflow `wazuh-high-severity-to-iris`.

## DFIR-IRIS API (placeholder)

```text
POST {IRIS_BASE}/api/alert
Headers: Authorization: Bearer <REDACTED_IRIS_API_KEY>  (API key via IRIS Admin -> API keys)
Body:
{
  "alert_title": "Wazuh rule <rule_id> on <agent_name>",
  "alert_severity": 3,
  "alert_source": "wazuh",
  "alert_ref": "<wazuh alert id>",
  "alert_source_link": "<REDACTED_URL>",
  "alert_customer_id": 1,
  "alert_assets": ["<REDACTED_HOST>"],
  "alert_tags": ["source:wazuh", "class:A"]
}
```

Promote to case: `POST /api/alert/<id>/promote` or via Shuffle workflow based on rule family.

## Failure modes

| Failure | Effect | Handling |
|---|---|---|
| IRIS API down | Alert stays in Shuffle queue | Shuffle retry with backoff; alert logged to local file |
| Shuffle down | Webhook rejected | Wazuh alert remains in OpenSearch; replay from archive |
| Invalid API key | 401 from IRIS | Check IRIS API key; alert logged to local file |
| Duplicate alert | IRIS dedupes by alert_ref | No action |

## Acceptance test

Send `integrations/payload-contracts/wazuh-high-severity.json` to the Shuffle webhook; expect an IRIS alert with matching title, and for level >= 10 a case created.

## Data retention

- IRIS alerts: kept per IRIS retention policy (configured in IRIS); export to OpenSearch/backup monthly.
- Case data backed up per `ops/runbooks/phase2-backup.md`.
