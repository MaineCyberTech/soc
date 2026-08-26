# Phase 40 Duplicate Decision

**Report ID:** phase40-79-duplicate-decision
**Phase:** 40
**Title:** DUP-DEC-40-01 — Post-Migration Duplicate Recount Verified (3 Groups / 12 Files); Per-Group Adjudication: 2× APPROVE Alias-Consolidation, 1× DEFER
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (DECIDED)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-79-duplicate-decision.md`

---

## 1. Recount (fresh, this session — not carried from P39)

```
$ find ops/reports -path "*/canonical" -prune -o -name "*.md" -type f -print0 \
    | xargs -0 sha256sum | sort-by-hash → duplicate counts:
e3b0c442…7852b855 ×8   ef6e5a84…c50b411fd90 ×2   fdad4fe1…42dfdbfb070fbe9c7 ×2
groups=3 files=12   originals-tree md files total: 2111
```

Matches the P39 audit exactly (phase39-86): no drift, no new duplicates introduced by
APPLY-39-01 or P40 writes into the scanned scope.

## 2. Per-Group Review

### Group DUP-39-A — 8 zero-byte stubs `phase33-6[1-8]-.md` (hash e3b0c442…)

| Check | Result |
|---|---|
| Protected-evidence overlap | NONE (all under ops/reports/) |
| Retention class | DRAFT / review-required per source-map R9; catalog-marked stubs (phase39-85) |
| Backlink impact | Nil — aliasing eight EMPTY files to one EMPTY file adds zero information and preserves nothing that isn't already preserved |

**Decision: DEFER alias-consolidation.** Rationale: "duplicate" here is an artifact of
emptiness; correct disposition is the stub review track (phase39-85), which may retire or
flesh-out these paths wholesale. Aliasing now would freeze a meaningless mapping.

### Group DUP-39-B — `phase37-81-final.md` ≡ `final-phase37-operator-report-20260825-1943Z.md` (hash ef6e5a84…)

| Check | Result |
|---|---|
| Protected-evidence overlap | NONE |
| Retention class | PHASE-FINAL / LONG (both members byte-identical) |
| Backlink impact | Safe under non-destructive aliasing: both names remain resolvable; canonical twin = finals filename-stem rule R1 |

**Decision: APPROVE alias-consolidation via source-map entry ONLY (no deletions).**
Canonical = `final-phase37-operator-report-20260825-1943Z.md`; original recorded as
`duplicate-alias`.

### Group DUP-39-C — `phase5-current-resource-state.md` ≡ `resource-trend-20260811-070615.md` (hash fdad4fe1…)

| Check | Result |
|---|---|
| Protected-evidence overlap | NONE |
| Retention class | GENERATED-AUDIT resource snapshot family |
| Backlink impact | Safe; canonical twin = dated-instance newest-wins rule (source-map §4) |

**Decision: APPROVE alias-consolidation via source-map entry ONLY (no deletions).**
Canonical = `resource-trend-20260811-070615.md`.

## 3. Approval Basis

Standing approval = pack instruction (Phase-40 tasking authorizes alias rows) +
strictly non-destructive method (ledger rows only; zero file moves/deletions). Physical
path retirement in catalogs/backlinks remains separately operator-gated (OW-40-12).

## 4. Decision Record

DUP-DEC-40-01: groups B,C → APPROVE (apply as DUP-APP-40-01, phase40-80); group A →
DEFER with rationale above. No doubt existed for B/C: hashes verified byte-identical
this session, protected stores re-checked clean, backlink preservation guaranteed by the
no-deletion method.
