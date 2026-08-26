# Phase 41 Packet Workflow Import — Success Record With Offender-Field Elimination And Hook Registration Saga

**Report ID:** phase41-42-import
**Phase:** 41
**Title:** IMP-PKT-41-01 — suricata-packet-routing Imported Via Curated API POST (ID e133a645-95b9-4e01-9454-e270d2a0b599, 13 Actions, Test-Only); 401 Offender Narrowed To Stripped Fields By Elimination; Hook Routing Proven After Stale-Workflows-Field And Backend-Cache Defeats
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:37:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-42-import.md`

---

## 1. Result

Import SUCCESS via API, P40 mystery (trailing newline) closed beforehand.
Workflow `suricata-packet-routing` live at ID **e133a645-95b9-4e01-9454-e270d2a0b599**,
13 actions, test-only. Estate after import: exactly 3 workflows [VERIFIED live,
estate re-checked this session: count=3; packet wf status=test is_valid=true].

## 2. Offender-field isolation (method + finding, honestly bounded)

| Attempt | Body | Result |
|---------|------|--------|
| Full artifact POST | every source field incl. owner/configuration/metadata | **401** |
| Curated-subset POST | name/description/actions/branches/triggers/start/is_valid only | **200**, object created |

Culprit localization: by elimination the offender lives among the STRIPPED
fields (`owner`, `configuration`, or other server-owned keys). It was **not**
pinpointed to a single field — documented as bounded-by-method, not guessed.
The curated body is now the sanctioned import shape.

## 3. Hook registration saga

1. Cloned the hooks doc pattern from existing configuration → first webhook
   replay **misrouted** to eb937a37 (Class-A lane).
2. Root cause: the cloned doc carried a **stale `workflows` field** pointing at
   the old workflow. Fix: `workflows=[self]` (the new UUID).
3. Fix appeared ineffective — backend served cached hook config.
4. Backend restart flushed cache → routing confirmed: executions arrive with
   `execution_source=webhook` on e133a645, and the backend log line
   `"should execute … Workflow: e133a645"` recorded the decision.

Lesson recorded: hook docs are copied-with-care artifacts; `workflows` must be
regenerated per target, and a routing test is mandatory before trusting any
clone.

## 4. Post-import state feeding later proofs

18 webhook-sourced executions exist on the lane today (12 FINISHED / 6 ABORTED)
— all from deliberate test fires during rebuild/debug, trigger left `stopped`
for production. Zero contamination markers missing: events synthetic/test-titled
throughout (proofs in phase41-46).

## 5. Flags

- Import success: VERIFIED (object retrievable, fields as designed).
- Offender field identity: PARTIAL — bounded to stripped set by elimination.
- Hook routing correctness: VERIFIED (log line + execution_source evidence).
