# Phase 39 Migration Apply Log

**Report ID:** phase39-45-migration-apply
**Phase:** 39
**Title:** Phase 39-45 Migration Apply Log APPLY-39-01 — Copy-First Execution Against Frozen Manifest
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:26:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-45-migration-apply.md`

---

## 1. Execution Record

| Attribute | Value |
|---|---|
| Apply ID | APPLY-39-01 |
| Manifest | `canonical/migration-manifest.json` sha256 `890b3536f19a85aeaf5c078e6e5136493d93ca96df163e02a5385a9ad6dece85` (frozen 23:16:02Z, unchanged at apply) |
| Start / End | 2026-08-25T23:19:15Z → 2026-08-25T23:19:30Z (**elapsed 15 s**) |
| Files copied | **1,992 / 1,992** |
| Hash mismatches | **0** (every copy's post-copy sha256 == manifest `sha256_source`) |
| Copy failures | **0** (`apply.errors` empty) |
| Method | `mkdir -p $(dirname dst)` + `cp -p` per row (mode+mtime preserved), immediate sha256 verify per row |

Commands executed (driver `/tmp/opencode/p39/apply.sh`, plan emitted from frozen JSON):

```bash
while IFS=$'\t' read -r src dst want; do
  mkdir -p "$(dirname "$dst")"
  cp -p "$src" "$dst"
  [ "$(sha256sum "$dst" | cut -d' ' -f1)" = "$want" ] || record-mismatch
done < /tmp/opencode/p39/copy.plan   # 1,992 rows from migration-manifest.json
```

## 2. Per-Destination Counts (on-disk after apply)

| Destination | Files |
|---|---|
| `phases/**` (39 subdirs, phase01…phase39 incl. phase31v2) | 1,431 |
| `archive/pre-p13/` | 305 |
| `audits/` | 177 |
| `current/` | 38 |
| `ledgers/` | 33 |
| `releases/` | 8 |
| infrastructure (migration-manifest.json) | 1 |
| **Total on disk under canonical/** | **1,993** (+ INDEX.md and evidence-index written immediately after) |

## 3. Disk Delta

| Measure | Bytes |
|---|---|
| `du -sb ops/reports` pre-apply | 41,591,558 |
| `du -sb ops/reports` post-apply | 81,986,134 |
| Delta | **+40,394,576** |
| `du -sb ops/reports/canonical` | 40,963,838 (incl. ~1.37 MB manifest) |

Matches the P38 estimate of ≈2× corpus size for canonical set without archive mirror duplication.

## 4. Original-Tree Untouched Proof

10-source baseline hashed pre-apply (`/tmp/opencode/p39/prestate.txt`); re-hashed post-apply:
**9/9 corpus sources byte-identical** (diff of hash sets = empty); the 10th sample
(`generated/templates/audit.md.tmpl`) is intentionally outside manifest scope (exclusion rule §3 of
phase39-44) and was likewise never written. `cp -p` preserved mtimes; no original path appears as a
copy destination anywhere in the manifest.

## 5. Status

**COMPLETE.** No partial state: failures=0, mismatches=0, collisions were 0 pre-apply. Post-apply
artifacts generated in order: `MIGRATION-MANIFEST.sha256`, `INDEX.md`,
`evidence-indexes/evidence-index.md`. Verification continues in phase39-47/48/49.
