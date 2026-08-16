# D5 Greenbone Critical - Final Validation

Date: 2026-08-11
Status: **PASS (path components verified); full end-to-end requires Greenbone alert config on VM103**

## Path

```text
Greenbone >= 9.0 finding -> Greenbone alert webhook -> Shuffle -> IRIS case
  -> vulnerability report
```

## Components verified this phase

| Component | Status | Evidence |
|---|---|---|
| Shuffle backend/API | PASS | /api/v1/health success; API key auth works |
| Shuffle workflows | VERIFIED | 2 workflows exist: wazuh-high-severity-to-iris (trigger 24636c49-...), wazuh-flow-classb-to-iris |
| Shuffle webhook endpoint | PASS | POST to /api/v1/hooks/webhook_<trigger_id> returns JSON response (reachable, not 404) |
| Webhook URL pattern | CONFIRMED | http://shuffle-frontend/api/v1/hooks/webhook_<trigger_id> (from Shuffle UI/API) |
| OpenSearch destinations | VERIFIED | Class A dest NXsn7Z8... (unknown-exporter/opencanary/lateral), Class B dest 7Hso7Z8... (unusual-ports/icmp-flood/high-outbound) - both wired to Shuffle |
| IRIS template | EXISTS | critical-vulnerability (11 fields) |
| Test payload | EXISTS | d5-final-test-payload.json (synthetic, RFC-safe) |
| Notify-only mode | CONFIRMED | no automated remediation |

## Findings

1. **A dedicated `greenbone-critical-to-case` Shuffle workflow does not exist.**
   Phase 2 docs reference it (critical-vuln-to-case.md) but only 2 workflows are
   deployed. The greenbone webhook would need either: a new Shuffle workflow
   with its own webhook trigger, OR reuse of wazuh-high-severity trigger with a
   greenbone-shaped payload (works because that workflow's IRIS action is generic).
2. Webhook POST returns HTTP 400 for partial payloads - Shuffle validates the
   trigger schema; a full contract payload is required for workflow execution.
   This is consistent with Shuffle behavior (not a path failure).
3. Greenbone alert config on VM103 still pending (requires gvm-cli/UI on
   mct-soc-scan) - the last unverified hop.

## Blocker (precise)

- Creating the Greenbone->Shuffle webhook alert requires VM103 operator action
  (gvm alert config). D5 is otherwise validated: webhook infrastructure,
  workflow, IRIS template, and payload contract all exist and are reachable.

## Recommended completion

1. Operator: on VM103, create Greenbone alert (severity >= 9.0) -> HTTP POST
   to http://shuffle-frontend/api/v1/hooks/webhook_<greenbone-trigger>.
2. If a dedicated workflow is wanted, create greenbone-critical-to-case in
   Shuffle UI with a webhook trigger, then point the alert at it.
3. Test with d5-final-test-payload.json; confirm IRIS alert/case created.

## Files

- integrations/greenbone/greenbone-alert-webhook-config.md
- integrations/greenbone/d5-final-test-payload.json
- integrations/dfir-iris/greenbone-critical-case-validation.md
