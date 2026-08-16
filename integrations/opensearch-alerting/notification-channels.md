# OpenSearch Alerting Notification Channels

Documented placeholders. Real URLs live in the protected secret store; never in this file.

## Channel types

| Channel | Transport | Use | Status |
|---|---|---|---|
| Shuffle webhook | custom_webhook destination (`.opendistro-alerting-config`) | Class A/B → IRIS alert creation | **CONFIGURED + VERIFIED 2026-08-10** (2 destinations, 6 monitors) |
| IRIS API | POST `{IRIS}/api/alerts/add` (Bearer API key) via Shuffle HTTP app | Alert creation (Critical/High) | **CONFIGURED + VERIFIED** |
| Email (postfix) | OpenSearch Alerting email destination -> 127.0.0.1:25 | Class B/C digests | PLANNED (postfix on host exists) |
| Canary alert | monitor `opencanary-hit` → Shuffle webhook A | Deception hits | **CONFIGURED + VERIFIED** |

## OpenSearch Alerting setup (DONE 2026-08-10 — see ops/reports/15-alert-routing-complete-20260810-2117.md)

1. Destinations created directly in `.opendistro-alerting-config` (the API write path is disabled on this indexer build): `shuffle-webhook-classA`, `shuffle-webhook-classB` (type `custom_webhook`, URL `http://shuffle-frontend/api/v1/hooks/webhook_<uuid>`).
2. Monitor actions added under `triggers[0].query_level_trigger.actions` for all 6 monitors (5 flow + opencanary-hit).
3. Alert JSON body matches the Shuffle webhook contract (rule_id, level, description, srcip/dstip, timestamp).
4. Verified end-to-end with a temp always-firing monitor + real canary hit.

## Notification policy

- Class A: immediate (Shuffle webhook → IRIS alert; Slack email fallback not yet configured).
- Class B: Shuffle webhook → IRIS alert (High); daily email digest planned.
- Class C: daily digest.
- Class D: none.

## Security

- Webhook URLs with embedded tokens are secrets — store in the secret store, reference by name in docs.
- Postfix relays only from 127.0.0.1 (already bound); do not expose 25 publicly.
