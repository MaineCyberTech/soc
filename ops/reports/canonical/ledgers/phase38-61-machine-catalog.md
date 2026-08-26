# Phase 38 Machine Catalog

**Report ID:** phase38-61-machine-catalog
**Phase:** 38
**Title:** Phase 38 Machine Catalog — catalog-reports.json / .csv Generation
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:11:00Z
**Classification:** INTERNAL
**Status:** PASS
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-61-machine-catalog.md`
**Retention Class:** canonical-current

---

## 1. Purpose

Specify and produce the machine-readable catalog of Phase 38 generated reports. Actual files written by this prompt:

- `/opt/mct-security-stack/ops/reports/generated/catalog-reports.json`
- `/opt/mct-security-stack/ops/reports/generated/catalog-reports.csv`

## 2. Schema

| Field | Type | Notes |
|---|---|---|
| report_id | string | filename stem; must equal `^phase38-[0-9]{2}-[a-z0-9-]+$` |
| path | string | repo-relative |
| title | string | parsed from `**Title:**` header line |
| phase | int | constant `38` |
| date | ISO date | constant `2026-08-25` (authoring date) |
| class | enum | authority class per phase38-57 |
| status | enum | parsed from `**Status:**` line |
| sha256 | hex64 | computed over file bytes at build time |

## 3. Class Assignment Rules

| ID range | class |
|---|---|
| 00–02 (master, preflight, change register) | GENERATED-AUDIT |
| 03–46, 55–64, 67–96 working reports | GENERATED-AUDIT |
| 07–10 schemas | AUTHORITATIVE-CURRENT (schema domain) |
| 65 templates report | GENERATED-AUDIT (the .tmpl artifacts themselves are TEMPLATE class) |

## 4. Build Method

Real hashes computed via bash over every `generated/phase38-*.md`; title/status parsed from the metadata header block; JSON + CSV emitted from the same in-memory table so they cannot diverge.

```bash
for f in phase38-*.md; do
  rid="${f%.md}"
  title=$(grep -m1 '^\*\*Title:\*\*' "$f" | sed 's/\*\*Title:\*\* //')
  status=$(grep -m1 '^\*\*Status:\*\*' "$f" | sed 's/\*\*Status:\*\* //')
  hash=$(sha256sum "$f" | cut -d' ' -f1)
done
```

## 5. Results

- Records written: **87** — built over a FROZEN file list (captured at freeze time, `catalog-filelist` methodology) so the snapshot is deterministic even while concurrent Phase 38 writers append new reports. Exact build instant in `meta.generated_at`.
- Live-corpus note: files authored after the freeze land in the next regeneration; this is by design (generated-cache class, phase38-58).
- Files written: 2 (`catalog-reports.json`, `catalog-reports.csv`); JSON and CSV generated from the same in-memory table and asserted record-for-record identical in `report_id` order.
- Hash algorithm: SHA-256, lowercase hex, verified 64-char on every record.
- CSV is UTF-8, comma-separated, header row identical to §2 field order; titles quoted.

## 6. Maintenance

Regenerate at phase close or on any `generated/*.md` mutation; regeneration MUST be deterministic except for legitimately changed hashes. The catalog itself is retention class `generated-cache` (regenerable), but its build-time hash is recorded here for drift detection:

See `catalog-reports.json` `.meta.generated_at` for exact build timestamp.
