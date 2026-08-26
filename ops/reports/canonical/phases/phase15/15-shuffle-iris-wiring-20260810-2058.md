# Shuffle → DFIR-IRIS Wiring — DONE (2026-08-10)

## Full pipeline verified end-to-end

```
OpenSearch Alerting monitor (flow-*) 
  → custom_webhook destination (http://shuffle-frontend/api/v1/hooks/webhook_<uuid>)
  → Shuffle hook → workflow wazuh-high-severity-to-iris
  → HTTP app (POST) → DFIR-IRIS /alerts/add → alert created (severity Critical, tags applied)
```

Verified 3x with test alerts (deleted after): alert creation, tags `source:wazuh,class:A`, severity Critical.

## Components added

| Piece | Detail |
|---|---|
| IRIS API key | administrator user's API key, saved ops/backups/iris-api-key.txt (600). Created via Flask shell (`secrets.token_urlsafe(48)`), NOT the UI |
| IRIS network | iriswebapp_nginx joined `mct-security` (iris-web compose change, backed up) — Shuffle containers reach it at `https://iriswebapp_nginx:8443` |
| IRIS alert schema | POST /alerts/add requires: alert_title, alert_severity_id, alert_customer_id, alert_status_id (2=New). `alert_tags` must be a COMMA-STRING ("source:wazuh,class:A"), NOT a list (schema does .split(',')) |
| Workflow action | HTTP app (app_id 0de33550-8502-403f-90c6-2f09e317d49b), action "POST", params: url/body/headers/username/password/verify=false/http_proxy/https_proxy/timeout — the HTTP app's REAL parameter names (authentication/method/skip_ssl_verify are wrong for this version) |
| Worker network | shuffle-workers + http_1-4-0 app replicas joined `mct-security` (worker must resolve shuffle-backend; app containers must resolve iriswebapp_nginx). App containers are per-replica and long-lived — connect any NEW replicas the same way |

## Gotchas found

1. Worker couldn't resolve shuffle-backend → executions stuck EXECUTING forever → `docker network connect mct-security <worker>`
2. HTTP app containers live on shuffle_swarm_executions — resolve nothing else → connect to mct-security
3. Wrong HTTP app parameter names → action FAILURE with empty output
4. `alert_tags` as list → IRIS 400 "'list' object has no attribute 'split'"
5. `${body:rule_description}` variables do NOT resolve in this Shuffle version's webhook actions — title kept static for now (rule_id/description enrichment via Shuffle variable syntax TBD)

## Remaining

- Alert escalation: alert → case (IRIS /alerts/<id>/escalate or /api) — recommended manual until validated
- Rule-level → severity mapping (currently all Critical/6; Class B same workflow — consider a second workflow with severity 5)
- Webhook variable enrichment (alert title with rule id/description)
- Repeat the `docker network connect` for any new shuffle worker/app replicas after restarts
