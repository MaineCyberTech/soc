# Phase 39 Migration Precheck

**Report ID:** phase39-43-migration-precheck
**Phase:** 39
**Title:** Phase 39-43 Migration Precheck — GO/NO-GO Gates Before Copy-First Apply (APPLY-39-01)
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:17:30Z
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-43-migration-precheck.md`

---

## 1. Purpose

Run every gate required before applying the Phase 38 canonical-structure design (phase38-55,
phase38-59) to the live corpus via copy-first migration APPLY-39-01. All numbers below are from
live commands executed 2026-08-25T23:14–23:17Z. No writes to report bodies occurred during this
precheck (manifest build writes only to `ops/reports/canonical/`).

## 2. Gate Results

| # | Gate | Result | Evidence |
|---|---|---|---|
| G1 | Redaction clean on tracked files | **PASS** | `git ls-files -z ops/reports ops/evidence \| xargs -0 grep -lI "stCG-\|0c953f60-5cca"` → **0 files**. Repo-wide sweep matches only `ops/scripts/p38-report-ci.sh` line 65, which is the CI *pattern literal* (`'stCG-[A-Za-z0-9]{20,}'` inside `SECRET_PATTERNS=(...)`), not a live secret |
| G2 | Report CI green | **PASS** | Rerun `bash ops/scripts/p38-report-ci.sh`: `files=97 errors=0 warnings=0 … RESULT: PASS (0 warnings)` — all six gates PASS (metadata ×97, unique report_ids, valid status enums, secret_lines=0, links OK, stale refs OK) |
| G3 | Catalog present | **PASS** | `catalog-reports.json` (87 report rows, meta.generated_at 2026-08-25T21:02:29Z) + `catalog-reports.csv`, both readable and parseable |
| G4 | Manifest row count ≥ ~1851 | **PASS** | Frozen manifest enumerates **1,992 rows** (≥ 1,851 dry-run baseline). Growth explained: generated/ gained phase38-78…96 (+19) and phase39-00…42 (+43) since the P38 dry-run snapshot |
| G5 | Destination collisions | **PASS** | Manifest builder collision map = `{}` → **0** duplicate destination paths across 1,992 rows |
| G6 | Backups exist | **PASS** | `ops/backups/`: iris-db daily dumps 2026-08-12…2026-08-25 (14), `docker-compose.shuffle.yml.pre-p39-hardening`, `p29-image-pin-rollback/{docker-compose.opencanary.yml,docker-compose.shuffle.yml}`, `shuffle-workflows/*.json` ×5 (latest 20260823), `agents/`, key files (0600) |
| G7 | Git state understood | **PASS** | See §3 — all dirty state is attributable and none blocks a copy-only operation |

## 3. Git State (uncommitted categories)

Modified (tracked, `git diff --name-only ops/reports`):

| Category | Files |
|---|---|
| Catalog maintenance (this phase) | `generated/catalog-reports.json`, `generated/catalog-reports.csv` |
| Secret redaction edits (phase39-09) | `generated/phase38-74-shuffle-inventory.md`, `ingest-pipeline-inventory-20260816-081826.md`, `phase36-10-shuffle-workflow-status.md`, `phase36-11-shuffle-auth-failure.md`, `phase36-12-shuffle-create-test-manifest.md` |

Untracked: 43 × `generated/phase39-{00..42}-*.md`, `current/final-phase38-operator-report-20260825-2130Z.md`,
plus `canonical/` infrastructure created moments ago by this precheck (migration-manifest.json only).

Outside ops/reports (context): `.gitignore`, `compose/docker-compose.shuffle.yml` (modified),
`ops/evidence/p37-workflow-export/*`, `p38-workflow-export/*` (redaction-era edits),
`ops/evidence/p39-workflow-export/` (untracked). None are inputs the migration mutates.

## 4. Approval Basis

Per the pack instruction for this phase: **apply is authorized once redaction is complete** (G1)
and the P38 dry-run gates hold (phase38-68 verdict PASS). Dry-run finding F1 is honored verbatim:
rollback uses the manifest-enumerated delete, never bare `git reset`.

## 5. Invariants Reaffirmed

- COPY-FIRST: originals are never written, moved, or deleted; `cp -p` preserves mode+mtime.
- Exclusions held: `canonical/` itself and `generated/templates/**` (9 templates) are out of scope;
  16 `.log` files are out of extension scope (*.md/*.json/*.csv/*.txt only).
- Pre-apply corpus size recorded: 41,588,160 bytes (du -sb); 10-source re-hash baseline captured
  at `/tmp/opencode/p39/prestate.txt` for the untouched-original proof in phase39-45.

## 6. Verdict

**GO** — all seven gates PASS. Proceed to manifest freeze (phase39-44) then apply (phase39-45).
