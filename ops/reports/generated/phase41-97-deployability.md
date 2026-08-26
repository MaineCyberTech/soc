# Phase 41 Deployability Certification

**Report ID:** phase41-97-deployability
**Phase:** 41
**Title:** DEPLOY-41-06 — Verdict PARTIAL Maintained Precisely: B4 Custody RESOLVED This Phase (Published-Original Byte-Exact On-Box), Remaining Blockers 3 (B1 Target AWAITING-approval, B2 Signature AWAITING-owner, B3 Rehearsal Never-Run); Spot-Check Streak ×3 and Plan v3 Credited; Ordered Flip-Path With Owners
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T07:00:00Z
**Classification:** INTERNAL
**Status:** PARTIAL
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-97-deployability.md`

---

## 1. Verdict

**PARTIAL — maintained precisely.** Phase 41 resolved one of the four standing blockers outright
and materially improved readiness-to-flip on the rest, but the verdict does not move: three
bounded restores are not a full-cluster rehearsal; a ready-to-sign sheet is not a signature; an
assessed candidate list is not an approved target. No verdict inflation.

## 2. Blockers (exact)

| ID | Blocker | State after Phase 41 |
|---|---|---|
| **B1** | **External rehearsal target AWAITING-approval (owner).** Candidates identified and assessed (phase41-29/-30/-31); criteria fixed; no target yet named/approved. | OPEN — owner-batch item |
| **B2** | **RTO/RPO objectives AWAITING-signature.** DEC-40-01 sheet ready (RTODRF-40-01 proposal values); interim governance remains DRAFT-TARGETS. | OPEN — owner-batch item |
| **B3** | **Full-cluster rehearsal never-run.** Evidence is component-grade but now a STREAK: spot-check #3 PASS (170521=170521 parity) makes three consecutive bounded restores across phases; multi-node ordering and timing-under-pressure remain unproven. | OPEN — consumes B1+B2 |
| ~~B4~~ | **~~Published-asset custody PARTIAL~~ → RESOLVED THIS PHASE.** Published v1.3.0 original retrieved via GitHub REST API (no gh), sha256 byte-exact vs published identity, on-box beside the retained rebuilt-provenance variant; MANIFEST carries the primary row (phase41-75/-76/-98). | **CLOSED** |

**Remaining blockers: 3** (B1, B2, B3) — all owner-input-gated, none evidence-gated.

## 3. What Improved This Phase (credited, without inflating the verdict)

1. **Restore spot-check streak ×3:** third consecutive bounded restore with exact parity
   (170521=170521, phase41-57). Restore mechanics are now a demonstrated routine, not a novelty.
2. **Plan v3 staged:** the restore plan consumed every phase-41 delta (compact-stats lane,
   watchdog cron, custody artifacts, ISM pre-wave snapshot discipline) so the rehearsal remains
   strictly a decision-plus-window.
3. **Published-original on-box:** release chain-of-custody closed byte-exact — a rebuild proves
   tree-content identity, but only the retrieved original proves custody; as of today both exist
   with honest labels.
4. **Sensor-side reproducibility:** the containment arc left behind exact-args invocation records
   plus rollback procedure (phase41-15 §7), so a rebuild reproduces the single-instance sensor
   posture deterministically.

## 4. Flip Path — ordered steps with owners

```
1. Owner: name/approve adequate external target per criteria          [clears B1]
   (owner-batch session item)
2. SOC lead/business: sign DEC-40-01 sheet; record in register        [clears B2]
   (same owner-batch session)
3. Infra+SOC: execute restore plan v3 on approved target;
   measure vs signed RTO/RPO; Stage0 approvals gate go/no-go          [clears B3; needs 1+2]
4. Governance: re-issue DEPLOY certification against evidence pack    [PARTIAL→PASS]
```

Steps 1–2 are independent and belong in ONE owner session (phase41-93 §owner-batch);
step 3 consumes both.

## 5. Explicit Statement — what flips the verdict

DEPLOY flips **PARTIAL→PASS** when, and only when: an approved external target has hosted a full
rehearsal executed per plan v3, measured against SIGNED RTO/RPO objectives, with Stage0 approvals
recorded and the go/no-go evidence pack re-certified by governance. Nothing short of that moves
the verdict; everything short of that is readiness-to-flip credit, tracked above.
