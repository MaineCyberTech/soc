# Phase 40 Duplicate Apply

**Report ID:** phase40-80-duplicate-apply
**Phase:** 40
**Title:** DUP-APP-40-01 — Machine-Readable Alias Ledger CREATED (`canonical/ledgers/source-map-aliases.json`); 2 Rows Applied Non-Destructively; Zero Deletions Verified
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (APPLIED)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-80-duplicate-apply.md`

---

## 1. Why a New JSON Ledger (per phase39-86 promotion plan)

phase39-86 §3 recorded the alias table INLINE because no machine-readable source map
existed, and named its P40 promotion: "to be promoted into a machine map when the
manifest schema gains an alias_of column". This apply executes that promotion as a
dedicated ledger: `canonical/ledgers/source-map-aliases.json` (the existing
`phase38-62-source-map.md` is an immutable-era rules document and was not modified).
The inline P39 table remains as historical record; the JSON supersedes it as the machine
source of truth.

## 2. Applied Rows (2)

| # | original_path | canonical_path | relationship | sha256 | group |
|---|---|---|---|---|---|
| 1 | ops/reports/phase37-81-final.md | ops/reports/final-phase37-operator-report-20260825-1943Z.md | duplicate-alias | ef6e5a84644dacdedd60c89d1ba5a8dbb306278ef93aec7aaf287c50b411fd90 | DUP-39-B |
| 2 | ops/reports/phase5-current-resource-state.md | ops/reports/resource-trend-20260811-070615.md | duplicate-alias | fdad4fe16f91b4f432bcbc4048c6788310f457aa4db701742dfdbfb070fbe9c7 | DUP-39-C |

Group DUP-39-A carried in the same file under `deferred_groups` with DEFER status —
explicitly NOT applied as alias rows (DUP-DEC-40-01).

## 3. File Diff (new file → full content summary)

`canonical/ledgers/source-map-aliases.json`: header fields `ledger`,
`description`, `created_utc=2026-08-26T02:50:00Z`, `decision_id=DUP-DEC-40-01`,
`apply_id=DUP-APP-40-01`, `method="source-map entries ONLY; zero deletions"`,
`supersedes_inline_table` pointer to phase39-86 §3; `rows[]` = the two rows above each
carrying canonical_rule, retention_class, protected_evidence_overlap=false,
decided_by, applied_utc; `deferred_groups[]` = DUP-39-A entry with reason.
`python3 -m json.tool` validation: PASS.

## 4. Zero-Deletion Verification

```
$ ls -1 ops/reports/{phase37-81-final.md,final-phase37-operator-report-20260825-1943Z.md,
                  phase5-current-resource-state.md,resource-trend-20260811-070615.md} | wc -l → 4
$ sha256sum spot-check post-apply:
  phase37-81-final.md                    ef6e5a84… (unchanged)
  phase5-current-resource-state.md       fdad4fe1… (unchanged)
$ originals-tree md file count post-apply: 2111 (no removals)
```

No file was moved, renamed, or deleted; both names in each pair remain fully resolvable;
all historical backlinks continue to resolve to unchanged bytes.

## 5. Applied-Row Count

**2 alias rows applied** (+1 deferred group record). Approval basis: standing pack
instruction + non-destructive method (see DUP-DEC-40-01 §3). Rollback: delete the JSON
rows (or the whole advisory file) — no filesystem state to restore.
