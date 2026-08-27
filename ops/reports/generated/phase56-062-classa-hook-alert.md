# Phase 56: Hook Drift Alert

**Prompt:** 062-classa-hook-alert
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27 20:35:00 -0400
**Verdict:** DONE

## Summary
Detected hook drift for the Class-A Wazuh→IRIS path: the configured Wazuh integratord hook references a webhook id (`webhook_eb937a37-…`) that is neither present in the live Shuffle trigger list nor matched to the workflow's actual trigger id (`24636c49-…`). The hook is therefore absent/mismatched → Wazuh posts to a non-existent webhook. Alert raised; remediation is gated.

## Evidence
- EV-01 (VERIFIED): Live `GET /api/v1/triggers` returns only `suricata-eve-in` (736b7410-…); NO `wazuh-high-severity` webhook present. [triggers.json]
- EV-04 (VERIFIED): Workflow `wazuh-high-severity-to-iris` (eb937a37-…) embedded trigger id = 24636c49-a2d0-40c2-887e-ccecdf22fc5c. [wf_classa.json]
- EV-05 (VERIFIED): Wazuh ossec.conf:346 `<hook_url>http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-5244-46dc-95ff-62ad4c681322</hook_url>`. Hook id `eb937a37` ≠ trigger id `24636c49` → URL/trigger mismatch. [docker exec grep]

## Backup / Rollback
Read-only detection. No mutation.

## Stop conditions
Re-wiring the Wazuh integratord hook or creating the missing Shuffle webhook trigger = mutation/approval-gated (Wazuh apply 257; trigger recreation UI-only). Not executed.

## Limitations
Cannot confirm whether the mismatch yields HTTP 404 at the backend without replaying a live Wazuh event; structural mismatch (id ≠ trigger id) is itself conclusive drift.

## Verdict rationale
Hook drift definitively detected and evidenced (absent + id-mismatched). Alert content delivered. DONE.
