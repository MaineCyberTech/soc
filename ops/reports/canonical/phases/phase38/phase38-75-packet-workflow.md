# Phase 38-75 Suricata Packet Workflow Design

**Report ID:** phase38-75-packet-workflow  
**Phase:** 38  
**Title:** Phase 38-75 Isolated Suricata Packet-Routing Workflow — Design (Disabled/Test-Only)  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T21:13:25Z  
**Classification:** INTERNAL  
**Scope:** DESIGN ONLY. Workflow is NOT created in Shuffle; creation remains UI/API-gated  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Owners:** ["opencode/ox-alpha", "human-operator"]  
**Evidence Roots:** []  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-75-packet-workflow.md`  
**Retention Class:** canonical-current  

---

## 1. Purpose and Isolation Guarantees

Design a Shuffle workflow that routes selected Suricata packet events to DFIR-IRIS while being
provably inert until explicitly enabled. Isolation properties:

| # | Property | Mechanism |
|---|---|---|
| I1 | Disabled by default | Workflow created with `status="test"`; trigger left unbound from Wazuh integration until operator enables |
| I2 | No external calls | Only actions allowed: Shuffle Tools (log/regex/set-state) + HTTP action pointed at internal IRIS with test flag; no third-party destinations |
| I3 | Synthetic isolation | Any event tagged `synthetic` diverts to a sink branch BEFORE any routing action |
| I4 | Malformed input never routes | Validation branch drops to dead-letter log on missing required fields |
| I5 | Failure safety | Every external call wrapped in try/catch-style error branch → dead-letter, never crashes the run silently |

## 2. Trigger

Primary: **Wazuh integration (webhook)** — rule group `suricata`, level ≥ 7 filter at source.
Alternate for testing: **Webhook trigger** accepting POSTs shaped like a single EVE alert.
The webhook URL is NOT registered anywhere in production during this phase.

## 3. Pipeline Stages

1. **Parse**: extract JSON body → `$eve`.
2. **Normalize**: map fields — `sid=$eve.alert.signature_id`, `src=$eve.src_ip`, `dst=$eve.dest_ip`,
   `ts=$eve.timestamp`, `sev=$eve.alert.severity`.
3. **Validate**: regex-check sid is integer, src/dst are IPv4/IPv6; require non-empty ts.
   Fail → **malformed-payload branch** (dead-letter log with raw body).
4. **Synthetic-isolation branch**: if `$eve.tags` contains `synthetic` OR `test=true` → sink
   (log-only), STOP. No IRIS call regardless of content.
5. **Dedup key**: `set_state` key = `sid|src|dst|<time-bucket>` where time-bucket = ts truncated to 60s.
   If state already set within bucket → duplicate → log-and-stop (counter++).
6. **Counter**: increment per-branch counters (`routed`, `deduped`, `malformed`, `synthetic`) via
   Shuffle Tools set_state; values logged at end of each execution.
7. **Test-only route**: HTTP action to `https://iriswebapp_nginx:8443/alerts/add` guarded by
   environment check `env == "Shuffle"` AND workflow status `test`; alert title prefixed `[P38TEST]`.
8. **Dead-letter**: final Tools action appends failures to a dedicated log line
   `P38DL <reason> <raw-snippet-200c>` for later triage.

## 4. Workflow JSON Skeleton

