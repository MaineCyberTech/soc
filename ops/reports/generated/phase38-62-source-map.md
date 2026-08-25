# Phase 38 Source Map

**Report ID:** phase38-62-source-map
**Phase:** 38
**Title:** Phase 38 Source Map — original_path → canonical_path Mapping with Supersession Chains
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:12:00Z
**Classification:** INTERNAL
**Status:** PASS
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-62-source-map.md`
**Retention Class:** canonical-current

---

## 1. Purpose

Comprehensive mapping rules from the ~1,900 legacy paths to canonical paths, with representative full rows, supersession chains, and authority classes. The exhaustive row set lives in `migration-map.csv` (built at Phase B); this document defines the RULES that generate it deterministically.

Column set: `original_path | canonical_path | alias_of | superseded_by | report_id | sha256 | authority_class`.

## 2. Pattern Rules

| # | Legacy pattern | Canonical rule | Authority class |
|---|---|---|---|
| R1 | `final-phase{N}-operator-report-{ts}.md` | `phases/phase{N}/` (name unchanged) | PHASE-FINAL |
| R2 | `{NN}-{slug}-{YYYYMMDD}-{HHMMSS}.md`, NN=13..37 | `phases/phase{NN}/{NN}-{seq}-{slug}.md` (timestamp dropped into frontmatter.source_timestamp) | GENERATED-AUDIT→PHASE-FINAL at close |
| R3 | `{NN}-{slug}-{ts}.md` with NN≤12 | `phases/phase{NN}/` name unchanged, `naming=legacy` | PHASE-FINAL |
| R4 | `backup-dr-audit-{ts}.md` (+family) | `audits/{family}-audit-{date}-{time}.md` (already conformant) | GENERATED-AUDIT |
| R5 | `alert-volume-by-rule-{ts}.md` | `ledgers/metrics/alert-volume-by-rule-{ts}.md` | GENERATED-AUDIT |
| R6 | `{name}-ledger.{md,json,csv}` | `ledgers/{name}-ledger.{ext}` | AUTHORITATIVE-CURRENT (ledger domain) |
| R7 | `phase38-*.md` | stays `generated/phase38-*.md`; promoted copies to `phases/phase38/` at close | GENERATED-AUDIT |
| R8 | byte-duplicate groups (3 groups / 12 files, phase38-05) | one canonical copy; others `alias_of=<canonical>` | SUPERSEDED (aliases) |
| R9 | empty stubs `phase33-6[1-8]-.md` | `phases/phase33/` unchanged, flag review-required | DRAFT |
| R10 | logs (`*.log`, `*.txt`) | `archive/pre-p38/` mirror only | ARCHIVE |

## 3. Representative Rows

```
final-phase36-operator-report-*.md
  → phases/phase36/final-phase36-operator-report-*.md
  superseded_by: current/49-current-state.md (current-truth purposes ONLY)
  authority: PHASE-FINAL

15-shuffle-iris-wiring-20260810-2058.md
  → phases/phase15/15-shuffle-iris-wiring-20260810-2058.md
  naming=legacy, alias_of=∅
  authority: PHASE-FINAL

backup-dr-audit-20260811-042054.md
  → audits/backup-dr-audit-20260811-042054.md
  family=backup-dr, newest-instance rule applies
  authority: GENERATED-AUDIT

alert-volume-by-rule-20260822-055730.md
  → ledgers/metrics/alert-volume-by-rule-20260822-055730.md
  feeds metrics ledger rows
  authority: GENERATED-AUDIT

acceptance-test-template.md
  → schemas/templates/acceptance-test-template.md.tmpl
  authority: TEMPLATE

phase33-63-.md (0 bytes)
  → phases/phase33/phase33-63-.md
  review-required, DO-NOT-DELETE
  authority: DRAFT
```

Per-row `sha256` values are filled at Phase B manifest time (see migration-map.csv); sample verification hashes for this batch are recorded in `catalog-reports.json`.

## 4. Supersession Chains

| Chain | Direction | Scope |
|---|---|---|
| final-phase36* → `49-current-state` | SUPERSEDED-FOR-CURRENT-TRUTH | finals remain valid history; not citable for "what is true now" once 49 lands |
| final-phase37-operator-report → `49-current-state` | same | same |
| final-phase31 → final-phase31v2 → phase31v2 series | linear revision chain | phase-level |
| backup-dr-audit-{t1} ← backup-dr-audit-{t2} … | newest-wins within family | audit domain until folded into current/ |
| duplicate group members → single canonical | alias chain (phase38-05 D2/D3) | corpus-wide |
| phase38-00-master PARTIAL → this batch (55–66) | extends execution record | phase 38 |

Chain integrity rule: `superseded_by` pointers must resolve to an existing canonical path; CI (71) fails on dangling chains.

## 5. Report IDs

Legacy flat files gain formal IDs at mapping time: `{phase}-{seq}-{slug}` derived by rule R2/R3 parsing; finals keep their filename stem as ID. All IDs unique across corpus; collisions resolved per phase38-56 §4.

## 6. Determinism

Re-running these rules over the frozen archive mirror reproduces migration-map.csv byte-identically (asserted in Phase E, phase38-59 §7.3).
