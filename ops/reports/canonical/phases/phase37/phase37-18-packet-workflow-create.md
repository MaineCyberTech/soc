# Phase 37-18: Packet Workflow Creation

**Date:** 2026-08-25
**Status:** APPROVAL-GATED — Design document for operator implementation
**Owner:** 39dd09d3

## Workflow Specification

| Field | Value |
|---|---|
| Name | `mct-suricata-packet-routing` |
| Status | **disabled / test-only** |
| Owner | 39dd09d3 |
| Trigger | Webhook `mct-suricata-packet` |
| Rollback | Disable or delete workflow |

## Workflow Actions (Sequential)

### Action 1: Normalize Fields
Parse incoming Suricata/Wazuh payload. Map raw fields to normalized schema (see phase37-19). Inject `is_synthetic`, `test_id`, `tenant`, `routing_class` fields.

### Action 2: Validate Required Fields
Check `timestamp`, `agent_id`, `event_type` are present and non-empty. On failure → route to malformed branch (see phase37-25).

### Action 3: Check Dedup Key
Compute SHA256 dedup key (see phase37-21). Query Shuffle datastore. First-seen → proceed. Duplicate → suppress and increment `dup_counter`.

### Action 4: Route to Test Group (Notify-Only)
Approved synthetic SIDs and explicit test events → test group notification. Production SIDs → observe-only, no route. No IRIS case creation for any test events.

## Implementation Note

This is a **design document**. Actual workflow creation requires Shuffle UI to:
1. Create the webhook trigger `mct-suricata-packet`
2. Build the action chain via the visual editor
3. Configure the datastore category for dedup and counters
4. Set the workflow to disabled/test-only status

The operator must implement this design in the Shuffle UI before any test execution.

## Rollback

- **Disable workflow:** Webhook stops receiving events. No routes, no cases.
- **Delete workflow:** Full teardown. Webhook endpoint removed.

## Post-Creation Verification

1. Confirm webhook `mct-suricata-packet` responds to POST with 200
2. Confirm all 4 actions are present and linked
3. Confirm workflow status is disabled
4. Confirm datastore category exists for dedup and counters

## No secrets
