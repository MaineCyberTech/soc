# Phase 55: Workflow Scope

**Prompt:** 036-workflow-scope
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27T20:35:00-0400
**Verdict:** PARTIAL

## Summary
Identify which workflows share the execution service (`shuffle-tools_1-2-0`, the app that holds the secret mount) and could therefore read the secret file.

## Evidence
- **EV-036-1 (VERIFIED):** Shuffle API (read-only `GET /api/v1/workflows`, key read programmatically, never printed) enumerates 3 workflows:
  - `e133a645-95b9-4e01-9454-e270d2a0b599` `suricata-packet-routing` (status active, 1 action).
  - `eb937a37-5244-46dc-95ff-62ad4c681322` `wazuh-high-severity-to-iris` (status test, 2 actions).
  - `e951db98-9a57-4328-8344-09f8b5b9a69f` `wazuh-flow-classb-to-iris` (2 actions).
- **EV-036-2 (VERIFIED):** The secret is mounted in the `shuffle-tools` app container. Any workflow that executes a "Shuffle Tools" action runs in that container and can technically read `/run/secrets/iris-shuffle.env`. The two IRIS-targeting workflows (`suricata-packet-routing`, `wazuh-high-severity-to-iris`) legitimately use the IRIS token; `wazuh-flow-classb-to-iris` is the additional reader candidate.
- **EV-036-3 (UNVERIFIED):** Precise per-action-to-app binding (which workflow action actually executes on the `shuffle-tools` app vs backend/other apps) was not fully introspected; the Shuffle API action detail was not enumerated per node.

## Backup-Rollback
Read-only API call; no change.

## Stop conditions
None. No workflow was modified.

## Limitations
Scope is bounded by the 3 live workflows; confirming each action's app target requires deeper Shuffle introspection (acceptable, read-only). The secret is reachable only by workflows executing on the tools app — a single app, not the whole stack.

## Verdict rationale
Workflow inventory is complete; the scope boundary (tools app = sole secret holder) is established. Per-action binding left as PARTIAL (non-blocking).
