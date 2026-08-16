# Alert Routing Runbook

Purpose: route alerts to the right destinations before they reach humans, per class A-D.

## Routing model

| Class | SLA | Destination | Channel |
|---|---|---|---|
| A (Immediate) | < 10 min | DFIR-IRIS alert + case, immediate notify | Slack/email via OpenSearch Alerting webhook -> Shuffle -> IRIS + channel |
| B (Same-day) | < 1 day | DFIR-IRIS alert (no auto-case), review queue | Digest (daily) |
| C (Daily digest) | Daily | Report only | Daily digest email |
| D (Archive only) | None | OpenSearch only | No notification |

## Existing monitors

Every existing OpenSearch monitor gets a route decision — see `integrations/opensearch-alerting/monitor-routing-map.md`. Monitors without a decision are routed Class D by default until reviewed.

## Notification channels

- OpenSearch Alerting destinations (documented placeholders in `notification-channels.md`): Slack webhook, email (existing postfix on 127.0.0.1), webhook to Shuffle.
- High-confidence alerts (Class A) go to both IRIS (via Shuffle) and the notify channel.
- Noisy alerts stay in digest/reporting only.

## Tuning process

1. Measure alert volume per rule for 7 days (OpenSearch query on `wazuh-alerts-*`).
2. Rules with > 100/day and zero actionable outcomes -> demote to Class C/D.
3. Rules with actionable outcomes but low volume -> promote to Class B/A.
4. Record every change in `ops/reports` with before/after counts.
5. Never change rule levels blindly — adjust routing (class) first, levels only with evidence.

## Failure modes

| Failure | Effect | Handling |
|---|---|---|
| Shuffle down | Class A path broken | OpenSearch Alerting retries webhook; alert stays in OpenSearch; fallback email destination |
| Notify channel down | No human notification | Email fallback; digest still produced |
| IRIS down | Case creation fails | Alert logged locally; manual case later |
| Monitor over-threshold | Alert storm | Route Class C; investigate monitor query |

## Acceptance

- Every existing monitor has a route decision.
- Channels documented or configured.
- High-severity test alert has a defined path (test event -> OpenSearch monitor -> webhook -> Shuffle log/IRIS).
- Tuning process exists.
