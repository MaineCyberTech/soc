# Phase 38 Schema Validation

**Report ID:** phase38-66-schema-validation
**Phase:** 38
**Title:** Phase 38 Schema Validation — Metadata Marker and Status-Enum Audit of Generated Reports
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:16:00Z
**Classification:** INTERNAL
**Status:** PASS
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-66-schema-validation.md`
**Retention Class:** canonical-current

---

## 1. Purpose

Run actual schema validation across every `phase38-*.md` in `generated/` and record pass/fail counts plus the full exceptions list. Validation executed via bash (`grep`-based marker checks) immediately before this report was written.

## 2. Checks Applied

| # | Check | Rule |
|---|---|---|
| C1 | Title marker | Line matching `^\*\*Title:\*\*` present |
| C2 | Date marker | Line matching `^\*\*Date:\*\* [0-9]{4}-[0-9]{2}-[0-9]{2}$`-shaped ISO date |
| C3 | Status marker + enum | `^\*\*Status:\*\* X` where X ∈ {PASS, PARTIAL, FAIL, BLOCKED, DEFERRED, PENDING, IN PROGRESS, RETIRED, NO-GO, UNKNOWN, UNVERIFIED, CONTRADICTED, STALE, NOT APPLICABLE} |
| C4 | report_id consistency | `**Report ID:**` value equals filename stem (trailing markdown hard-break spaces normalized before compare) |

Scope: `generated/phase38-*.md`, flat glob (templates subdir excluded — `.tmpl` artifacts are TEMPLATE class and exempt per phase38-57 §2.8).

## 3. Results

Snapshot: **85 files** validated in the final full run (live-corpus note: concurrent Phase 38 writers added files during this session — an earlier partial run over 80 files showed 12 PASS / 68 FAIL; counts below are from the last complete pass).

| Metric | Count |
|---|---|
| Files validated | 85 |
| PASS (all checks) | 13 |
| FAIL (≥1 check) | 72 |

The 13 passing files: `phase38-00-master`, this entire batch `phase38-55` … `phase38-66` (self-validation included).

## 4. Exceptions List (all 72)

### E1 — invalid status `COMPLETE` (not in enum): 48 files

`phase38-01`…`20` (20, otherwise schema-clean), `phase38-31`…`42` (12, ALSO fail C1 missing-title), `phase38-43`…`46` (4, otherwise clean), `phase38-47`…`49` (3, concurrently-authored batch, otherwise clean), `phase38-50`…`51` (2, concurrent), `phase38-90`…`96` (7, otherwise clean). `COMPLETE` predates the ratified taxonomy; remediation is a mechanical rewrite to the nearest enum value (mostly PASS) tracked as a backlog item under current/90-backlog.

### E2 — non-taxonomy free-text status: 10 files (67–76)

| File | Offending status value |
|---|---|
| phase38-67-link-rewrite-plan | PLAN-ONLY |
| phase38-68-migration-dryrun | DRY-RUN-COMPLETE |
| phase38-69-migration-apply | DEFERRED — PENDING OPERATOR APPROVAL |
| phase38-70-migration-verify | TEMPLATE — Migration not yet applied |
| phase38-71-report-ci / 72-report-drift | DESIGN-COMPLETE |
| phase38-73-shuffle-hardening | PLAN-DEFERRED — Requires operator approval |
| phase38-74-shuffle-inventory | DOCUMENTED |
| phase38-75-packet-workflow | DESIGN-COMPLETE — Requires Shuffle UI for creation |
| phase38-76-packet-workflow-proof | METHODOLOGY-COMPLETE — Requires workflow creation first |

These files also lack C1/C2/C4 markers (legacy prose-header format). Correct mapping: PLAN-ONLY→PENDING, DRY-RUN-COMPLETE→PASS, DEFERRED variants→DEFERRED, DESIGN-COMPLETE→PARTIAL, DOCUMENTED→PASS, TEMPLATE-not-applied→NOT APPLICABLE.

### E3 — legacy header format (no machine markers at all): 14 files

`phase38-21` … `phase38-30` (claim-verification series, 10 files) and `phase38-79` … `phase38-82` (4 files): no Title/Date/Status/Report-ID markers found by C1–C4. These need header-block retrofit before report-ci (71) enforcement goes live.

Category totals: 48 + 10 + 14 = 72 ✓

## 5. Lint Observations (non-failing)

~28 files end their `**Report ID:**` line with two trailing spaces (markdown hard-break convention). Normalized before comparison; flagged as cosmetic only.

## 6. Disposition

- This document: PASS (authoring validation).
- Remediation of E1–E3 belongs to Phase 39 batch work: mechanical status rewrites (E1/E2) are safe automation targets; E3 header retrofits require content review.
- Re-validation runs automatically in report-ci (71); target: 0 FAIL before migration apply gate G7.
