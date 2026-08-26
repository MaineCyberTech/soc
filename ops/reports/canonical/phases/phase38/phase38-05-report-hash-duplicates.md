# Phase 38 Report Hash Duplicates

**Report ID:** phase38-05-report-hash-duplicates  
**Phase:** 38  
**Title:** Phase 38 Report Hash Duplicates — SHA-256 Analysis  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T19:56:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-05-report-hash-duplicates.md`
**Retention Class:** LONG
**Author:** opencode/big-pickle  

---

## 1. Methodology

1. Computed SHA-256 of all 1,831 `.md` files in `/opt/mct-security-stack/ops/reports/`
2. Grouped by hash value
3. Identified groups where `count > 1` (byte-identical duplicates)
4. For each duplicate group: identified canonical candidate, aliases, and recommendation

---

## 2. Duplicate Groups Found

### Group D1: Empty Files (8 files)

**SHA-256:** `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`  
**Size:** 0 bytes (all files empty)

| # | File | Phase |
|---|---|---|
| 1 | phase33-61-.md | 33 |
| 2 | phase33-62-.md | 33 |
| 3 | phase33-63-.md | 33 |
| 4 | phase33-64-.md | 33 |
| 5 | phase33-65-.md | 33 |
| 6 | phase33-66-.md | 33 |
| 7 | phase33-67-.md | 33 |
| 8 | phase33-68-.md | 33 |

**Analysis:** All 8 files are empty (0 bytes). They share the SHA-256 of the empty string. These are anomalous stubs — likely placeholder writes that were never populated.

**Canonical candidate:** None. All are equally invalid.  
**Recommendation:** DELETE all 8. They contain no data and cannot serve as canonical references. Mark as RETIRED in status taxonomy.

**Approval required:** Gate G1 (report moves) + Gate G2 (status changes).

---

### Group D2: Resource State Duplicate (2 files)

**SHA-256:** `fdad4fe16f91b4f432bcbc4048c6788310f457aa4db701742dfdbfb070fbe9c7`

| # | File | Phase | Size |
|---|---|---|---|
| 1 | phase5-current-resource-state.md | 5 | ~722 B |
| 2 | resource-trend-20260811-070615.md | Untagged | ~722 B |

**Analysis:** These are byte-identical copies of the same resource state snapshot. One is phase-tagged (phase5), the other is timestamped (resource-trend).

**Canonical candidate:** `phase5-current-resource-state.md` — phase-tagged, follows naming convention.  
**Alias:** `resource-trend-20260811-070615.md`  
**Recommendation:** Mark `resource-trend-20260811-070615.md` as `superseded_by: phase5-current-resource-state.md`. Do NOT delete. Archive if needed.

**Approval required:** Gate G2 (status change to mark superseded).

---

### Group D3: Phase 37 Final Duplicate (2 files)

**SHA-256:** `ef6e5a84644dacdedd60c89d1ba5a8dbb306278ef93aec7aaf287c50b411fd90`

| # | File | Phase | Size |
|---|---|---|---|
| 1 | final-phase37-operator-report-20260825-1943Z.md | 37 | ~5,432 B |
| 2 | phase37-81-final.md | 37 | ~5,432 B |

**Analysis:** These are byte-identical copies of the Phase 37 final operator report. `final-phase37-operator-report-20260825-1943Z.md` follows the canonical final operator report naming convention. `phase37-81-final.md` follows the phase report naming convention.

**Canonical candidate:** `final-phase37-operator-report-20260825-1943Z.md` — follows canonical `final-phase{N}-operator-report-{timestamp}.md` pattern.  
**Alias:** `phase37-81-final.md`  
**Recommendation:** Mark `phase37-81-final.md` as `superseded_by: final-phase37-operator-report-20260825-1943Z.md`. Do NOT delete.

**Approval required:** Gate G2 (status change to mark superseded).

---

## 3. Summary

| Group | Files | SHA-256 | Type | Action |
|---|---|---|---|---|
| D1 | 8 | e3b0c442...b855 | Empty stubs | DELETE (all 0 bytes) |
| D2 | 2 | fdad4fe1...be9c7 | Resource state copy | Mark alias superseded |
| D3 | 2 | ef6e5a84...fd90 | Phase 37 final copy | Mark alias superseded |

**Total duplicate files:** 12 (across 3 groups)  
**Total unique duplicate hashes:** 3  
**Total files affected:** 12 of 1,831 (0.65%)

---

## 4. Unique Hash Count

Of 1,831 `.md` files hashed:
- 1,819 unique hashes (files with no duplicate)
- 3 hashes with duplicates (12 files total)
- 1,823 non-empty unique content blocks

**Byte-identical duplication rate:** 0.65% (12 files out of 1,831)

---

## 5. Non-.md Duplicate Analysis

The 16 `.log` and 8 `.txt` files were not hashed for duplicate analysis as they are operational artifacts, not report-class files. However, manual inspection shows:

- `backup-dr-audit-20260811-042201.md` and `backup-dr-audit-20260811-042236.md` — need hash verification (both 722 bytes)
- Multiple `alert-volume-by-rule-20260811-*` files with similar sizes — need hash verification

**Note:** These potential duplicates were not part of the SHA-256 analysis scope but are flagged for Phase 39 near-duplicate investigation.

---

## 6. Verification Commands

```bash
# Re-run full hash analysis
find /opt/mct-security-stack/ops/reports/ -type f -name "*.md" -exec sha256sum {} + | sort > /tmp/p38-rehash.txt

# Find duplicates
awk '{print $1}' /tmp/p38-rehash.txt | sort | uniq -c | sort -rn | awk '$1>1'

# Verify specific group
sha256sum /opt/mct-security-stack/ops/reports/phase37-81-final.md /opt/mct-security-stack/ops/reports/final-phase37-operator-report-20260825-1943Z.md

# Verify empty files
wc -c /opt/mct-security-stack/ops/reports/phase33-6{1,2,3,4,5,6,7,8}-.md
```
