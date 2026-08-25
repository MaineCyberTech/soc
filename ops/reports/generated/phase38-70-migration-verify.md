# Phase 38-70 Migration Verify

**Report ID:** phase38-70-migration-verify  
**Phase:** 38  
**Title:** Phase 38-70 Migration Verification — Plan Ready-To-Run; Current-State Checks PASS  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T21:13:25Z  
**Classification:** INTERNAL  
**Scope:** Post-migration verification plan + verification of what exists today (pre-apply)  
**Status:** NOT APPLICABLE YET / READY-TO-RUN  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Owners:** ["opencode/ox-alpha", "human-operator"]  
**Evidence Roots:** ["/opt/mct-security-stack/ops/reports/generated/"]  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-70-migration-verify.md`  
**Retention Class:** canonical-current  

---

## 1. Status

The migration itself has NOT been applied (phase38-69 = DEFERRED). Therefore post-migration
verification is **NOT APPLICABLE YET**. This report does two things:

1. Verifies the CURRENT state of what already exists (generated corpus, catalogs, templates) — executed now.
2. Freezes the post-migration verification checklist so it runs unmodified after apply approval.

## 2. Current-State Verification (executed 2026-08-25)

| Check | Expected | Observed | Result |
|---|---|---|---|
| `generated/` structure valid | phase38-*.md + catalogs + templates/ | 74 reports, `catalog-reports.json`, `catalog-reports.csv`, `templates/` (9 .tmpl) present | PASS |
| Catalog present & parseable | JSON loads, records have required keys | Loads; record definition `report_id,path,title,phase,date,class,status,sha256` | PASS |
| Templates present | 9 templates per phase38-65 | audit/change-register/client-safe/current-state/decision-record/incident/phase-final/scorecard/verification-ledger `.md.tmpl` | PASS |
| Git cleanliness | Only known untracked paths | HEAD 7bd3b82 clean except `generated/` + 1 stray health report | PASS |
| Immutable evidence untouched | p37/p38 workflow exports intact | `ops/evidence/p37-workflow-export/` (2 files) and `p38-workflow-export/` (4 files + SHA256SUMS) present, no writes to older roots | PASS |

## 3. Post-Migration Verification Checklist (READY-TO-RUN)

Each item is a hard gate; first failure aborts apply close-out.

### 3.1 Hash Equality
```bash
# every manifest row must hash-equal its source
while IFS=, read -r src dst alias; do
  [ "$(sha256sum "$src"|cut -d" " -f1)" = "$(sha256sum "ops/reports/$dst"|cut -d" " -f1)" ] || echo "FAIL $dst"
done < generated/migration-map.csv
```
Expected: zero FAIL lines.

### 3.2 Catalog Consistency
- Rebuilt `catalog-reports.{json,csv}` cover the migrated tree: row count == files on disk per directory.
- Every catalog entry's stored sha256 matches the file at verification time.
- Deterministic rebuild: regenerating the catalog twice yields identical bytes.

### 3.3 Link Integrity
- `ops/scripts/p38-report-ci.sh` broken-link gate passes over the new tree.
- INDEX.md resolves all referenced paths.
- Alias notes exist for every moved path cited by an ACTIVE doc (phase38-67).

### 3.4 Immutable Untouched (evidence hashes unchanged)
- Pre-apply snapshot of `sha256sum ops/evidence/**` compared byte-for-byte with post-apply snapshot.
- Any difference is a SEV-1 violation → immediate rollback.

### 3.5 Rollback Package Ready
- `manifest.paths` file exists and enumerates exactly the created destinations.
- Dry execution (`xargs -a manifest.paths ls -d`) reviewed by operator before commit.

## 4. Evidence Hash Pinning (current)

To be extended at apply time with the full-tree snapshot:

```
ops/evidence/p37-workflow-export/wazuh-flow-classb-to-iris.json
ops/evidence/p37-workflow-export/wazuh-high-severity-to-iris.json
ops/evidence/p38-workflow-export/<4 exports + SHA256SUMS.txt>   # see phase38-74 §5
```

## 5. Verdict

Current state verified PASS. Post-migration checklist frozen and READY-TO-RUN; it becomes the
gate that phase38-69 §4 must satisfy before the single migration commit.
