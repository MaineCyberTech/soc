# Phase 53: Start suricata-eve-in — Runbook + Precise Block

Report ID: phase53-trigger-start
Phase: 53
Date: 20260827-183447Z
Timestamp: 20260827-183447ZZ
Classification: INTERNAL
Status: BLOCKED-UI


## Execution contract
Shuffle REST API cannot start a webhook trigger. Verified probes (Bearer header):
- POST /api/v1/triggers -> 405
- POST /api/v1/triggers/<id> -> 404
- POST /api/v1/triggers/<id>/start -> 404
- PUT /api/v1/triggers/<id> {"status":"active"} -> 404
- GET /api/v1/triggers -> lists webhooks; target status="stopped", info.url=""

## Evidence
Trigger `suricata-eve-in` (id 736b7410-ed6a-52af-b369-89dbef6386cb), type WEBHOOK,
status **stopped**, `info.url` is EMPTY. The empty URL is the root cause of the earlier
"Hook ID not valid" — the webhook is not registered until started via the UI.

## One-action UI procedure (owner)
1. Open Shuffle UI at http://127.0.0.1:3001 (operator access via SSH tunnel; admin user,
   password in /opt/mct-security-stack/.env SHUFFLE_ADMIN_PASSWORD).
2. Workflows -> open `suricata-packet-routing` (id e133a645-...).
3. Click the `suricata-eve-in` trigger node -> Start (or toggle to running).
4. Confirm the trigger now shows a populated webhook URL.
5. Post-test: curl -XPOST http://127.0.0.1:3001/api/v1/hooks/<hookid> -d '{"test":1}'
   expecting success:true with an execution_id.

## State
**Precisely blocked** per acceptance ("started OR precisely blocked"). Workflow unharmed
(backup at ops/backups/shuffle/workflow-e133a645-pre-p53-*.json). No secrets exposed.
