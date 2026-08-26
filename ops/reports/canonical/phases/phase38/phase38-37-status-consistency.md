# Phase 38-37: Status Consistency Review

**Title:** Phase 38-37: Status Consistency Review
**Report ID:** phase38-37-status-consistency
**Phase:** 38
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-37-status-consistency.md`
**Retention Class:** LONG
**Author:** opencode (ox-alpha)

---

## 1. Purpose

Detect status conflicts across the corpus: PASS-with-limitations vs PARTIAL, IN PROGRESS vs DONE, and final-status disagreements between a phase's final report and later audits. Reclassification is performed only via explicit canonical statements; no source file is edited (G2 gate).

Reference taxonomy: `generated/phase38-08-status-taxonomy.md` defines 14 status values. Any verdict outside that set is non-conformant.

---

## 2. Conflicts Found

### STC-01: "PASS (with known limitations)" vs taxonomy / later audits

| Field | Value |
|---|---|
| Conflict | `final-phase35-operator-report-20260825-1841Z.md:140` declares "Final Status: **PASS** (with known limitations documented)" |
| Against | (a) Taxonomy has no PASS-with-limitations value (`generated/phase38-08-status-taxonomy.md` §values); (b) the same phase's commit records deployability PARTIAL and routing DEFERRED (git cbcca53); (c) Phase 38 scorecard marks multiple P35-carried domains FAIL/UNCHANGED (`generated/phase38-92-scorecard.md:44`) |
| Canonical statement | Phase 35 overall = **PARTIAL** — detection pipeline proven (canary E2E), while routing, Shuffle integration, and deployability remained open items tracked into P36+. The PASS sentence is superseded by this reclassification. |

### STC-02: Phase final marked IN PROGRESS after phase close

| Field | Value |
|---|---|
| Conflict | `phase37-81-final.md:6` "**Phase Status:** IN PROGRESS" — in the document that is the phase's closing operator report (byte-identical copy: `final-phase37-operator-report-20260825-1943Z.md`, hash group D3 in `generated/phase38-05-report-hash-duplicates.md:69-71`) |
| Against | Convention: a `-final` artifact closes its phase; P36's equivalent (`phase36-75-final-report.md`) uses completed-style summary with gate table |
| Canonical statement | Phase 37 execution is COMPLETE as of 2026-08-25T19:30Z; the roadmap section of the final defines successor work. The IN PROGRESS marker referred to open operational items, not phase execution, and is corrected here. |

### STC-03: "APPLIED AND ACTIVE" (fix outcome) vs "PENDING restart" validation

| Field | Value |
|---|---|
| Conflict | Fix status APPLIED AND ACTIVE + elimination forecast (`phase36-75-final-report.md:29-30`) vs validation document still at `Status: PENDING restart` (`phase36-34-field-cardinality-post-fix-validation.md:17`) |
| Against | Outcome measured later: NOT resolved (`phase37-38-field-postlogs.md:17`) |
| Canonical statement | Config deployment = COMPLETE; remediation outcome = FAILED/OPEN. Two separate statuses required; combined claim downgraded to OPEN. See phase38-31 CON-01. |

### STC-04: Drift table "Applied | None" implying resolution

| Field | Value |
|---|---|
| Conflict | `phase37-73-drift.md` marks staged decoder setting as Applied with drift None, while `phase37-81-final.md:50` records "Resolution: Not resolved" |
| Canonical statement | Deployed-config state (Applied) ≠ problem state (Open). Reports must carry both fields; drift row remains valid for configuration only. |

### STC-05: Master self-status PASS on a domain containing FAIL rows

| Field | Value |
|---|---|
| Conflict | §2 P0 Report Corpus Preservation "**Status:** PASS" (`generated/phase38-00-master.md:46`) sits beside FAIL-classified anomalies in the same section (8 empty stubs, duplicate pairs) and §4 lists Empty .md = 8 with status FAIL (:147) |
| Canonical statement | Corpus preservation = **PASS WITH ANOMALIES TRACKED** → per taxonomy: **PARTIAL** (data intact, hygiene items open under BCK-38-003). |

### STC-06: Routing-safety domain PARTIAL vs FAIL elsewhere

| Field | Value |
|---|---|
| Conflict | `generated/phase38-00-master.md:75` "Routing safety: PARTIAL"; same exposure family scored "FAIL" in scorecard row (`generated/phase38-92-scorecard.md:44`) and Shuffle security domain FAIL (:217) |
| Canonical statement | Keep two distinct domains but align language: Shuffle security posture = FAIL (exposure unmitigated); routing safety risk = PARTIAL-with-mitigation (no production routing exists, so misrouting risk is zero while value delivery is also zero). Both statements coexist; summaries must not average them into one word. |

### STC-07: RESOLUTION PENDING vs options-table framing

| Field | Value |
|---|---|
| Conflict | `phase37-43-field-resolution.md:3` header "RESOLUTION PENDING" while body presents decision "(a) first, then (b)" — reads as decided-and-in-flight though nothing was applied after it |
| Canonical statement | Decision = DOCUMENTED; execution = NOT STARTED (1024 apply explicitly "NOT YET APPLIED", `phase37-42-field-limit-apply.md:3`). |

### STC-08: Migration dry-run PASSED vs apply DEFERRED ambiguity

| Field | Value |
|---|---|
| Conflict | `generated/phase38-68-migration-dryrun.md` PASSED could be summarized as "migration passed"; apply is actually deferred pending approval (`generated/phase38-69-migration-apply.md:5,18-20`) |
| Canonical statement | Migration status = DRY-RUN PASSED / APPLY DEFERRED (approval-gated). Neither DONE nor FAILED. |

---

## 3. Canonical Reclassification Register

| ID | Entity | Old label(s) | Canonical status |
|---|---|---|---|
| R-01 | Phase 35 overall | PASS (with known limitations) | PARTIAL |
| R-02 | Phase 37 execution | IN PROGRESS | COMPLETE (2026-08-25T19:30Z) |
| R-03 | Field-cardinality remediation | APPLIED AND ACTIVE | CONFIG DEPLOYED / OUTCOME OPEN |
| R-04 | Decoder config drift row | Applied \| None | Valid for config only; outcome field mandatory alongside |
| R-05 | P38 corpus preservation | PASS | PARTIAL (anomalies tracked) |
| R-06 | Shuffle security / routing safety | FAIL vs PARTIAL mixed | Security=FAIL; RoutingRisk=PARTIAL (no-routing mitigation) |
| R-07 | Field resolution decision | RESOLUTION PENDING | DECISION DOCUMENTED / EXECUTION NOT STARTED |
| R-08 | Report migration | (implicit done-ness) | DRY-RUN PASSED / APPLY DEFERRED |

## 4. Recommendation

Enforce via report CI (`generated/phase38-71-report-ci.md`): reject any status value outside the taxonomy set; require paired fields `config_state` + `verified_outcome` for all remediation claims; forbid composite verdict strings ("PASS with…", "DONE except…").
