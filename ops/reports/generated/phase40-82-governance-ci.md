# Phase 40 Governance CI — Full Suite Run + Catalog Backfill

**Report ID:** phase40-82-governance-ci
**Phase:** 40
**Title:** GOVCI-40-01 — All Three Governance Suites PASS Live (p38 Report CI / p39 Canonical CI / p39 AGENTS CI); Catalog Delta Found (283 files vs 165 rows) and CLOSED by Appending 118 Rows With Real sha256s; Source-Map Aliases Valid; CLIENT-SAFE Boundaries Zero Violations
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:15:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-82-governance-ci.md`

---

## 1. Suite Runs (live, this session)

### Gate Suite A — `ops/scripts/p38-report-ci.sh` (run at 2026-08-26T02:57:48Z, pre-backfill)

```
Files in scope: 97
PASS: Gate1 metadata: all 97 files carry required fields
PASS: Gate2 report_ids: unique across corpus
PASS: Gate3 status enum: all values valid
SUMMARY Gate4 secrets: files_with_hits=0 total_matching_lines=0
PASS: Gate5 links: no broken relative .md links among generated files
PASS: Gate6 stale refs: every referenced phase38 report exists on disk
CI SUMMARY: files=97 errors=0 warnings=0 RESULT: PASS (0 warnings)
```

### Gate Suite B — `ops/scripts/p39-canonical-ci.sh` (02:57:49Z)

```
PASS: Gate1 index: canonical/INDEX.md present
PASS: Gate2 manifest hash: 890b3536f19a85aeaf5c078e6e5136493d93ca96df163e02a5385a9ad6dece85 matches MIGRATION-MANIFEST.sha256
      manifest rows=1992 files-on-disk-in-canonical=1999
PASS: Gate3 headers: modern-sampled OK=3 bad=0; legacy-era sampled=27 of 30 from 1983 md files
PASS: Gate4 secrets high-confidence: 0 hits tree-wide
      low-confidence assignment-pattern lines: files_with_hits=7 total_lines=29 (informational)
PASS: Gate5 report_ids in phases/: unique
RESULT: PASS (0 warnings)
```

Note: manifest rows (1992) vs on-disk canonical files (1999) delta is the known concurrent-batch lag, informational per prior phases; Gate2 integrity hash itself matches.

### Gate Suite C — `ops/scripts/p39-agents-ci.sh` (02:58:01Z)

```
PASS: Gate1 existence / Gate2 hierarchy / Gate3 sections (11/11) / Gate4 secrets zero /
      Gate5 volatile-clean / Gate6 scripts exist / Gate7 docs exist / Gate8 length 143<=200 /
      Gate9 precedence statement
RESULT: PASS (0 warnings)
```

## 2. Manual Check — Duplicate report_ids

Covered live by p38 Gate2 (`unique across corpus`) over all 97 in-scope-at-run files and p39-canonical Gate5 over `phases/`. No manual override needed. **VERDICT: PASS.**

## 3. Manual Check — Catalog Row Count vs File Count Delta → FIXED THIS SESSION

Measured before remediation:

| Measure | Value |
|---|---|
| Files in `ops/reports/generated/*.md` | **283** |
| Rows in `canonical/ledgers/catalog-reports.json` | **165** |
| Rows in CSV | **165** |
| Missing report_ids | **118** (phase39-68…103 late batch = 36; phase40-00…81 = 82) |

Remediation EXECUTED (append-only; no existing row touched): a one-off script parsed each
uncataloged file's real metadata headers (**Report ID / Title / Phase / Date / Status**),
computed **real sha256** of file bytes, appended to both JSON and CSV in phase order, and
refreshed `meta.generated_at`.

```
appended=118 total_rows=283
first: phase39-68-release-asset-locate sha256-prefix 16513a212789e1e9
last : phase40-81-securityonion-stop-decision sha256-prefix 32d2af4d750e4144
```

Post-append verification: JSON rows = 283, CSV data rows = 283 (= file count); three-row
spot-check re-hashed from disk → `hash_ok ×3` (phase40-81, phase40-32, phase39-68).
Both suites re-run post-change: **p38 PASS (97 files), p39-canonical PASS (0 errors)** —
the ledger edit broke nothing (Gate2 covers only `migration-manifest.json`, verified by
script read before edit).

## 4. Manual Check — Source-Map Aliases File

`canonical/ledgers/source-map-aliases.json`: parses as valid JSON (`python3 json.load` +
pretty-print OK). Structure: `ledger/description/created_utc(2026-08-26T02:50:00Z)/
decision_id DUP-DEC-40-01/apply_id DUP-APP-40-01/method/rows/deferred_groups`.
Rows = **2** alias pairs (DUP-39-B final-name rule; DUP-39-C dated-instance rule), plus a
documented `deferred_groups` key for unapplied groups. Both referenced paths resolvable.
**VERDICT: PASS.**

## 5. Manual Check — CLIENT-SAFE Boundaries (counts only)

Method: regex extraction of sections headed with `CLIENT-SAFE` from the three reports that
carry such sections, then pattern sweep inside section bodies only:

| Corpus file | CLIENT-SAFE sections | IP-pattern hits | token-pattern hits |
|---|---|---|---|
| phase39-99-scorecard.md | 1 | 0 | 0 |
| phase38-92-scorecard.md | 1 | 0 | 0 |
| phase38-57-authority-model.md | 1 | 0 | 0 |
| **Total** | **3** | **0** | **0** |

Boundary model source: `docs/CLIENT-ARTIFACT-GOVERNANCE.md` (CLIENT-SAFE class forbids
internal paths/IPs/workstreams). **VERDICT: PASS (zero violations, counts-only method).**

## 6. Per-Gate Verdict Table

| # | Gate | Evidence § | Verdict |
|---|---|---|---|
| 1 | p38 six-gate suite | §1A | PASS |
| 2 | p39-canonical suite | §1B | PASS |
| 3 | p39-agents nine gates | §1C | PASS |
| 4 | Duplicate IDs | §2 | PASS |
| 5 | Catalog currency | §3 | FAIL→FIXED (118 appended; now 283=283) |
| 6 | Aliases JSON validity | §4 | PASS |
| 7 | CLIENT-SAFE separation | §5 | PASS |

## 7. Post-Write Execution Receipt (appended after authoring 82–90)

Suite re-runs after the new audit reports entered the corpus. Scope note established at
receipt time: `p38-report-ci.sh` scopes by design to the Phase-38 corpus
(`find … -name "phase38-*.md"`), hence its stable `files=97` PASS — corpus-wide coverage
for newer eras is provided by p39-canonical Gate4 (tree-wide secrets) and p39-agents CI,
both re-run PASS.

```
p38-report-ci.sh   : files=97 (P38 scope by design) errors=0 warnings=0 RESULT: PASS
secret sweep phase40-82…97 (bearer/api-key/AWS patterns) : 0 files with hits, 0 lines
catalog backfill rerun : +16 rows appended (this batch 82–90 PLUS concurrent batch
                         91–97 that landed mid-session — a live recurrence of D-40-01)
totals now 299 catalog rows = 299 generated files, JSON↔CSV parity confirmed
```

Ledger current through phase40-97 at receipt time; canonical CI re-run PASS on the
full tree.

## 8. Verdict

**GOVERNANCE-CI: PASS (all gates green after in-session catalog repair).** The single
red-to-green item (catalog lag) was closed with append-only, hash-verified writes and is
re-certified by suite re-runs.
