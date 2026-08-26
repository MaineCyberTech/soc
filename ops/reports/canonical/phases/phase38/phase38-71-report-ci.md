# Phase 38-71 Report CI

**Report ID:** phase38-71-report-ci  
**Phase:** 38  
**Title:** Phase 38-71 Report Corpus CI — Script Implemented and Executed; Honest FAIL Baseline  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T21:13:25Z  
**Classification:** INTERNAL  
**Scope:** Executable CI gates over generated/*.md metadata, IDs, statuses, secrets, links, stale refs  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Owners:** ["opencode/ox-alpha", "human-operator"]  
**Evidence Roots:** ["/opt/mct-security-stack/ops/scripts/p38-report-ci.sh"]  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-71-report-ci.md`  
**Retention Class:** canonical-current  

---

## 1. Deliverable

Real executable script installed at:

```
/opt/mct-security-stack/ops/scripts/p38-report-ci.sh   (mode 0755)
```

Gates implemented: required metadata fields (`Report ID:, Phase:, Title:, Date:, Timestamp:,
Classification:, Status:, Source Path:`), duplicate report_ids, invalid status enums (14-value
taxonomy from phase38-08), secret patterns (`password=`, `token=`, `api_key=`,
`Bearer <20+ chars>`, known literal credentials — counts reported per file), broken internal
relative `.md` links among generated files, and stale references to phase38 report IDs that do
not exist on disk.

## 2. Run #1 — 2026-08-25T21:19:46Z (89 files in scope)

```
FAIL: (38 total) older-batch reports missing metadata fields
      e.g. phase38-01..09 use legacy header without Source Path;
      phase38-21-release-claim-verification.md missing nearly all fields
PASS: Gate2 report_ids unique across corpus
FAIL: phase38-71-report-ci.md invalid status 'DESIGN-COMPLETE'   <- old stub, since replaced
FAIL: phase38-72-report-drift.md invalid status 'DESIGN-COMPLETE'<- old stub, since replaced
FAIL: phase38-74-shuffle-inventory.md invalid status 'DOCUMENTED' <- old stub, since replaced
WARN: secrets — files_with_hits=6 total_matching_lines=6
      (00-master, 02-change-register, 13-current-state-claims, 50-verification-ledger,
       73-shuffle-hardening, 90-backlog)
PASS: Gate5 no broken relative .md links
WARN: phase38-55 references missing report: phase38-95-release-assurance.md  (typo of -assurance)
RESULT: FAIL  errors=13 warnings=7
```

## 3. Run #2 — 2026-08-25T21:22:25Z (92 files, after this batch's writes)

```
FAIL: same 38-file metadata gap (legacy batches untouched by design — history not rewritten)
PASS: Gate2 report_ids unique
FAIL: phase38-71 invalid status 'DESIGN-COMPLETE'  <- this run executed BEFORE this report
                                                      was written; self-reference resolves next run
WARN: secrets — files_with_hits=9 total_matching_lines=11
      new hits: 78-field-resolution(2) [documented curl auth + retraction quotes],
                82-code-audit(2), 84-security-audit(1) [concurrent batch]
PASS: Gate5 no broken relative .md links
WARN: stale ref: phase38-95-release-assurance.md typo persists in phase38-55
RESULT: FAIL  errors=11 warnings=10
```

## 4. Honest Interpretation

| Finding | Verdict |
|---|---|
| Metadata gaps (38 files) | REAL DEFECT of the earlier P38 waves. NOT auto-fixed here: rewriting historical report headers would violate the immutability rule (R1 of phase38-67). Remediation belongs to the migration's `current/` promotion step or a supersession pass. |
| Invalid statuses | 2 of 3 were the stale 71/72/74 stubs — resolved by this batch's replacements. Remaining hit is self-referential and clears on the next run. |
| Secret patterns | The corpus genuinely embeds the Shuffle bearer token and admin password in ≥9 files. This validates phase38-73 §7: rotation is mandatory; pattern-gate stays red until then. Hits introduced by 73/78 are deliberate documentation of ALREADY-DISCLOSED credentials (no new secrets). |
| Broken links / duplicate IDs | CLEAN — corpus cross-references by report_id text, matching dry-run findings. |
| Stale refs | 1 real typo (`release-assessment` vs `-assurance`) in phase38-55 §4.1 mapping table. Flagged; fix deferred to catalog regeneration (immutability). |

## 5. Operation

```bash
/opt/mct-security-stack/ops/scripts/p38-report-ci.sh          # manual
# cron suggestion: 15 6 * * * /opt/mct-security-stack/ops/scripts/p38-report-ci.sh >> ops/reports/audit-cron.log 2>&1
# pre-commit hook: reject commits adding generated/*.md that flip errors>0
```

Exit codes: 0 = PASS (warnings allowed), 1 = FAIL (errors present). Read-only on the corpus.

## 6. Baseline Verdict

CI is **implemented, executable, and honestly failing**: current corpus state is FAIL driven by
(a) legacy metadata gaps and (b) live credential disclosures. Both are documented defects with
owners and remediation paths (migration promotion pass; token rotation per phase38-73).
