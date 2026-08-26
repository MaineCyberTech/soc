# Phase 38 Deterministic Naming Standard

**Report ID:** phase38-56-naming-standard
**Phase:** 38
**Title:** Phase 38 Naming Standard — Deterministic Lowercase Filenames for the Report Corpus
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:06:00Z
**Classification:** INTERNAL
**Status:** PASS
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-56-naming-standard.md`
**Retention Class:** canonical-current

---

## 1. Purpose

Every file in the canonical tree gets a deterministic, lowercase, sortable name. The original filename is ALWAYS preserved in `metadata.source_path` and in `migration-map.csv` — renaming never destroys provenance.

## 2. Naming Patterns

### 2.1 Working / canonical report

```
{phase}-{seq}-{slug}.md
```

- `{phase}`: 1–2 digits, zero-padded to 2 (`01`–`37`), or revision form `31v2`
- `{seq}`: 2-digit zero-padded sequence within the phase (`00`–`99`)
- `{slug}`: lowercase kebab-case topic

Regex:
```regex
^(0[1-9]|[12][0-9]|3[0-7])v?([2])?-(0[0-9]|[1-9][0-9])-[a-z0-9]+(-[a-z0-9]+)*\.md$
```

Practical validator (used by report-ci):
```regex
^[0-9]{2}(v[0-9]+)?-[0-9]{2}-[a-z0-9]+(-[a-z0-9]+)*\.md$
```

Examples: `38-13-current-state-claims.md`, `31v2-04-routing-fix.md`.

### 2.2 Phase finals

```
final-{phase}-operator-report-{YYYYMMDD-HHMM}Z.md
```

Regex:
```regex
^final-phase[0-9]+(v[0-9]+)?-operator-report-[0-9]{8}-[0-9]{4}Z\.md$
```

Examples (existing, conformant): `final-phase37-operator-report-20260825-1943Z.md`, `final-phase31v2-operator-report-20260824-235617Z.md` (legacy instance lacks trailing Z — grandfathered, see §6).

### 2.3 Ledgers

```
{name}-ledger.{md|json|csv}
```

Triad rule: a ledger named `{name}` SHOULD exist in all three formats; `{name}` matches `^[a-z0-9]+(-[a-z0-9]+)*$`.
Examples: `claims-ledger.md|.json|.csv`, `actions-ledger.csv`, `verification-ledger.md`.

### 2.4 Client-safe deliverables

```
client-{phase}-{type}-{slug}.md
```

Regex: `^client-(0[1-9]|[1-9][0-9])(v[0-9]+)?-[a-z0-9]+(-[a-z0-9]+)*(-[a-z0-9]+)*\.md$`
Example: `client-38-scorecard-monthly.md`. The `client-` prefix is mandatory and is the primary gate key (phase38-57 §2.8).

### 2.5 Audits (timestamped instances)

```
{family}-audit-{YYYYMMDD}-{HHMMSS}.md        (machine-emitted)
{family}-audit.md                            (family baseline/template)
```

Matches existing corpus: `backup-dr-audit-20260811-042054.md`, `backup-dr-audit.md`.

### 2.6 Generated machine artifacts

```
catalog-{domain}.{json|csv}
migration-map.csv
```

Example: `catalog-reports.json` (phase38-61).

### 2.7 Templates

```
{report-type}.md.tmpl
```

Example: `phase-final.md.tmpl` (phase38-65). Double extension is required.

## 3. Character Rules

| Rule | Value |
|---|---|
| Charset | `a-z`, `0-9`, `-` only (plus required extensions) |
| Case | lowercase everywhere; uppercase only inside `Z` timestamp literal and `final-`/`client-` literals as defined |
| Separators | single hyphen between tokens; no leading/trailing hyphen; no `--`, `_`, spaces |
| Slug length | 3–48 chars |
| Dates | `YYYYMMDD`, times `HHMM[Z]` or `HHMMSS`, always UTC with `Z` suffix on finals |
| Sortability | name sorts chronologically within family because timestamp is embedded |

## 4. Collision Rules

1. **Byte-identical (same SHA-256):** never duplicate under a second canonical name. Keep one canonical file; all other paths become alias rows in `migration-map.csv` pointing at it (corpus currently has 3 duplicate groups / 12 files per phase38-05).
2. **Same normalized name, different content:** disambiguate by appending the original embedded date: `{slug}-{YYYYMMDD}.md`. If still colliding, append `-a`, `-b` (lexicographic tie-break by ascending SHA-256).
3. **Phase-sequence collisions across roots:** resolved by phase number first, then seq, then slug; the loser keeps its name but lands in `archive/pre-p38/` with an alias row.
4. **Case-insensitive filesystem safety:** names differing only by case are collisions (rule 2 applies after lowercasing).
5. **Reserved prefixes:** `final-`, `client-`, `catalog-`, `INDEX` are reserved and may not be used as slug heads elsewhere.

## 5. Determinism Guarantee

Given (original path, content hash), the canonical name is computable without ambiguity:

```
canon(orig) := pattern(orig-class) applied to parsed(orig)
```

Re-running the mapper on the same input MUST yield byte-identical `migration-map.csv`. This is asserted in Phase E verification (phase38-59 §6).

## 6. Grandfathering

Files predating this standard that cannot conform without semantic loss (e.g., `01-preflight-20260810-060311.md` — numeric-prefix-only, no slug-seq; `final-phase35-operator-report-20260825-1841Z.md` — non-padded time) are migrated **name-unchanged** into their canonical directory, flagged `naming=legacy` in the map, and renamed only if a collision forces it. No legacy rename may occur in the same commit as the structural migration.

## 7. Provenance Preservation (NON-NEGOTIABLE)

For every migrated file:

```yaml
metadata:
  source_path: "/opt/mct-security-stack/ops/reports/<original-name>"
  original_filename: "<original-name>"
  canonical_path: "reports/<tree-location>"
  migration_batch: "p38-A"
```

and a corresponding row in `generated/migration-map.csv`:

```csv
source_path,canonical_path,sha256_before,sha256_after,alias_of,naming
```

Deleting or editing `source_path` anywhere in the tree is a P0 violation.
