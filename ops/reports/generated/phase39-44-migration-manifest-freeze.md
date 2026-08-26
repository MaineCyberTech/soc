# Phase 39 Migration Manifest Freeze

**Report ID:** phase39-44-migration-manifest-freeze
**Phase:** 39
**Title:** Phase 39-44 Migration Manifest Freeze — APPLY-39-01 Row Set, Classes, and Rollback Basis
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:20:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-44-migration-manifest-freeze.md`

---

## 1. Frozen Artifact

| Attribute | Value |
|---|---|
| Manifest path | `/opt/mct-security-stack/ops/reports/canonical/migration-manifest.json` |
| Row count | **1,992** |
| sha256 (manifest) | `890b3536f19a85aeaf5c078e6e5136493d93ca96df163e02a5385a9ad6dece85` |
| Frozen at | 2026-08-25T23:16:02Z (meta.generated_utc) |
| Generator | `/tmp/opencode/p39/build_manifest.py` (deterministic re-run must reproduce byte-identical rows for unchanged inputs) |
| Mode | copy-first (`cp -p`, mode+mtime preserved); originals never modified/moved/deleted |

Each row: `{source, dest, sha256_source}` sorted by source. Destination collisions: **0**.

## 2. Source Inventory (by top-dir)

| Source area | Rows |
|---|---|
| `ops/reports/*.md|*.txt|*.json` (flat root) | 1,843 |
| `ops/reports/generated/*` (excl. templates/) | 148 |
| `ops/reports/current/*` | 1 |
| **Total** | **1,992** |

Out-of-scope skips recorded in manifest meta: 16 files (all `.log`; extension scope is .md/.json/.csv/.txt).

## 3. Exclusions (HARD)

1. `ops/reports/canonical/**` — the migration target itself.
2. `ops/reports/generated/templates/**` — 9 template artifacts (`*.md.tmpl`), normative sources stay in place.
3. `.log` files (16) — not in the pack-defined extension scope; they remain live cron outputs at flat paths.

## 4. Mapping Rules (as frozen in meta.mapping_rules)

R0 exact `phase38-49-generate-current-state.md → current/` · R1 `^final-phase* → current/` ·
R2 `release-assurance|release-asset → releases/` · R3 `ledger|catalog|source-map|backlog|openwork|open-work → ledgers/` ·
R4 `-audit|^audit-|-drift|-governance → audits/` · R5 `^phaseNN-*|^NN- → phases/phaseNN/` · R6 unmatched → `archive/pre-p13/`.

Note vs P38 source-map (phase38-62): R4 here adds `^audit-|-governance` so `audit-healthcheck-masked-issues.md`
and `phase38-88-docs-governance.md` land in `audits/` per the P39 structure spec; `alert-volume-by-rule-*`
(7 metric snapshots) falls to R6 → `archive/pre-p13/` under this phase's literal ledger rule (deviation from P38 R5 noted; no data loss — copies retained either way).

## 5. Authority / Retention Class Summary (P38 taxonomy, phase38-58)

| Retention class | Rows | Derived from |
|---|---|---|
| `phase-history` | 1,431 | all of `phases/**` (39 distinct dirs: phase01…phase39 + phase31v2) |
| `phase-history` (finals, current-truth slot) | 37 | `current/final-phase*` (36 legacy finals + final-phase38) |
| `canonical-current` | 32 | `ledgers/*` ledgers/source-map/backlog/openwork + `current/phase38-49-generate-current-state.md` |
| `generated-cache` | 179 | `audits/**` (177) + `catalog-reports.{json,csv}` (2) |
| `ARCHIVE-SUPERSEDED` | 305 | `archive/pre-p13/**` strays (dated one-offs, logs-as-txt, metric snapshots, canary raw json) |
| `release-record` | 8 | `releases/**` (release-assurance family) |
| **Total** | **1,992** | |

## 6. Rollback Manifest

Rollback = inverse of apply. Because migration is copy-first, dest→source is identity-by-name and
the sanctioned rollback is removal of ONLY the enumerated destination tree:

```bash
# primary rollback (honors dry-run finding F1; run BEFORE any git operation)
rm -rf /opt/mct-security-stack/ops/reports/canonical/
git reset --hard origin/main   # optional secondary: restores tracked-file drift only
```

Scope guard: `canonical/` contains nothing that existed pre-apply except the target dir itself;
any future content added under `canonical/` outside manifest rows must be removed separately and
is out of APPLY-39-01 rollback scope. Originals are untouched by construction, so rollback restores
the exact prior world with zero data loss.

## 7. Freeze Statement

The row set above is FROZEN as of 2026-08-25T23:16:02Z. Reports authored later in this phase
(phase39-43…52 including this one) are post-freeze corpus additions: they are intentionally NOT in
APPLY-39-01 rows and remain canonical-resident in `generated/` until phase close (P38 §4.11 practice).
Apply proceeds against the frozen hash only.
