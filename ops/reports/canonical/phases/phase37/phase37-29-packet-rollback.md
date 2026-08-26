# Phase 37-29: Rollback Design

**Date:** 2026-08-25
**Status:** DESIGN
**Owner:** 39dd09d3

## Purpose

Define rollback procedures for the `mct-suricata-packet-routing` workflow to ensure safe teardown without side effects.

## Rollback Actions

### 1. Disable Workflow

- Set workflow status to **disabled**
- Webhook `mct-suricata-packet` stops receiving events
- No new routes, cases, or counter increments
- Existing datastore entries persist (TTL-based cleanup handles expiry)

### 2. Restore Previous Revision

- If workflow was modified, restore to prior revision via Shuffle UI
- Previous revision's state behavior matches pre-modification baseline
- Validates that rollback produces expected behavior

### 3. Delete Workflow

- Full teardown: workflow and webhook removed
- Webhook endpoint is deallocated
- No dangling routes or orphaned triggers
- Use only if complete removal is required

## Post-Rollback Verification

| Check | Expected Result |
|---|---|
| Webhook responds to POST | 404 or connection refused |
| No new executions after disable | Execution count frozen |
| No new routes after disable | Route actions stopped |
| No new cases after disable | IRIS cases unaffected |
| Datastore entries | Expire via TTL, no manual cleanup needed |

## External Guardrail Impact

- P33 cron guardrail (`0 3 * * *`, `alert-runner.sh`) is **unchanged**
- Kill switch (`/opt/mct-security-stack/ops/scripts/mct-kill-switch.sh`) remains functional
- Analysisd independent operations unaffected
- Rollback is isolated to Shuffle workflow only

## Safety Guarantee

After rollback:
- Webhook is safe (not receiving events)
- No dangling routes (workflow disabled or deleted)
- No orphaned triggers
- External guardrail unchanged
- Production alerting unaffected

## No secrets
