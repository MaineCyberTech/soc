# Duplicate Collapse DUP-39-01

**Report ID:** phase39-86-duplicate-collapse
**Phase:** 39
**Title:** Duplicate Collapse DUP-39-01 — Exact-Duplicate Group Recompute, Approval-Gated Alias Mapping, Protected-Evidence Check
**Date:** 2026-08-25
**Timestamp:** 2026-08-26T00:04:00Z
**Classification:** INTERNAL
**Status:** PARTIAL (aliases documented inline; physical collapse approval-gated)
**Source Path:** `ops/reports/generated/phase39-86-duplicate-collapse.md`

---

## 1. Method

Exact-duplicate groups recomputed live across the **originals tree** (`ops/reports/`, excluding
`canonical/` and `.git`) — the same scope class as the P38 finding (26 sha256 groups, pre-migration,
wider corpus state):

```
$ find . -path ./canonical -prune -o -name "*.md" -type f -print0 | xargs -0 sha256sum | sort
$ awk '{print $1}' dupscan.txt | uniq -c | awk '$1>1'   → 3 groups >1 file
```

## 2. Current Groups (3 groups, 12 files)

### Group DUP-39-A — hash `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` (8 files)

```
./phase33-61-.md … ./phase33-68-.md
```

The eight zero-byte stubs (phase39-85 §2 Family A). "Duplicate" here is an artifact of emptiness;
collapse is meaningless until stub disposition resolves. Alias target: none designated.

### Group DUP-39-B — hash `ef6e5a84644dacdedd60c89d1ba5a8dbb306278ef93aec7aaf287c50b411fd90` (2 files)

```
./final-phase37-operator-report-20260825-1943Z.md
./phase37-81-final.md
```

Byte-identical Phase 37 final under two names. Alias decision: canonical name =
`final-phase37-operator-report-20260825-1943Z.md` (finals keep filename-stem IDs per source-map
rule R1); `phase37-81-final.md` → **duplicate-alias of the final**.

### Group DUP-39-C — hash `fdad4fe16f91b4f432bcbc4048c6788310f457aa4db701742dfdbfb070fbe9c7` (2 files)

```
./phase5-current-resource-state.md
./resource-trend-20260811-070615.md
```

Phase 5-era resource snapshot duplicated by a later dated capture. Alias decision: canonical name =
`resource-trend-20260811-070615.md` (dated instance rule, newest-wins within family per source-map
§4); `phase5-current-resource-state.md` → **duplicate-alias of the dated capture**.

Note: P38's count of 26 groups included states since absorbed by migration dedup and by this
narrower originals-only scope; 3 is the current true count. No new duplicates were introduced by
APPLY-39-01 inside `canonical/` itself (copy-first produced exactly one copy per row; manifest
1,992 rows verified phase39-48).

## 3. Approval-Gated Collapse Mechanism

Collapse = create alias entries mapping original → canonical-dup-target with
`relationship=duplicate-alias`; **no file deletions** at any step. Machine-readable check:

```
$ ls canonical/ledgers/ | grep -i map
phase28-33-canonical-source-map.md
phase38-62-source-map.md
```

Both are Markdown rule/row documents; **no machine-readable source-map file exists**
(`migration-manifest.json` rows carry provenance, not alias relationships). Per the gating rule,
the append therefore lands INLINE here as the authoritative alias table, to be promoted into a
machine map when the manifest schema gains an `alias_of` column (P40 item):

| original_path | canonical-dup-target | relationship |
|---|---|---|
| ops/reports/phase37-81-final.md | ops/reports/final-phase37-operator-report-20260825-1943Z.md | duplicate-alias |
| ops/reports/phase5-current-resource-state.md | ops/reports/resource-trend-20260811-070615.md | duplicate-alias |

DUP-39-A members are excluded pending stub disposition (phase39-85) — aliasing eight empty files
to one empty file adds no information.

Physical collapse (path retirement in catalogs/backlinks) requires operator sign-off per AGENTS.md
approval-gated operations and is deferred; until then both names remain resolvable.

## 4. Protected-Evidence Check

Verified: all three groups resolve entirely inside `ops/reports/`. Cross-checked group paths against
`ops/evidence/**` (contents: p37/p38/p39 workflow exports, p39 dashboards) and `ops/backups/**`
(workflow JSONs, DB dumps, config tars): **zero overlap**. No evidence or backup artifact is a
member, source, or target of any duplicate group. Collapse cannot touch protected stores.

## 5. Backlink Preservation Statement

Because no file is deleted and aliases are recorded rather than enforced, every historical backlink
(including pre-migration flat paths pinned in `migration-manifest.json` and report cross-references)
continues to resolve to real bytes with unchanged sha256. When physical collapse is later approved,
the alias table above converts mechanically into catalog redirect rows without touching any
report body.

## 6. Status

PARTIAL: recomputed, adjudicated, alias mapping documented inline, protected stores cleared;
machine-readable append and path retirement await (a) manifest schema extension and (b) operator
approval respectively.
