# Phase 26 Zeek Workflow Inventory

Date: 2026-08-23

## Active workflow: wazuh-high-severity-to-iris

- id: eb937a37-5244-46dc-95ff-62ad4c681322
- Trigger: webhook `wazuh-high-severity` (id 24636c49-a2d0-40c2-887e-ccecdf22fc5c) - hook
  `http://shuffle-frontend/api/v1/hooks/webhook_24636c49-a2d0-40c2-887e-ccecdf22fc5c`
- Path: webhook -> action "Log received alert (notify-only)" (Shuffle Tools) ->
  action "Create DFIR-IRIS alert (notify-only)" (HTTP POST to iriswebapp_nginx:8443/alerts/add)
- Error/notification: no explicit error/notify branch (relies on workflow execution status).

## Versioning

- Workflow unchanged since P5/P17; exported JSON retained (P25 fetch). Integration version:
  Phase 25 block (rule_id 122001-122003) + Phase 26 guardrail (zeek-classa-guardrail.sh v2).

## Guardrail overlay (Phase 26)

- `ops/scripts/zeek-classa-guardrail.sh` (cron */15): counts workflow executions/24h; >= 5 ->
  comments the Wazuh integration block (kill switch) + restarts the container; manual
  enable/disable modes. Kill-switch mechanism verified.

## No secrets