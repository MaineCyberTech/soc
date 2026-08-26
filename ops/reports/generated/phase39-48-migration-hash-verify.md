# Phase 39 Migration Hash Verification

**Report ID:** phase39-48-migration-hash-verify
**Phase:** 39
**Title:** Phase 39-48 Full Hash Verification — All Rows, Source and Destination, vs Frozen Manifest
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:40:00Z
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-48-migration-hash-verify.md`

---

## 1. Method

NOT a sample. A single pass over every manifest row compared three digests:

```
sha256(source) == row.sha256_source   AND   sha256(dest) == row.sha256_source
```

Driver: `/tmp/opencode/p39/fullverify.py` (streams 1 MiB chunks; no file modified).

## 2. Totals

| Metric | Value |
|---|---|
| Manifest rows | 1,992 |
| **Verified (both sides equal manifest hash)** | **1,992** |
| Mismatch | **0** |
| Skipped-with-reason | **0** |

Raw output:

```
rows=1992 verified_all_three_equal=1992 mismatch_or_missing=0 skipped=0
```

Combined with the per-row verify at apply time (phase39-45), every copy has now been independently
hash-confirmed twice post-copy.

## 3. Sanitized-Derivative Hashes vs Protected Originals

Seven manifest sources are files redacted during THIS phase (phase39-09/11): their working-tree
bytes — and therefore their `sha256_source` in the frozen manifest — legitimately differ from git
HEAD. These are sanitized derivatives; the pre-redaction originals remain protected and recoverable
in git history (`git show HEAD:<path>`):

| Source (HEAD-differs) | Reason |
|---|---|
| `ops/reports/generated/catalog-reports.json` / `.csv` | P39 catalog maintenance + redaction re-hash refresh |
| `ops/reports/generated/phase38-74-shuffle-inventory.md` | stCG-/old-token redaction |
| `ops/reports/ingest-pipeline-inventory-20260816-081826.md` | secret location redaction |
| `ops/reports/phase36-10-shuffle-workflow-status.md` | secret location redaction |
| `ops/reports/phase36-11-shuffle-auth-failure.md` | secret location redaction |
| `ops/reports/phase36-12-shuffle-create-test-manifest.md` | secret location redaction |

All other 1,985 sources hash-match their git-tracked state exactly (no drift of any kind was
introduced by migration tooling). The canonical copies preserve the CURRENT (sanitized) bytes by
design; redaction correctness itself was gated at phase39-43 G1.

## 4. Verdict

**PASS** — corpus integrity fully proven: N=1992 verified, M=0 mismatch, K=0 skipped.
