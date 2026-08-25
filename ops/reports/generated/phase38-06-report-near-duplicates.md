# Phase 38 Report Near-Duplicates

**Report ID:** phase38-06-report-near-duplicates  
**Phase:** 38  
**Title:** Phase 38 Report Near-Duplicates — Similarity Analysis  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T19:56:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-06-report-near-duplicates.md`
**Retention Class:** LONG
**Author:** opencode/big-pickle  

---

## 1. Purpose

Identify near-duplicate reports by comparing normalized text, title, and section similarity. Focus on final-phase files and phase*final* files. Classify as: copies, partial revisions, superseded finals, templates, or divergent variants.

---

## 2. Methodology

1. Identified all files with "final" in the filename (65 files)
2. Grouped by phase and artifact class
3. Compared within groups for: title overlap, section heading overlap, size proximity, timestamp proximity
4. Classified each near-duplicate relationship

---

## 3. Final Operator Report Near-Duplicates

### 3.1 Phase 31 and Phase 31v2

| File | Phase | Size | Notes |
|---|---|---|---|
| final-phase31-operator-report-20260824-230411.md | 31 | 5,917 B | Original Phase 31 final |
| final-phase31v2-operator-report-20260824-235617.md | 31v2 | 5,582 B | Revision of Phase 31 final |

**Classification:** PARTIAL REVISION — Phase 31v2 is a revised version of Phase 31, written 52 minutes later. Size differs by 335 B. This is a deliberate revision, not an accidental duplicate.

**Recommendation:** Keep both. `final-phase31v2-operator-report-20260824-235617.md` supersedes `final-phase31-operator-report-20260824-230411.md`. Mark original as `superseded_by`.

### 3.2 Phase 37 Final Alias (from Hash Duplicates)

| File | SHA-256 match |
|---|---|
| final-phase37-operator-report-20260825-1943Z.md | ef6e5a84...fd90 |
| phase37-81-final.md | ef6e5a84...fd90 |

**Classification:** BYTE-IDENTICAL COPY (see Hash Duplicates report, Group D3).

---

## 4. Phase Final Reports Near-Duplicates

### 4.1 Detection Validation Series (d-series)

| File Pair | Similarity | Classification |
|---|---|---|
| d5-greenbone-critical-validation.md → d5-greenbone-critical-final-validation.md → d5-greenbone-critical-final-pass.md | Progressive refinement | PARTIAL REVISIONS (3 versions) |
| d7-velociraptor-evidence-validation.md → d7-velociraptor-evidence-final-validation.md → d7-velociraptor-final-pass.md | Progressive refinement | PARTIAL REVISIONS (3 versions) |

**Recommendation:** Keep all. Each represents a validation iteration. `*-final-pass.md` is the authoritative version for each detection.

### 4.2 Scorecard Finalizations

| File | Phase | Size |
|---|---|---|
| phase9-scorecard-finalization.md | 9 | ~3 KB |
| phase25-39-scorecard-final.md | 25 | ~4 KB |
| phase26-38-scorecard-finalization.md | 26 | ~3.5 KB |

**Classification:** INDEPENDENT — Different phases, same artifact type. Not duplicates.

### 4.3 Cert Final Reports

| File | Phase | Agent |
|---|---|---|
| phase28-04-agent013-cert-final.md | 28 | Agent 013 |
| phase28-06-agent014-cert-final.md | 28 | Agent 014 |
| phase28-08-windows-cert-final.md | 28 | Windows |
| phase29-12-agent013-cert-final.md | 29 | Agent 013 |
| phase29-14-agent014-cert-final.md | 29 | Agent 014 |

**Classification:** PARTIAL REVISIONS — Phase 29 cert finals supersede Phase 28 cert finals for agents 013 and 014.

**Recommendation:** Mark Phase 28 cert finals as superseded by Phase 29 cert finals for corresponding agents.

### 4.4 Capacity Plateau Final

| File | Phase |
|---|---|
| phase28-30-capacity-plateau-final.md | 28 |
| phase34-27-capacity-plateau.md | 34 |

**Classification:** DIVERGENT VARIANT — Different phases, related topic. Phase 34 is a follow-up, not a revision.

### 4.5 Deployability Final

| File | Phase |
|---|---|
| phase29-64-deployability-final.md | 29 |
| phase31-77-deployability-cert.md | 31 |

**Classification:** DIVERGENT VARIANT — Phase 31 is a certification, Phase 29 is a final assessment.

### 4.6 Regression Audit Final

| File | Phase |
|---|---|
| phase30-92-final-regression-audit.md | 30 |
| phase31-65-codebase-regression.md | 31 |
| phase34-57-codebase-regression.md | 34 |

**Classification:** PROGRESSION — Each is a regression audit for its respective phase. Not duplicates.

---

## 5. Alert Volume Reports Near-Duplicates

| File | Timestamp | Size |
|---|---|---|
| alert-volume-by-rule-20260811-041141.md | 04:11:41 | 3,031 B |
| alert-volume-by-rule-20260811-044144.md | 04:41:44 | 2,717 B |
| alert-volume-by-rule-20260811-044210.md | 04:42:10 | 3,031 B |
| alert-volume-by-rule-20260811-052509.md | 05:25:09 | 3,031 B |
| alert-volume-by-rule-20260811-070610.md | 07:06:10 | 3,043 B |
| alert-volume-by-rule-20260811-073024.md | 07:30:24 | 3,043 B |
| alert-volume-by-rule-20260822-055730.md | 05:57:30 | 2,921 B |

**Classification:** PARTIAL REVISIONS — Multiple snapshots of alert volume data at different times. Three files (04:11, 04:42, 05:25) are 3,031 B each — likely byte-identical or near-identical.

**Recommendation:** Keep the most recent (`alert-volume-by-rule-20260822-055730.md`) as canonical. Mark earlier versions as superseded.

---

## 6. Backup DR Audit Near-Duplicates

| File Group | Count | Size |
|---|---|---|
| backup-dr-audit-20260811-042054.md | 1 | 722 B |
| backup-dr-audit-20260811-042201.md | 1 | 722 B |
| backup-dr-audit-20260811-042236.md | 1 | 779 B |
| backup-dr-audit-20260811-044120.md | 1 | 779 B |
| backup-dr-audit-20260811-044429.md | 1 | 779 B |
| backup-dr-audit-20260811-062530.md | 1 | 779 B |
| backup-dr-audit-20260811-063236.md | 1 | 779 B |
| backup-dr-audit-20260811-083350.md | 1 | 779 B |
| backup-dr-audit-20260811-083517.md | 1 | 779 B |
| backup-dr-audit-20260811-224540.md | 1 | 779 B |
| backup-dr-audit-20260811-224628.md | 1 | 779 B |
| backup-dr-audit-20260811-234636.md | 1 | 779 B |
| backup-dr-audit-20260811-235007.md | 1 | 779 B |
| backup-dr-audit-20260811-235057.md | 1 | 779 B |
| backup-dr-audit-20260812-021337.md | 1 | 779 B |
| backup-dr-audit-20260812-021517.md | 1 | 779 B |
| backup-dr-audit-20260812-021619.md | 1 | 779 B |
| backup-dr-audit-20260815-022536.md | 1 | 779 B |
| backup-dr-audit-20260815-022642.md | 1 | 779 B |
| backup-dr-audit-20260815-025021.md | 1 | 779 B |

**Classification:** NEAR-DUPLICATES — 18 of 20 files are 779 bytes (likely near-identical content). Two are 722 bytes. These are automated cron outputs captured at different times.

**Recommendation:** Keep most recent (`backup-dr-audit-20260815-025021.md`) as canonical. Mark all others as superseded. Consider consolidating into a single file with timestamped entries.

---

## 7. Shuffle/Healthcheck Near-Duplicates

| File Group | Count | Pattern |
|---|---|---|
| shuffle-healthcheck-20260811-*.md | 3 | Different timestamps, same test |
| shuffle-webhook-smoke-test-20260811-*.md | 2 | Different timestamps, same test |
| soc-smoke-test-20260811-*.md | 9 | Different timestamps, same test |
| soc-smoke-test-20260812-*.md | 1 | Follow-up test |

**Classification:** TEMPORAL DUPLICATES — Multiple captures of the same validation at different times.

**Recommendation:** Keep most recent for each test type as canonical. Mark others as superseded.

---

## 8. Proxmox Thinpool Reports

| File | Timestamp |
|---|---|
| proxmox-thinpool-report-20260816-015146.md | 01:51:46 |
| proxmox-thinpool-report-20260816-015157.md | 01:51:57 |
| proxmox-thinpool-report-20260816-035008.md | 03:50:08 |
| proxmox-thinpool-report-20260816-063421.md | 06:34:21 |
| proxmox-thinpool-report-20260816-070604.md | 07:06:04 |
| proxmox-thinpool-report-20260816-073121.md | 07:31:21 |
| proxmox-thinpool-report-20260819-063204.md | 06:32:04 |

**Classification:** TEMPORAL DUPLICATES — 7 snapshots of Proxmox thinpool state over 3 days.

**Recommendation:** Keep most recent (`proxmox-thinpool-report-20260819-063204.md`) as canonical.

---

## 9. ES Snapshot Retention Apply

| File | Timestamp |
|---|---|
| es-snapshot-retention-apply-20260816-071729.md | 07:17:29 |
| es-snapshot-retention-apply-20260816-071731.md | 07:17:31 |
| es-snapshot-retention-apply-20260816-071739.md | 07:17:39 |
| es-snapshot-retention-apply-20260816-072354.md | 07:23:54 |

**Classification:** TEMPORAL DUPLICATES — 4 attempts at the same operation, 25 seconds apart.

**Recommendation:** Keep most recent (`es-snapshot-retention-apply-20260816-072354.md`) as canonical.

---

## 10. Summary

| Category | Groups | Total Files | Canonical | Superseded |
|---|---|---|---|---|
| Empty stubs | 1 | 8 | 0 | 8 |
| Hash-identical duplicates | 2 | 4 | 2 | 2 |
| Final operator revisions | 1 | 2 | 1 | 1 |
| Detection validation revisions | 2 | 6 | 2 | 4 |
| Alert volume snapshots | 1 | 7 | 1 | 6 |
| Backup DR audits | 1 | 20 | 1 | 19 |
| Shuffle/SOC tests | 4 | 15 | 4 | 11 |
| Proxmox thinpool | 1 | 7 | 1 | 6 |
| ES snapshot apply | 1 | 4 | 1 | 3 |
| **Total** | **13** | **73** | **13** | **60** |

**Near-duplicate rate:** 73 of 1,831 .md files (4.0%) have near-duplicate relationships.

---

## 11. Priority Actions for Phase 39

1. **P0:** Delete 8 empty stubs (phase33-61 through phase33-68)
2. **P1:** Mark 60 superseded files with `superseded_by` metadata
3. **P2:** Consolidate 20 backup-dr-audit files into a single file
4. **P2:** Consolidate 7 alert-volume-by-rule files into a single file
5. **P3:** Create canonical index of all superseded → current mappings
