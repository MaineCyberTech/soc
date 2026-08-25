# Phase 38 Migration Plan

**Report ID:** phase38-59-migration-plan
**Phase:** 38
**Title:** Phase 38 Non-Destructive Migration Plan — Copy-First Restructure of the Report Corpus
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:09:00Z
**Classification:** INTERNAL
**Status:** PASS
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-59-migration-plan.md`
**Retention Class:** canonical-current

---

## 1. Purpose

Specify the executable, non-destructive plan that restructures ~1,900 markdown reports from the flat `ops/reports/` layout into the canonical tree (phase38-55) without modifying, moving, or deleting a single original byte until verification passes.

## 2. Invariants

| # | Invariant |
|---|---|
| I1 | Originals are never written to. All writes target new paths only |
| I2 | Every copy preserves mode + mtime (`cp -p`) and must hash-match its source |
| I3 | `ops/evidence/**`, `releases/`, client-delivered files are NEVER touched by any phase step |
| I4 | Git working tree stays clean until the single post-verification commit |
| I5 | Rollback at any point = delete created copies; originals remain intact by construction |

## 3. Phase A — Copy

```bash
# manifest-driven copy preserving mtime/mode
while IFS=, read -r src dst _; do
  mkdir -p "$(dirname "$dst")"
  cp -p "$src" "$dst"
done < migration-plan.csv
```

- Source set: 1,834 root `.md` (+ logs copied as-is into `archive/pre-p38/`), 80 `generated/phase38-*.md` stay in place (already canonical).
- Estimated file counts per destination (copy targets):

| Destination | Est. files |
|---|---|
| `current/` | 10 (49,47 reserved stubs + 90–96 promoted copies) |
| `phases/phase02…phase37/` (incl. finals) | ~1,795 |
| `audits/` | ~45 |
| `evidence-indexes/` | 1 index over 2 evidence JSONs |
| `ledgers/` | ~12 |
| `client-safe/` | 0 initially (gate empty) |
| `releases/` | 4–6 (v1.0–v1.3 records) |
| `runbooks/` | ~15 |
| `schemas/` (+templates) | ~16 (4 schemas + 9 templates + acceptance template) |
| `archive/pre-p38/` | 1,834 full mirror |
| `generated/` | 0 new (in place) |

Total copies ≈ 3,720 (canonical set + archive mirror). Disk cost ≈ corpus size ×2.

## 4. Phase B — Manifest Generation

For every copy row: `source_path,canonical_path,sha256_before,sha256_after,alias_of,naming`.

```bash
sha256sum "$src" ; sha256sum "$dst"   # MUST be equal
```

Any mismatch aborts Phase B entirely (no partial manifests). Manifest is written to `generated/migration-map.csv` and hashed itself.

## 5. Phase C — Alias / README Pointers at Original Locations

At each original location left behind, write a small pointer file:

```
This report moved to <canonical_path> on 2026-08-25 (Phase 38 migration).
Original preserved at this path until P39 decommission review.
metadata.source_path = /opt/mct-security-stack/ops/reports/<original-name>
```

Rule: pointers are NEW files (`<name>.MOVED.md`) or header-prepended copies — the original file bytes are still not modified; if pointer-in-place is chosen, it is done via git-tracked edit AFTER the commit, never before.

## 6. Phase D — Index / Catalog Build

- Build `reports/INDEX.md` from phase38-60 content (human index).
- Rebuild `catalog-reports.{json,csv}` over the migrated tree (machine catalog, phase38-61 logic).
- Regenerate backlink map edges (phase38-63) so `current/` docs link correctly.

## 7. Phase E — Verification

1. Row count: manifest rows == copies on disk == expected counts (§3).
2. Hash equality re-check across all copies (spot 100% — cheap at corpus scale).
3. Determinism: mapper re-run produces byte-identical `migration-map.csv`.
4. No-original-mutation proof: `git status` shows zero modifications under original paths; mtimes of originals unchanged vs pre-A snapshot.
5. INDEX links resolve (no dangling relative links inside tree).

Only after ALL pass → single commit (§8).

## 8. Git Strategy

- One branch `p38/canonical-tree`, ONE commit titled `p38: canonical report tree (copy-first, originals preserved)` made after Phase E, containing: new tree, manifest, indexes, alias pointers.
- No interleaved commits, no force-push, no history rewrite. Pre-existing history untouched.

## 9. Exclusions (HARD)

Never read-modify-write, move, or include in copy mutation steps:
- `ops/evidence/**` (permanent-evidence)
- anything already delivered as client-delivered
- release-record files once published

These appear in indexes only.

## 10. Rollback

At ANY failure point:

```bash
xargs -a manifest.paths rm -r   # deletes ONLY enumerated destination paths
git reset --hard origin/main    # discards uncommitted tree changes
```

Originals were never touched, so rollback restores the exact prior world. Post-commit rollback = `git revert` of the single commit.

## 11. Execution Gates

Gates G1–G8 (phase38-02) apply; execution order A→B→C→D→E with hard stop on first failure. Companion docs: dry-run (67–70 series: `phase38-68-migration-dryrun`, `-apply`, `-verify`, `phase38-67-link-rewrite-plan`).
