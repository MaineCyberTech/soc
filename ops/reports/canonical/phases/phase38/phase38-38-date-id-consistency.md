# Phase 38-38: Date & ID Consistency Validation

**Title:** Phase 38-38: Date **Report ID: ID Consistency Validation
**Report ID:** phase38-38-date-id-consistency
**Phase:** 38
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-38-date-id-consistency.md`
**Retention Class:** LONG
**Author:** opencode (ox-alpha)

---

## 1. Purpose

Validate dates, timestamps, phase IDs, report IDs, and labels across filenames and git history. Today is **2026-08-25**; anything later is future-dated and impossible. Checks performed against `ops/reports/` (1,833 .md files) and git log of `/opt/mct-security-stack`.

---

## 2. Findings

### DT-01: No future-dated artifacts — PASS

- Filename date census: all embedded dates fall in 20260810–20260825 (`ls | grep -oE "2026[0-9]{4}"` distribution: 96×0811 … 10×0825). Pattern search for 2026-09+ through 2027 returned zero filename hits.
- Git HEAD `7bd3b82` committed **2026-08-25 19:43:58 +0000** — consistent with the live-state release claim (v1.3.0 @ 7bd3b82).

### DT-02: Timestamp format drift in final-report names

| Field | Value |
|---|---|
| Finding | `final-phase35-operator-report-20260825-1841Z.md` uses minute-resolution `1841Z`, breaking the HHMMSS convention used by all 35 other finals (e.g., `final-phase34-operator-report-20260825-174138.md`) |
| Risk | Sort/parsers expecting 6-digit time groups will mis-order or fail |
| Action | Accept as-is under G1 (no renames); record as naming-standard exception in `generated/phase38-56-naming-standard.md` |

### DT-03: Phase ID suffix variant `31v2`

- Files: `final-phase31v2-operator-report-20260824-235617.md`; phase31 and phase31v2 both have full report families (77 + separate v2 set).
- Impact: Phase-numbering queries must special-case the suffix; chronology tooling (`generated/phase38-12-phase-chronology.md`) already handles it, but ad-hoc counts (e.g., "36 finals") silently include it.
- Canonical: treat 31v2 as a distinct phase key everywhere.

### DT-04: Phase 38 generated/ numbering gaps

Existing IDs in `generated/`: 00–17, 21–24, 31–32, 43–46, 55–60, 67–76, 79–82, 90–96 (this batch fills 33–42).

Gaps: **18–20, 25–30, 47–54, 61–66, 77–78, 83–89.**

- Master self-description says "Phase 38 executed 9 prompts" (`generated/phase38-00-master.md:19`) — overtaken by events; actual plan expanded to ~97 prompt slots with intentional reserved ranges (43–54 generation, 55–66 canonical design, 73–76 hardening/workflow, 83–89 reserve).
- Action: annotate gap ranges as RESERVED vs VOID in the canonical index so audits don't flag them as missing reports.

### DT-05: Duplicate report identities

| Duplicate | Evidence |
|---|---|
| `final-phase37-operator-report-20260825-1943Z.md` ≡ `phase37-81-final.md` | byte-identical, SHA `ef6e5a84…` — group D3 (`generated/phase38-05-report-hash-duplicates.md:69-71`); inventory note at `generated/phase38-04-report-inventory.md:88` |
| Resource-state copy pair | group D2, SHA `fdad4fe1…` (`generated/phase38-05…:50-53`) |
| 8 empty stubs share the empty hash | group D1 (`generated/phase38-05…:25-28`) |

### DT-06: Non-unique report titles within a phase

- `phase36-51-ux-fix.md` through `phase36-59-ux-fix.md`: nine files whose descriptive slug is identical ("ux-fix"); only sequence numbers disambiguate. Title lines inside also repeat the same stem, so citation by title alone is ambiguous.

### DT-07: In-file dates uniform to a fault (single-day stamping)

- Nearly every P36/P37 report carries `Date: 2026-08-25` even though work spanned commit windows 18:42→19:44Z (git b529e3b → b7c2f18 → 7bd3b82) and P34/P35 commits earlier the same day (3d4d072 17:42Z, cbcca53 18:42Z). Day-level dating hides intra-day ordering; only timestamps in headers (e.g., `phase37-81-final.md:3` "2026-08-25T19:30Z") preserve order.
- Action: prefer full ISO timestamps in headers for any same-day series (standard exists: `generated/phase38-07-report-schema.md`).

### DT-08: Phase-numbering collisions across generations

- Root corpus uses `phaseNN-*` (2–37) plus un-prefixed early files (`15-alert-routing-complete-*.md` style), while generated/ uses `phase38-*`. The number 15 appears both as bare prefix (`15-memory-tuning-20260810-0645.md`) and would collide with any future `phase15` re-scan; root-discovery mapping lives in `generated/phase38-03-report-root-discovery.md` (its "1,877 canonical" figure remains unreconciled against the 1,856-count inventory — cross-ref phase38-39 MCY-01).
- Labels inside reports vary: "Report ID: P37-81" (`phase37-81-final.md:4`) vs full `phase38-XX-name` convention in generated/. Both readable; mapping table recommended.

### DT-09: Chronology sanity of git ↔ reports — PASS

- Sequence check: P27 (2026-08-24 06:44Z, git 9f09dda) → P28 (18:43Z) → P29 approvals (20:49Z) → P30 (22:04Z) → P31/31v2 (23:05–23:57Z) → P32/P33 (08-25 00:28/01:19Z) → P34/P35 (17:42/18:42Z) → P36 (19:02/19:18Z) → P37 (19:43Z). No commit precedes its own inputs' report timestamps in any sampled pair; no impossible orderings found.

---

## 3. Summary

| ID | Check | Result |
|---|---|---|
| DT-01 | Future dates | NONE (PASS) |
| DT-02 | Timestamp format drift | 1 exception (1841Z) |
| DT-03 | Phase suffix variant | 31v2 special-case |
| DT-04 | Generated-ID gaps | 6 reserved/void ranges; master count stale |
| DT-05 | Duplicate identities | 3 hash groups (12 files) |
| DT-06 | Non-unique slugs | 9× "ux-fix" |
| DT-07 | Same-day date-only stamping | Systemic; timestamp preferred |
| DT-08 | Prefix/label collisions | Legacy prefixes; mapping needed |
| DT-09 | Git↔report chronology | PASS |

## 4. Recommendation

Freeze two conventions going forward: (1) `final-phaseNN-operator-report-YYYYMMDD-HHMMSS.md`; (2) header `Timestamp:` mandatory whenever `Date:` alone would be ambiguous within a same-day series. Log exceptions rather than renaming history.
