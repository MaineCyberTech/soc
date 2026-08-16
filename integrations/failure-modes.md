# Integration Failure Modes

Consolidated failure handling across all stack integration routes.

| Route | Failure | Detection | Handling | Owner runbook |
|---|---|---|---|---|
| Wazuh -> Shuffle | Webhook rejected / bad payload | Shuffle logs 4xx | Validate payload vs contract; alert stays in OpenSearch; replay | shuffle.md |
| Shuffle -> IRIS | IRIS API down / 401 | Workflow error state | 3x retry with backoff; log locally; manual case later | dfir-iris.md |
| MISP -> Wazuh CDB | CDB syntax error | analysisd errors on restart | Validate with wazuh-logtest before restart; keep previous list backup | misp-to-wazuh-cdb.md |
| MISP -> CDB | MISP API down | cron failure alert | Keep last CDB; alert on cron failure | misp.md |
| OpenCanary -> Wazuh | Syslog not parsed | No rules fire | Check decoder with wazuh-logtest; check 15140/udp+tcp receipt | opencanary.md |
| Greenbone -> IRIS | Webhook fails | Greenbone alert log | Export report manually; create case manually | critical-finding-to-iris.md |
| Velociraptor -> IRIS | Upload too large / client offline | IRIS upload error / hunt pending | Store zip in backup share + reference; retry hunt | dfir-iris-evidence-workflow.md |
| SO -> Wazuh | agent 008 intake stalls | Healthcheck / indexer | Restart zeek-forward service or wazuh-agent on SO VM; verify conn.log growing | so-bridge-validation.md |
| Reporting | OpenSearch query fails | Script error | Sample data + DRAFT mark; previous report retained | client-reporting.md |
| All webhooks | Shuffle down | 5xx from webhook endpoint | Sources keep data; fallback email channel; replay after recovery | alert-routing.md |

## Global rules

1. Sources of truth (OpenSearch, SO Elasticsearch, Wazuh archive) are never destroyed by a failed consumer.
2. Every failure must be visible: healthcheck script, alert on cron failure, digest.
3. Response automations fail-safe: blocking actions default to NO-OP on error.
4. Replays are possible from the source indices; log the replay window in the case.

## Healthcheck coverage

`ops/scripts/phase2-healthcheck.sh` checks: containers up, IRIS API, MISP API, Shuffle webhook, Greenbone API (if deployed), OpenCanary log activity, Velociraptor GUI, CDB cron freshness.
