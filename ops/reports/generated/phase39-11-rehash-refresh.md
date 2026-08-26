# Phase 39 Rehash and Catalog Refresh

**Report ID:** phase39-11-rehash-refresh  
**Phase:** 39  
**Title:** Rehash Record — sha256 Recomputation for Sanitized Artifacts, Catalog Row Bumps, Export SUMS Refresh  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T22:34:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-11-rehash-refresh.md`  

---

## 1. Why Rehash

Redaction (RED-39-01..N) mutated tracked artifacts. Any downstream integrity reference
that pinned their pre-redaction digests became stale. This report recomputes REAL
sha256 digests for every sanitized artifact, updates the report catalog rows that pin
them, and refreshes the export checksum manifest.

## 2. Recomputed Digests — Sanitized Artifacts (ACTUAL outputs)

```
$ sha256sum <sanitized files>
94f2d9a2d0578e1f9aa04faf539b5ad005fa0dab2578eda8a93770fde2b8cb86  ops/evidence/p37-workflow-export/wazuh-flow-classb-to-iris.json
5cde4879321a8425df2b05c90910b3ceb33de8663f28294c8e98b15f0db2356f  ops/evidence/p38-workflow-export/e951db98-9a57-4328-8344-09f8b5b9a69f.json
d1132a52bdf53d5c2954858ed654c7c6e285f17de462b7e959400027c9befd21  ops/evidence/p38-workflow-export/executions-flow-classb.json
296d12cddc67d54923a87820fd97e6081fde966a704b163400bd766d094ecb25  ops/reports/generated/../..-high-severity.json  (executions-high-severity.json)
26b5960fe1ee17a63796699727351394f0b101fbd0734aaa61ef216743115c93  ops/reports/generated/phase38-74-shuffle-inventory.md
73d920178165bc819ed012b5a2194c08443d2f95507c75a5481c5df7ccd58c62  ops/reports/ingest-pipeline-inventory-20260816-081826.md
e301fa4e29dba7651cdde41e1ab0d8e2858cf14a0ac55a1bcff60ee590b26398  ops/reports/phase36-10-shuffle-workflow-status.md
bbaca3dd6d0e8deb8733332a44b5c0de566e2a5fe8316035aff089bbbfc57bb4  ops/reports/phase36-11-shuffle-auth-failure.md
7a6d2a1bab0a792d53c8f251779ef9133d446379fa0d158f044e12e0ef7faf1e  ops/reports/phase36-12-shuffle-create-test-manifest.md
```

Full before/after ledger including `.gitignore`, compose file, catalog files, and the
SUMS manifest itself is in phase39-09 §5 (single authoritative ledger; not duplicated).

## 3. Catalog Refresh — EXECUTED (JSON + CSV)

The generated-corpus catalog pins a `sha256` per report row. The row for the redacted
generated report was stale:

```
report_id: phase38-74-shuffle-inventory
old sha256: a2457add0284fb0b214513b64d011df9d3a4c8d311f72f84ef1fea9fbcef20c8   ← pre-redaction
new sha256: 26b5960fe1ee17a63796699727351394f0b101fbd0734aaa61ef216743115c93   ← post-redaction (verified live)
```

Actions performed this session:

1. Read `catalog-reports.json` → located row by `report_id`.
2. Updated `sha256` field → wrote back with indent=2 formatting preserved.
3. Parsed same update into `catalog-reports.csv` (column 8) via csv reader/writer.
4. Validated: `python3 -c "import json; json.load(...)"` → **catalog JSON valid**.

Resulting catalog file digests (for the next rehash cycle):

| File | BEFORE | AFTER |
|---|---|---|
| `catalog-reports.json` | cc053a6f150bd603131528a0a755263c1bb14fa14794ad260dff497bc5949e82 | 3570442f9cb2c40c82e11292de0c649ca7f3f1a6d734588c9ec7b384d5cb071b |
| `catalog-reports.csv` | ead55b08066ec91861c2d827437b0cb500fd086f212ac51a2d3f938a3abb05bd | d1c3952c3e612f65354f974793c324c7436e38c99187201cdb31ae2c1d6d54dc |

Note: phase39 reports themselves are NOT yet in the catalog; ingestion of the
phase39 corpus into catalog rows is a Phase 40 task alongside CI scope widening.

## 4. Evidence Manifest Refresh — EXECUTED

`ops/evidence/p38-workflow-export/SHA256SUMS.txt` pinned pre-redaction digests for
three of its four covered files. Regenerated in place:

```
$ cd ops/evidence/p38-workflow-export && sha256sum … > SHA256SUMS.txt && cat SHA256SUMS.txt
5cde4879321a8425df2b05c90910b3ceb33de8663f28294c8e98b15f0db2356f  e951db98-9a57-4328-8344-09f8b5b9a69f.json
4389a64d34428982de203acfe7cbc491adaa7dc2f9d7e96e2e80f84cde0ba0d8  eb937a37-5244-46dc-95ff-62ad4c681322.json
d1132a52bdf53d5c2954858ed654c7c6e285f17de462b7e959400027c9befd21  executions-flow-classb.json
296d12cddc67d54923a87820fd97e6081fde966a704b163400bd766d094ecb25  executions-high-severity.json
```

(`eb937a37…` unchanged by redaction — its digest matches its prior pinned value,
serving as an internal control.) New manifest digest:
`e5c5f1261db0724bd556df47b3ddf6fdd0b5e310997f3f031ae81c436d45d1b4`
(prior: `293ada50d9507185b489a648d59fd20b6f8112ef795acb49aafc728f3532f258`).

## 5. Relationships Changed

| Relationship | Change | Downstream effect |
|---|---|---|
| catalog row ↔ phase38-74 file digest | bumped to post-redaction value | future integrity checks pass |
| SHA256SUMS.txt ↔ 3 export JSONs | regenerated | evidence chain internally consistent again |
| evidence exports ↔ live workflow params | exports now placeholder-form; live params hold real values (by design) | exports remain safe-to-share; live system functional (REA-39-01 PASS) |
| reports referencing old bearer | now placeholders | Gate4 secret scan zero-hit maintained |
| .gitignore ↔ config/shuffle-api-key | new ignore rule added | key file uncommitable |

## 6. Method Note

All hashes in this report are verbatim command output from this session (no recall,
no transcription). BEFORE-side digests were computed from git object storage at HEAD
`04e689d` (`git show HEAD:<path> | sha256sum`), so the ledger documents exactly the
committed→working-tree delta introduced by the remediation changeset.

## 8. Catalog Refresh Procedure (scriptable form used)

```
1. python3: load catalog-reports.json
2. locate row where report_id == "<id>"
3. row['sha256'] = sha256sum(<file>)          # freshly computed, never recalled
4. json.dump(indent=2)                        # preserve human-diffable formatting
5. csv: rewrite column 8 for matching report_id via csv reader/writer round-trip
6. validate: json.load() succeeds             # parse gate before declaring done
```

Steps 1–6 were executed exactly this session; outputs quoted in §3. The procedure is
deliberately boring and idempotent — safe to re-run after any future redaction wave.

## 9. Integrity Chain State After Refresh

| Link | Status |
|---|---|
| sanitized generated report ↔ catalog JSON row | CONSISTENT (bumped) |
| same ↔ catalog CSV row | CONSISTENT (bumped) |
| export JSONs ↔ SHA256SUMS.txt | CONSISTENT (regenerated; control file unchanged-digest verified) |
| phase39 reports ↔ catalog | NOT YET INGESTED (P40 task — stated, not hidden) |
| git HEAD ↔ working tree | intentionally dirty pending G12 commit |

## 10. Rollback of the Rehash Itself

If a catalog write had corrupted structure: restore from git HEAD version of the two
catalog files (`git checkout --`) and re-run §8 with corrected digest. Not needed —
parse gate passed first attempt; noted for completeness.

## Appendix A — Verification Verbatim (this session)

```
$ python3 -c "import json; json.load(open('ops/reports/generated/catalog-reports.json')); print('catalog JSON valid')"
catalog JSON valid

