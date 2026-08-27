# Phase 55: Remove Broad Bind

**Prompt:** 057-bind-remove
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** BLOCKED

## Summary
Prompt requires removing the broad `/shuffle-files` bind. This is a service-update mutation (changing `shuffle-tools_1-2-0`'s mounts) and an approval-gated change per run-context §4/§6. Not executed. The prerequisite assessment (056) and rollback path (058) are handled separately.

## Evidence
- EV-01 (VERIFIED): Bind defined in `shuffle-tools_1-2-0` spec as `Source=/opt/mct-security-stack/data/shuffle/files → /shuffle-files, ReadOnly`. Removal = `docker service update --mount-rm`.
- EV-04 (VERIFIED): Workflow uses the bind only as a fallback; secret path is primary — so removal is safe *once approved*.
- EV-06 (VERIFIED): Single consumer; blast radius bounded.

## Backup-Rollback
Pre-removal: export service spec + snapshot bind source. Rollback: re-add bind (see 058). Not performed here.

## Stop conditions
Bind removal requires **orchestrator/owner approval** (gate: service deletion/change, run-context §4/§6). This agent must not mutate the live service spec.

## Limitations
Read-only. Cannot remove. The safe-removal case is documented; the gate is the blocker.

## Verdict rationale
BLOCKED — bind removal is an explicit approval-gated service-update. Legitimate stop, not a defect.