```json
{
  "name": "wazuh-suricata-packet-to-iris",
  "description": "Isolated Suricata packet routing (P38 design - disabled/test-only)",
  "status": "test",
  "environment": "Shuffle",
  "triggers": [{
    "id": "trig-webhook-1",
    "app_name": "Webhook",
    "label": "suricata-eve-in",
    "parameters": [{"name": "custom_url", "value": "p38-suricata-test"}],
    "is_valid": true,
    "isStartNode": true
  }],
  "actions": [
    {"id": "act-parse",    "app_name": "Shuffle Tools", "label": "parse-eve-json",
     "parameters": [{"name": "call", "value": "json_dumps"}, {"name": "input", "value": "$exec"}],
     "branches": {"success": ["act-validate"], "failed": ["act-deadletter-malformed"]}},
    {"id": "act-validate", "app_name": "Shuffle Tools", "label": "validate-fields",
     "parameters": [{"name": "call", "value": "regex_capture"},
       {"name": "input", "value": "${act-parse.alert.signature_id}"},
       {"name": "regex", "value": "^[0-9]+$"}],
     "branches": {"success": ["act-synthetic-check"], "failed": ["act-deadletter-malformed"]}},
    {"id": "act-synthetic-check", "app_name": "Shuffle Tools", "label": "synthetic-isolation",
     "parameters": [{"name": "call", "value": "check_regex"},
       {"name": "input", "value": "${act-parse.tags}"}, {"name": "regex", "value": "synthetic"}],
     "branches": {"success": ["act-sink"], "failed": ["act-dedup"]}},
    {"id": "act-sink",     "app_name": "Shuffle Tools", "label": "SINK-synthetic-logonly",
     "parameters": [{"name": "call", "value": "log"}, {"name": "data", "value": "SYNTHETIC ${act-parse.alert.signature_id}"}]},
    {"id": "act-dedup",    "app_name": "Shuffle Tools", "label": "dedup-key-set",
     "parameters": [{"name": "call", "value": "set_state"},
       {"name": "key", "value": "${act-parse.alert.signature_id}|${act-parse.src_ip}|${act-parse.dest_ip}|60s-bucket"},
       {"name": "value", "value": "1"}],
     "branches": {"success": ["act-counter-route"], "failed": ["act-dedup-hit"]}},
    {"id": "act-dedup-hit","app_name": "Shuffle Tools", "label": "duplicate-drop",
     "parameters": [{"name": "call", "value": "log"}, {"name": "data", "value": "DUP"}]},
    {"id": "act-counter-route", "app_name": "Shuffle Tools", "label": "counter-routed",
     "parameters": [{"name": "call", "value": "set_state"}, {"name": "key", "value": "p38_counter_routed"},
       {"name": "value", "value": "${state.p38_counter_routed | 0 + 1}"}],
     "branches": {"success": ["act-iris-test"]}},
    {"id": "act-iris-test","app_name": "HTTP", "label": "iris-alert-P38TEST-internal-only",
     "parameters": [{"name": "url", "value": "https://iriswebapp_nginx:8443/alerts/add"},
       {"name": "body", "value": "{\"alert_title\": \"[P38TEST] suricata sid ${act-parse.alert.signature_id}\", \"alert_source\": \"suricata\", \"alert_source_ref\": \"${act-parse.alert.signature_id}\", \"alert_customer_id\": 1, \"alert_severity_id\": 4}"},
       {"name": "headers", "value": "{\"Authorization\": \"Bearer <FROM_DATASTORE>\", \"Content-Type\": \"application/json\"}"},
       {"name": "verify", "value": false}],
     "branches": {"success": ["act-done"], "failed": ["act-deadletter-fail"]}},
    {"id": "act-done",     "app_name": "Shuffle Tools", "label": "done-log",
     "parameters": [{"name": "call", "value": "log"}, {"name": "data", "value": "ROUTED OK"}]},
    {"id": "act-deadletter-malformed", "app_name": "Shuffle Tools", "label": "DEADLETTER-malformed",
     "parameters": [{"name": "call", "value": "log"}, {"name": "data", "value": "P38DL MALFORMED ${exec}"}]},
    {"id": "act-deadletter-fail", "app_name": "Shuffle Tools", "label": "DEADLETTER-target-fail",
     "parameters": [{"name": "call", "value": "log"}, {"name": "data", "value": "P38DL TARGETFAIL"}]}
  ]
}
```

Skeleton only — node IDs/branch syntax to be normalized by the UI import path.

## 5. Pre-Creation Backup & Rollback (for when creation IS approved)

```bash
# backup BEFORE any change (export all workflows)
curl -s -H "Authorization: Bearer <TOKEN>" http://127.0.0.1:5001/api/v1/workflows \
  -o ops/evidence/p38-workflow-export/pre-change-full-$(date -u +%Y%m%dT%H%M%SZ).json
sha256sum ops/evidence/p38-workflow-export/pre-change-full-*.json >> ops/evidence/p38-workflow-export/SHA256SUMS.txt
```

Rollback options:
- New workflow: delete it in UI (**Workflows → ⋯ → Delete**) or `DELETE /api/v1/workflows/<id>`.
- Edited existing workflow: re-import the exported JSON copy (UI: Workflows → Import).
- Verify rollback by comparing fresh export hash against pre-change export for untouched workflows.

## 6. Explicit Non-Actions This Phase

- Workflow NOT created (UI/API-gated; see phase38-77 decision).
- Webhook URL NOT registered in ossec.conf integration blocks.
- No changes to the two existing workflows' definitions or statuses.

Proof methodology for once it exists: phase38-76.
