# Alert Routing Complete — Class A/B + OpenCanary → IRIS (2026-08-10)

## Verified live routes

| Route | Source | Trigger | Workflow | IRIS severity | Verified |
|---|---|---|---|---|---|
| Class A flow | flow-unknown-exporter, flow-lateral-movement monitors | custom_webhook → hook A | wazuh-high-severity-to-iris | Critical (6) | Yes (3x) |
| Class B flow | flow-icmp-flood, flow-high-outbound-bytes, flow-unusual-ports monitors | custom_webhook → hook B | wazuh-flow-classb-to-iris (NEW) | High (5) | Yes |
| OpenCanary | NEW monitor `opencanary-hit` (wazuh-alerts-4.x-*, rule.groups=opencanary, level 12, 1-min) | hook A | wazuh-high-severity-to-iris | Critical (6) | Yes (canary hit → alert #6 in 5s) |

## New components

1. **OpenCanary monitor** (id h3yA7Z8BrR5di7YECVwC): queries wazuh-alerts-4.x-* for opencanary level-12 alerts in last 2 min; fires Class A webhook; message carries data.src_host. Scanner hits suppressed at the rule level (121099) so Greenbone scans don't spam IRIS.
2. **Class B workflow** `wazuh-flow-classb-to-iris` (id e951db98-9a57-4328-8344-09f8b5b9a69f): clone of Class A with severity 5 + class:B tag; hook B recreated pointing at it.
3. Hook repoint method (no update API in this build): DELETE fails ("Hook ID not valid" — needs webhook_ URL), but `POST /api/v1/hooks/new` with the SAME uuid + new workflow/start replaces the hook.

## Verified end-to-end chain (canary)

canary port hit → Wazuh rule 121012 (level 12) → wazuh-alerts-4.x-* → OpenSearch monitor (1-min) → shuffle-frontend webhook → workflow → HTTP app → IRIS /alerts/add → alert (Critical, tags source:wazuh,class:A). Alert created 5s after webhook fire.

## Open items

- `${body:...}` webhook variables do not resolve in this Shuffle build (tested 3 syntaxes; literal in output) — titles static. Enrichment via Shuffle variables TBD.
- Alert → case escalation (IRIS /alerts/<id>/escalate) — manual for now (approval gate).
- New Shuffle worker/app replicas after restarts need `docker network connect mct-security` (repeat documented in 15-shuffle-iris-wiring).
