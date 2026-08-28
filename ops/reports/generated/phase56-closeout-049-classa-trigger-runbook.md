# Phase 56 Closeout: Trigger Start Runbook

**UTC:** 2026-08-28T00:25:31Z
**America/New_York:** 2026-08-27 20:25:31 EDT

## Prompt
Document the exact Shuffle UI action to start trigger `24636c49` and its postchecks.

## Task
Produce the operator runbook (UI-only) for starting the wazuh→iris Shuffle trigger and the verification steps after.

## Evidence
- EB §2: trigger `24636c49-a2d0-40c2-887e-ccecdf22fc5c` status=running in workflow metadata, but webhook `webhook_24636c49-...` is NOT live until started in the Shuffle UI (REST start returns 404/405 — UI-only, same pattern as suricata-eve-in).
- EB §10: trigger UI-start is an operator action and a remaining Class-A gate.
- README priority 12: "Start `24636c49-...` only through the supported Shuffle UI path."

## Method
READ-ONLY-INSPECTION — runbook authored from EB; no trigger started.

## Backup
none — read-only documentation.

## Rollback
Stop the trigger in the Shuffle UI to return to current (metadata-running / webhook-not-live) state.

## Stop conditions
Actual start is UI-only and is NOT performed by this closeout (see 050). This report documents the runbook only.

## Limitations
Cannot confirm post-start webhook liveness from closeout; postchecks (live intake, successful POST) require the operator UI action.

## Verdict
DONE — runbook documented (Shuffle UI → start trigger `24636c49`; postchecks: webhook live, labeled synthetic POST accepted). Execution of the start remains operator UI action (050).
