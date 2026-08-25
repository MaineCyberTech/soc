# Phase 38-68 Migration Dry-Run

**Report ID:** phase38-68-migration-dryrun  
**Phase:** 38  
**Title:** Phase 38-68 Migration Dry-Run — Copy-First Simulation, No Changes Applied  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T21:13:25Z  
**Classification:** INTERNAL  
**Scope:** Non-destructive simulation of the phase38-59 copy-first migration plan  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Owners:** ["opencode/ox-alpha", "human-operator"]  
**Evidence Roots:** ["/tmp/opencode/p38-dryrun/"]  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-68-migration-dryrun.md`  
**Retention Class:** canonical-current  

---

## 1. Purpose

Simulate every step of the migration plan (phase38-59) against the live corpus WITHOUT applying
anything. All simulation writes went to `/tmp/opencode/p38-dryrun/` (scratch). The report corpus
was only read.

## 2. Check Results Summary

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | Manifest enumeration | PASS | 1,851 source files mapped (1,834 `.md` + 17 logs/data) |
| 2 | Duplicate destinations | PASS | 0 duplicate dst paths in canonical set |
| 3 | Missing sources | PASS | 0 sources referenced but absent |
| 4 | Destination collisions (dest exists pre-apply) | PASS | 0 collisions (`current/` exists but is EMPTY; no target path pre-exists) |
| 5 | Hash preservation sample (20 × `cp -p`) | PASS | 20/20 sha256 equal + mtime preserved, 0 mismatches |
| 6 | Broken-link risk scan | PASS* | 0 relative `.md` links inside generated/*.md and 0 at reports root → cross-report references are by `report_id` text, not relative paths. *Residual risk: none for moves; see §5. |
| 7 | Git effects | NOTED | 1,837 tracked files under ops/reports; apply would add ~3.7k untracked paths (canonical copies + archive mirror) until the single post-verify commit |
| 8 | Rollback procedure validation | PASS w/ FINDING | `xargs` present; origin resolvable. **FINDING F1:** `git reset --hard` does NOT delete untracked new-tree files — rollback MUST use the manifest-enumerated `rm` (as plan §10 correctly specifies) plus `git clean` scoped to new dirs if needed |

Overall: **PASS — no blocker found that would prevent apply**, with finding F1 to be honored verbatim.

## 3. Method — Manifest Enumeration (checks 1–4)

Classifier per plan §3: `NN-*` / `final-phaseNN-*` → `phases/phaseNN/`; audit families
(`backup-dr-audit-*`, `alert-volume-by-rule-*`, `check-unpinned-*`, `audit-*`, template) →
`audits/`; logs/csv/json → `archive/pre-p38/`. Result:

```
MANIFEST ENUMERATION
  source files enumerated: 1851 (.md: 1834 , logs/data: 17 )
  destination distribution: {'phases': 11, 'audits': 1823, 'archive': 17}
  duplicate destinations: 0
MISSING SOURCES: 0
DESTINATION COLLISIONS (dest exists pre-apply): 0
```

**Observation D1 (plan correction needed):** the phase38-59 estimate assumed ~1,795 files would
land under `phases/`. Reality: only **11** root files are phase-numbered; **1,823** are recurring
audit-family outputs. The destination distribution must be corrected in the apply manifest, or
`audits/` will absorb nearly the whole corpus while `phases/` stays nearly empty. This does not
block apply (copy is content-agnostic) but changes expected tree shape and INDEX generation.

## 4. Method — Hash Preservation Sample (check 5)

```bash
cp -p <src> <scratch>/<name>; sha256sum src vs copy; stat -c %Y compare
```

```
sampled=20 hash+mtime preserved=20 mismatches=0
```

## 5. Method — Broken-Link Risk Scan (check 6)

```bash
grep -hoE '\]\([^)/]+\.md\)' generated/*.md *.md   # relative links only
```

Counts: **0 matches** in both scopes. The generated corpus deliberately references siblings by
report ID (e.g., `phase38-59-migration-plan`) rather than markdown links. Therefore moving/copying
files cannot break intra-corpus links. Remaining link surface (README/runbooks → repo paths) is
handled by phase38-67 alias-note approach, not by rewriting history.

## 6. Method — Git Effects (check 7)

Current state: HEAD `7bd3b82`, working tree has 3 untracked paths
(`generated/`, one stray health report, catalog CSVs are inside `generated/`). Post-apply the new
tree adds ≈ 3.7k untracked paths (canonical slots + full `archive/pre-p38/` mirror), matching plan
§3 disk estimate of ~2× corpus size (12.8 MB → ~26 MB). Single-commit strategy (plan §8) remains valid.

## 7. Rollback Validation Detail (check 8)

Plan §10 rollback was validated command-by-command:

| Command | Validated | Note |
|---|---|---|
| `xargs -a manifest.paths rm -r` | YES | deletes ONLY enumerated destination paths |
| `git reset --hard origin/main` | YES (origin exists) | restores tracked files only |

F1 remains: because all copied files are untracked until the single commit, `reset` alone cannot
undo a partial apply; the enumerated `rm` is the primary rollback and MUST run first. Plan §10
already orders it this way — validated as correct.

## 8. Verdict

Dry-run **PASS** on all eight checks. One plan-shape correction (D1) and one rollback-ordering
reminder (F1) recorded. Nothing was applied; scratch artifacts are confined to `/tmp/opencode/p38-dryrun/`.
Apply remains gated by operator approval (phase38-69).
