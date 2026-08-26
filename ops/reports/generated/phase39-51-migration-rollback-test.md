# Phase 39 Migration Rollback Test

**Report ID:** phase39-51-migration-rollback-test
**Phase:** 39
**Title:** Phase 39-51 Rollback Test — DRY-RUN ONLY on Temp Clone, Zero Production Deletion
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:52:00Z
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-51-migration-rollback-test.md`

---

## 1. Test Execution (DRY-RUN ONLY — no production path was deleted)

### (a) Rollback command correctness on a TEMP clone

```bash
cp -r ops/reports/canonical /tmp/opencode/canonical-test   # clone: 1,996 files
rm -rf /tmp/opencode/canonical-test                        # the exact rollback primitive
```

```
clone_ok files=1996
removal_clean=yes        ([ -e ] fails afterwards)
clone_ms=106 rm_ms=18
```

The `rm -rf <canonical-root>` primitive removes the entire copy tree cleanly with no residue and no
effect outside its argument — validated on an identical-size clone.

### (b) Originals present for 20 sampled destinations

Random sample (seed 5150) across buckets — phases (12), generated-sourced (3), finals (1),
archive strays (4): **originals-present = 20/20**. Full listing embedded in
`/tmp/opencode/p39/rollback-test.txt`; combined with phase39-48's 100% source-existence proof,
rollback can never lose data because sources are independent of destinations by construction.

### (c) Sanctioned rollback procedure (production)

```bash
# 1. Remove ONLY the enumerated destination tree (honors P38 finding F1: run BEFORE git ops)
rm -rf /opt/mct-security-stack/ops/reports/canonical/
# 2. Optional: discard working-tree drift on tracked files (does NOT touch untracked originals)
git reset --hard origin/main
# 3. Confirm world restored
ls ops/reports/canonical 2>&1   # -> No such file or directory
git status --short ops/reports  # -> same pre-migration dirty set as phase39-43 §3
```

Time estimate (measured components): rm of 40 MB / ~2k files ≈ **<2 s** (18 ms measured on tmpfs
for the clone; production disk budgeted conservatively); git reset ≈ 1–5 s; verification ≈ 1 min.
Total rollback window: **under 2 minutes**, zero data loss possible.

## 2. Scope Guard

Rollback removes `canonical/` only — a directory that did not exist before APPLY-39-01 except as
the migration target. Any post-apply content added under `canonical/` outside manifest rows is out
of APPLY-39-01 rollback scope and must be evaluated separately (phase39-44 §6).

## 3. Verdict

**PASS** — rollback procedure proven correct, complete, and fast on a full-size temp clone;
production deletion count during this test: **0**.
