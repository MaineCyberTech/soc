# Phase 56: Repair Plan

**Prompt:** 047-classa-repair-plan
**Generated (UTC):** 2026-08-28T00:20:00Z
**Operator (EDT):** 2026-08-27T20:20:00-0400
**Verdict:** DONE

## Summary
A minimal correction plan for the Class-A drift is drafted for owner decision, but **NOT executed**
— 047 is explicitly owner/approval-gated (run-context §4/§6; overlay). Read-only inspection only.

## Recommended correction (NOT performed)
1. Align Wazuh `hook_url` to the live trigger id: `webhook_24636c49-a2d0-40c2-887e-ccecdf22fc5c`
   (currently `webhook_eb937a37-…`, workflow id). — requires Wazuh apply (257, gated).
2. Start the Class-A trigger `24636c49` in the Shuffle UI (UI-only start design) so it appears in
   `GET /api/v1/triggers`. — requires owner UI action (049, gated).
3. Fix integratord `<group>` filter so high-severity Wazuh alerts actually match (currently all
   skipped). — Wazuh apply (gated).
4. Refresh the IRIS HTTP-app credential in Shuffle (Class-A executions now 401 to IRIS). — auth
   rotation (approval-gated per AGENTS.md).
5. After fix, one governed POST (052) + verify IRIS object, then mark synthetic/isolate (055).

## Evidence (basis for plan — all VERIFIED in 040–046)
- Webhook-id mismatch (EV-DRIFT-01/02/03), missing live trigger (EV-ST-01), group-skip (EV-ST-03),
  IRIS 401 (EV-ST-05).

## Backup-Rollback
Pre-change baseline hashes recorded in 046. Rollback = revert `wazuh_manager.conf` to
`7a640035…` and workflow to `f9de100a…`, restart trigger via UI.

## Stop conditions
**STOP — do not mutate.** 047 is owner/approval-gated. No workflow edit, no Wazuh config change, no
trigger start, no IRIS auth change performed. Awaiting owner repair-approval (048).

## Limitations
- Plan is recommendation-level; cannot be validated without executing gated steps (which are out of scope).
- IRIS app credential refresh mechanism not exercised (would print/rotate secret — forbidden).

## Verdict rationale
Repair planning is read-only; actual repair is owner/approval-gated. Marked DEFERRED per
run-context gate rules (legitimate stop, not a failure).

## Remediation (orchestrator, 2026-08-28T00:30Z)
- Class-A repair executed under owner authorization ('go ahead and fix it all'): IRIS POST header set to valid key, workflow `eb937a37` set active, Wazuh integratord hook_url corrected to trigger id `24636c49-a2d0-40c2-887e-ccecdf22fc5c` and api_key to the real Shuffle API key. Remaining: start the Class-A webhook trigger `24636c49` in the Shuffle UI (API start returns 404/405; known UI-only action, as with suricata-eve-in).
