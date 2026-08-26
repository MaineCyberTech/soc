# Phase 41 v1.3.1 Release Decision

**Report ID:** phase41-78-v131-release-decision
**Phase:** 41
**Title:** DECISION-V131-41-01 — CUT v1.3.1 AT PHASE-42 OPEN (Deliberately Deferred One Phase): Packet-Lane Remediation Belongs In The Tag, All Ten Deltas Runtime-Stable NOW Under v1.3.0 Operation Via Documented-Delta Model, Mid-Phase Tagging Avoided; Pre-Drafted P42 Tag Checklist Included
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:56:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-78-v131-release-decision.md`

---

## 1. Decision

| Field | Value |
|---|---|
| Decision ID | **DECISION-V131-41-01** |
| Decision | **CUT v1.3.1 AT PHASE-42 OPEN** — deferred exactly one phase, deliberately |
| Alternatives rejected | (a) cut now mid-phase-41; (b) defer indefinitely past packet-lane resolution |

## 2. Rationale

1. **Packet-lane remediation belongs in the tag.** The packet workflow
   remediation path (ROUT-PKT-40-01 lineage, deferred-by-choice since P40)
   lands at Phase 42 open. Cutting v1.3.1 before it would ship a tag that is
   stale on arrival and force a v1.3.2 immediately; deferral past it would
   leave a growing undocumented-delta surface. Phase-42 open is the natural
   freeze point where the tree contains everything v1.3.1 should contain.
2. **All deltas are runtime-stable NOW under v1.3.0 operation.** The ten
   inventory items (phase41-77) are running in production today under the
   documented-delta model: every post-tag divergence is labeled and registered,
   so deferring the *tag* carries zero silent-drift risk.
3. **No mid-phase tagging.** Tagging from a moving tree mid-phase risks a
   tag-to-tree skew at cut time. Tags are cut at phase boundaries after
   closeout gates — same discipline that produced v1.3.0.

## 3. Pre-drafted tag checklist (executes at Phase-42 open)

```
[ ] 1. FREEZE: confirm no uncommitted tree changes; close phase-42-open deltas
       (packet-lane remediation committed first)
[ ] 2. DOCS SWEEP: RELEASE-NOTES.md updated with D-1..D-10 (+ packet-lane item);
       REPO-MAP/PORTS/SECURITY sections touched by inventory verified current
[ ] 3. INVENTORY FINAL: re-run phase41-77 table check — every delta either in
       tag or explicitly moved to v1.3.2 register
[ ] 4. TAG: annotated tag v1.3.1 from verified HEAD; record tag object →
       commit → tree chain in the assurance report
[ ] 5. BUILD/PUBLISH: generate asset (git archive or build pipeline),
       publish GitHub release v1.3.1 with asset
[ ] 6. API-VERIFY: REST-API re-read of release metadata; sha256 downloaded
       vs published identity — BYTE-EXACT required
[ ] 7. ON-BOX CUSTODY: repeat phase41-75 method verbatim (download original,
       store ops/releases/v1.3.1/, hash-match evidence block)
[ ] 8. MANIFEST v1.3.1: create ops/releases/v1.3.1/MANIFEST.md with
       published-original row (hash/URL/timestamp/method) day-one — no
       rebuilt-first gap this time
[ ] 9. CLOSEOUT: triple-CI gates PASS; catalogs refreshed; blocker register
       updated (v1.3.1 cut decision resolved)
```

## 4. Guardrails

- No agent cuts the tag without operator sign-off recorded in the change
  register (AGENTS.md approval-gated operations).
- If packet-lane work slips at Phase 42 open, fallback decision point:
  cut v1.3.1 with D-1..D-10 only and move packet-lane to v1.3.2 — do NOT hold
  the tag hostage beyond one slip cycle.

## 5. Execution plan

Sequence, owners, rollback, acceptance criteria: RELPLAN-41-01
(phase41-79-v131-release-plan.md).