$ sha256sum ops/evidence/p38-workflow-export/SHA256SUMS.txt
e5c5f1261db0724bd556df47b3ddf6fdd0b5e310997f3f031ae81c436d45d1b4  ops/evidence/p38-workflow-export/SHA256SUMS.txt
```

## Appendix B — Control-File Continuity Check Detail

Within the regenerated SHA256SUMS.txt, `eb937a37…json` (untouched by redaction)
retained digest `4389a64d34428982de203acfe7cbc491adaa7dc2f9d7e96e2e80f84cde0ba0d8`,
identical to its pre-refresh pinned value. This is a deliberate internal control: it
proves the manifest regeneration process itself introduced no drift for unchanged
files — any future mismatch on an UNCHANGED file indicates tooling fault, not content
change.

## Appendix C — Downstream Consumers of These Digests

| Consumer | Uses | Impact of this refresh |
|---|---|---|
| Future integrity audits (P40+) | catalog sha256 vs on-disk | will now PASS for phase38-74 |
| Evidence chain reviews | SHA256SUMS.txt | internally consistent again |
| Release packaging | file digests at ship time | unaffected until next bundle (will inherit current values) |
| This phase's own ledger | §2 outputs | authoritative record of post-redaction state |

## 11. Verdict

**COMPLETE.** Sanitized artifacts rehashed with real outputs; catalog JSON+CSV row
bumped and validated; export manifest regenerated with control-file continuity check;
relationship deltas enumerated.
