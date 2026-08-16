# Shuffle SOAR Runbook

Purpose: Shuffle deployment, webhook intake, workflow management, and approval gates for the MCT Security Stack.

## Preconditions

- `mct-security` network exists; `.env` has `SHUFFLE_ADMIN_PASSWORD`.
- Wazuh/OpenSearch alert channels exist (phase 11) so webhooks have a source.

## Deploy

```bash
cd /opt/mct-security-stack
docker compose -f compose/docker-compose.shuffle.yml --profile shuffle up -d
docker compose -f compose/docker-compose.shuffle.yml --profile shuffle logs -f shuffle
```

## First login

- URL: `http://127.0.0.1:3001` (local only). Login as `admin` with `SHUFFLE_ADMIN_PASSWORD`. Create an org (`mct-soc`) and change the password after first login.
- Remote access only via Cloudflare Access-protected tunnel.

## Webhooks

- Create a Webhook trigger per intake path (one per Wazuh rule family or per monitor).
- Payload contracts: `integrations/shuffle/webhook-contracts/*.json`.
- Wazuh side: point OpenSearch Alerting notification or a custom Slack-style command at the Shuffle webhook URL with `Content-Type: application/json`.

## Workflows (all notify-only by default)

Workflow specs live in `integrations/shuffle/workflows/*.md`:

- wazuh-high-severity-to-iris
- flow-unknown-exporter-to-case
- opencanary-hit-to-case
- critical-vuln-to-case
- active-response-audit
- misp-ioc-enrichment
- security-onion-alert-to-iris (SUPERSEDED 2026-08-15 - SO events route via agent 008 -> Wazuh -> wazuh-high-severity-to-iris)
- open-enrollment-window-manual-approval
- close-enrollment-window
- monthly-report-build-trigger

Each workflow must begin in notify-only mode: actions that create cases must be preceded by a comment step and, for anything blocking, by an approval gate (see `approval-gates.md`).

## Approval gates

- Any workflow touching the network (firewall drops, agent disconnects) requires a manual approval gate and must be disabled until tested.
- Gate pattern: workflow stops at `User Input` node; operator approves in Shuffle UI or via webhook callback; approval logged.

## Failure modes

| Failure | Handling |
|---|---|
| Webhook rejected (bad payload) | Check payload contract; Shuffle logs show validation error; alert stays in OpenSearch |
| Workflow crash | Workflow remains in error state; re-run from failed node; alert replayable |
| IRIS down | Workflow retries; log to local file via `File` app |
| API key invalid | Shuffle app errors; rotate key in app config |

## Backup

- Workflows are part of Shuffle's database (`shuffle-data` volume) — required backup per `phase2-backup.md`.
- Export workflow JSON manually from UI (Workflows -> Export) into `ops/backups/shuffle-workflows-<date>.json`.

## Rollback

```bash
docker compose -f compose/docker-compose.shuffle.yml --profile shuffle down
```

Keep `shuffle-data` unless destroying. Disable OpenSearch Alerting webhook notifications (phase 11) as the first rollback step so alerts do not hit a dead endpoint.

## Validation

- Shuffle starts; one test webhook payload accepted (`integrations/payload-contracts/wazuh-high-severity.json`).
- A test workflow creates a placeholder IRIS alert or writes to a local log.
- Destructive actions disabled without manual approval.
