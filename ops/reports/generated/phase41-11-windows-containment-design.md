# Phase 41 Windows Containment Design — Assessed, Deferred

**Report ID:** phase41-11-windows-containment-design
**Phase:** 41
**Title:** Phase 41 Windows Branch Assessment — win=77→85 Leaves NOT Contained This Phase; Rationale and Growth Trigger Documented
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:03:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (decision: DEFER with trigger)
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-11-windows-containment-design.md`

---

## 1. Scope of Question

After stats (441), the next-largest mappable growth families were windows (`data.win`,
77 unique leaves at morning snapshot, **85 by fresh walk**) and the mid-tier cluster
(ubiquiti 36, parameters 35, audit/service 30+30, osquery 28). Which, if any, get the
same treatment as stats this phase?

## 2. Measured Position

| Family | Unique leaves (morning) | Unique (fresh 04:46Z) | Docs today | Producer |
|---|---|---|---|---|
| data.win | 77 | **85** | >10k (15,822 + 1,278 top agents) | endpoints 012/014 eventchannel |

Growth observed DURING the arc: +8 unique leaves between snapshot and fresh walk —
slow but non-zero trickle, driven by Windows emitting EID-specific subfields
(`data.win.system.eventData.*` style paths) on first sight of rare event variants.

## 3. Why NOT Contained This Phase

1. **Classification**: unlike stats internals (93% N1 noise, phase41-08), win fields
   are **R1 REQUIRED-EVIDENCE** — they ARE the detection content for Windows rules
   (event IDs, logons, process creation). There is no "compact subset" that preserves
   detection fidelity; the long tail maps precisely because rare events matter.
2. **Budget math**: post-stats-containment steady state ≈500 unique / ≈900 raw against
   limit 2000. Even doubling win's footprint leaves >50% headroom. Containing R1
   evidence to solve a budget that is already solved would be negative-value surgery.
3. **Mechanism mismatch**: stats had a clean choke point (one yaml on one host). Win
   arrives through Wazuh's own eventchannel decoding across multiple endpoints —
   "containment" would mean decoder/template surgery in the manager's schema layer,
   a materially riskier change class touching live detections.
4. **Velocity**: +8 leaves/day-ish trickle vs budget headroom of >1000 — two orders of
   magnitude apart. Not urgent by any reading.

## 4. Trigger Condition (armed)

Windows branch escalation to active containment IF ANY of:

| Trigger | Threshold | Basis |
|---|---|---|
| Family size | `data.win` unique leaves **>150** | ≈3× current; would alone consume >30% of remaining headroom |
| Velocity | sustained >25 new win leaves/day over 3 consecutive guardrail runs | indicates an endpoint emitting pathological event variants |
| Budget position | total leaf_fields (raw basis) ≥1700 again on any future index | overall guardrail re-approaches soft zone |

Escalation path: new design arc (P42 candidate) covering manager-side eventchannel
schema pruning options (custom decoder field whitelisting, XDR schema template pinning)
— explicitly OUT of scope here to keep P41 single-variable.

## 7. Containment Sketch (pre-designed, for trigger-time reuse)

If a trigger fires, the candidate design — sketched NOW so escalation is execution,
not invention:

| Element | Approach |
|---|---|
| Scope | `data.win.eventdata.*` long tail only; core system/eventID fields stay |
| Mechanism A | custom manager-side decoder whitelisting win subfields per EID class |
| Mechanism B | Wazuh indexer-side template pinning of win subtree (`enabled:false` on selected deep paths) — heavier, tenant-wide, last resort |
| Evidence preservation | EIDs + descriptions + logon fields are the R1 floor; eventdata blobs beyond that are N1-leaning |
| Lab gate | mirror phase41-14 discipline: simulate mapping impact BEFORE endpoint changes |

Open questions to resolve at escalation time: multi-EID field overlap matrix, effect
on cross-agent correlation queries, rollback semantics for pinned mappings.

## 8. Monitoring Wiring Already In Place

No new tooling needed: `p40-field-growth-check.sh` reports branches each run; the
branch line makes the trigger mechanically checkable:

```
branches: data:1697 rule:27 GeoLocation:8 ...     ← win tracked inside data.*
```

Follow-up improvement queued for G41-13 commit wave (not blocking): emit per-family
win count in the guardrail output line for one-grep trigger checks.

## 9. Decision Record

DECISION: DEFER windows containment. Rationale classes 3.1–3.4 above. Trigger set per
§4; design sketch banked per §7 for trigger-time execution. Reviewer sign-off implied
by arc certification chain (phase41-18 §6 lists this as residual monitored risk R-2).
