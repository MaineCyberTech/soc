# Phase 38-72 Report Drift Check

**Report ID:** phase38-72-report-drift  
**Phase:** 38  
**Title:** Phase 38-72 Catalog-vs-Filesystem Drift — 16 Items Found Across Concurrent Batches  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T21:13:25Z  
**Classification:** INTERNAL  
**Scope:** Live comparison of catalogs/catalog-reports.json against the generated/ filesystem  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Owners:** ["opencode/ox-alpha", "human-operator"]  
**Evidence Roots:** ["/tmp/opencode/p38-drift-output.txt"]  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-72-report-drift.md`  
**Retention Class:** canonical-current  

---

## 1. Method

Actual comparison executed via python3 against the frozen machine catalog:

```python
cat=json.load(open("catalog-reports.json"))            # frozen 2026-08-25T21:02:29Z
on_disk ={f for f in os.listdir(".") if f.startswith("phase38-") and f.endswith(".md")}
cataloged={e["path"].split("/")[-1] for e in cat["reports"]}
# added = disk-catalog ; removed = catalog-disk
# hash mismatch = sha256(file) != e["sha256"]
```

Catalog baseline: **87 entries**, meta.generated_at **2026-08-25T21:02:29Z**.
Comparison executed at ~21:20Z.

## 2. Results (verbatim)

```
== DRIFT ITEMS ==
1) files on disk NOT in catalog (4):
   + phase38-54-generate-remediation.md
   + phase38-77-routing-decision.md
   + phase38-78-field-resolution.md
   + phase38-83-infra-audit.md
2) catalog entries with NO file on disk (0):
3) hash MISMATCHES (12):
   ~ phase38-67-link-rewrite-plan.md     cat: f03cdf1045c8 disk: 8e301af43bee
   ~ phase38-68-migration-dryrun.md      cat: d722cbd9e134 disk: a0433f6515db
   ~ phase38-69-migration-apply.md       cat: 389711dcdc24 disk: b3d62fb630ab
   ~ phase38-70-migration-verify.md      cat: 9f945bce4419 disk: 3b0dded33f7a
   ~ phase38-73-shuffle-hardening.md     cat: c159c64a4385 disk: 1f22e8c0dd45
   ~ phase38-74-shuffle-inventory.md     cat: a2457add0284 disk: 848eff8b9c96
   ~ phase38-75-packet-workflow.md       cat: 453bcdcc79f8 disk: 2117631eb6e4
   ~ phase38-76-packet-workflow-proof.md cat: 54a3a18a6b7d disk: cb6e08cf994e
   ~ phase38-79-retention-verification.md cat: 73144f30b369 disk: 57d1ac201e84
   ~ phase38-80-endpoint-status.md       cat: e49587f9953e disk: 9dd6f63989e7
   ~ phase38-81-tmp-validation.md        cat: 4c0b843353bf disk: 3097831e2c78
   ~ phase38-82-code-audit.md            cat: 70013b121d02 disk: 8a6f9caac2ad

TOTAL drift items: 16
```

## 3. Attribution of Drift Items

| Group | Files | Cause |
|---|---|---|
| Added-after-freeze (this batch) | 67–70, 73–76 rewrites; 77, 78 new | P38 second wave wrote corrected reports AFTER the 21:02:29Z catalog freeze — expected |
| Added-after-freeze (concurrent batch) | `phase38-54-generate-remediation.md`, `phase38-83-infra-audit.md` | Written by concurrent execution streams around/after freeze; 54 predates freeze by seconds and missed inclusion |
| Hash mismatches (concurrent batch, NOT written by this batch) | 79, 80, 81, 82 | Modified between catalog hashing and this check by another active batch |
| Hash mismatches (this batch) | 67–70, 73–76 | Deliberate content replacement (corrected live state); supersede the cataloged versions |
| Missing files | none | No deletions occurred |

## 4. Conclusions

1. Drift is REAL and material: **16 items (18% of catalog)** — consistent with concurrent write
   batches sharing one catalog without coordination.
2. The catalog must be treated as **STALE at freeze-time**, not authoritative-current, until
   regenerated under a lock after all P38 waves complete.
3. Recommended control: single-writer rule or catalog regeneration gated on a batch-complete
   marker; regenerate `catalog-reports.{json,csv}` in Phase 39 preflight.

## 5. Honesty Notes

- This report itself adds one more uncataloged file at publication time (self-inclusive recursion);
  the next regeneration resolves it.
- The frozen catalog JSON was intentionally NOT modified during this check — it is the evidence
  of the drift.
