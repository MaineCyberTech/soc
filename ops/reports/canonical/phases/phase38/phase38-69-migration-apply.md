# Phase 38-69 Migration Apply — Deferred Pending Operator Approval

**Report ID:** phase38-69-migration-apply  
**Phase:** 38  
**Title:** Phase 38-69 Migration Apply Record — DEFERRED, Execution Recipe Preserved  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T21:13:25Z  
**Classification:** INTERNAL  
**Scope:** Exact execution recipe for the copy-first migration; NOT executed  
**Status:** DEFERRED  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Owners:** ["human-operator", "opencode/ox-alpha"]  
**Evidence Roots:** ["/opt/mct-security-stack/ops/reports/generated/phase38-68-migration-dryrun.md"]  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-69-migration-apply.md`  
**Retention Class:** canonical-current  

---

## 1. Status

**DEFERRED PENDING OPERATOR APPROVAL.** No file in the report corpus was moved, copied, or
modified during this phase step. This document preserves exactly what WOULD execute so approval
can be a review of concrete commands rather than intentions.

## 2. Approval Gate Requirements

Approval requires ALL of:

| # | Requirement |
|---|---|
| A1 | Operator sign-off recorded in change register (gate G1) referencing this report ID |
| A2 | Dry-run re-executed within 24h of apply with same PASS results (phase38-68) |
| A3 | Disk headroom ≥ 2× corpus size confirmed (currently 84% used — **24G avail vs ~26 MB needed: OK**, but watermark policy must be acknowledged) |
| A4 | Correction D1 from dry-run folded into the apply manifest (audits-dominant distribution) |
| A5 | Rollback rehearsal: `manifest.paths` generated and `rm -r` dry-run (`xargs -a manifest.paths ls -d`) printed and reviewed |

## 3. What Would Execute (verbatim command list)

```bash
set -euo pipefail
cd /opt/mct-security-stack

# --- Phase A: build manifest (dry-run classifier, frozen output) ---
python3 ops/reports/generated/../../scripts/p38_migration_manifest.py   # emits migration-map.csv (src,dst,alias_of)
sha256sum ops/reports/generated/migration-map.csv

# --- Phase B: copy ---
while IFS=, read -r src dst alias; do
  mkdir -p "$(dirname "ops/reports/$dst")"
  cp -p "$src" "ops/reports/$dst"
done < ops/reports/generated/migration-map.csv

# --- Phase C: verify hashes ---
fail=0
while IFS=, read -r src dst alias; do
  [ "$(sha256sum "$src" | cut -d" " -f1)" = "$(sha256sum "ops/reports/$dst" | cut -d" " -f1)" ] || { echo "HASH MISMATCH $dst"; fail=1; }
done < ops/reports/generated/migration-map.csv
[ "$fail" = 0 ]

# --- Phase D: indexes/catalogs ---
# build INDEX.md, rebuild catalog-reports.{json,csv}, regenerate backlink map

# --- Phase E: single commit on p38/canonical-tree ---
git checkout -b p38/canonical-tree
git add ops/reports/current ops/reports/phases ops/reports/audits \
        ops/reports/archive ops/reports/INDEX.md ops/reports/generated/migration-map.csv
git commit -m "p38: canonical report tree (copy-first, originals preserved)"
```

Exclusions honored verbatim (plan §9): `ops/evidence/**`, client-delivered files, published release
records are never touched.

## 4. Post-Apply Verification Steps

1. Row count equality: manifest rows == files copied == expected counts (§ dry-run distribution).
2. Hash equality re-check over 100% of copies.
3. Determinism: manifest regeneration is byte-identical.
4. Originals untouched: `git status` shows zero modifications to tracked originals; mtimes unchanged.
5. INDEX.md links resolve; CI script broken-link gate passes.

## 5. Rollback (validated order from dry-run F1)

```bash
xargs -a ops/reports/generated/manifest.paths rm -r   # 1st: delete ONLY enumerated destinations
git reset --hard origin/main                          # 2nd: restore any tracked-file drift
git branch -D p38/canonical-tree                      # if branch created pre-commit
```

Post-commit rollback = `git revert` of the single migration commit. Originals were never written,
so rollback restores the exact prior world by construction.

## 6. Dry-Run Results Summary (phase38-68)

| Check | Result |
|---|---|
| Enumeration / collisions / missing | PASS (1,851 rows / 0 / 0) |
| Hash+mtime sample | PASS 20/20 |
| Broken-link risk | PASS (0 relative links) |
| Git effects | ~3.7k untracked additions expected |
| Rollback validation | PASS with ordering finding F1 |

## 7. Next Action

Operator review → approve via change register entry → re-run dry-run (A2) → execute §3 verbatim.
If any check fails mid-run: STOP, execute §5 rollback, file incident report.
