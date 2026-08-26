# Phase 42 v1.3.1 Release Assurance — REL-ASR-42-01

**Report ID:** phase42-80-v131-assurance
**Phase:** 42
**Title:** Assurance Verdict ASSURED-ONBOX-PUBLICATION-PENDING: Remote Tag Visibility PROVEN (git ls-remote Exit 0, Object Identical To Local), Archive sha256 Recompute MATCH, Delta Completeness Cross-Reffed (phase41-77 D-1..D-10 ⊆ D-1..D-12 Register), Rollback Defined; Residual: Release-Page Visibility Pending Token
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:43:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-80-v131-assurance.md`

---

## 1. Verdict

**ASSURED-ONBOX-PUBLICATION-PENDING.** The v1.3.1 tag and on-box asset are
proven end-to-end (identity, integrity, completeness, rollback). The single
open residual — release-page + downloadable asset visibility — requires only
the owner token action documented in phase42-79 §6.

## 2. Checks executed this cycle (live)

### 2a. Tag remote visibility — VERIFIED

```
$ git ls-remote origin refs/tags/v1.3.1
71701dfd356549f1c5d2e13c9a24256afa3eac8b	refs/tags/v1.3.1
exit=0
```

Local identity check: `git rev-parse v1.3.1` →
`71701dfd356549f1c5d2e13c9a24256afa3eac8b` — **object identical local vs
origin**. The annotated tag points at commit
`657991943be97c4ffe1d0525b604bf09b5d6e6ba` (verified-tree lineage), tree
`114324d64d68b61bc091f2f66cb6005673c49bf8`. Remote visibility holds WITHOUT any
token (transport is the existing SSH origin).

### 2b. Local archive integrity — VERIFIED

| | |
|---|---|
| Manifest/on-box record | `4e6c3712ba88f5ab925a2049d5d214fb55222a602c79738028ffee9a23ebf596` |
| Recomputed now (`sha256sum`) | `4e6c3712ba88f5ab925a2049d5d214fb55222a602c79738028ffee9a23ebf596` |
| Result | **MATCH** (15,558,573 bytes; 5,263 entries) |

### 2c. Delta completeness cross-reference — VERIFIED

phase41-77 inventory rows **D-1..D-10 ⊆ D-register D-1..D-12** finalized in
phase41-98 §3 (D-11 watchdog, D-12 custody artifacts); the MANIFEST cites the
combined register and the tag message names "D-register phase41-77/phase42-77".
No registered delta is absent from the tag's stated scope; no unregistered
delta was smuggled in.

### 2d. Archive content hygiene spot-check — VERIFIED (names-only sweep)

Path-name pattern sweep over the tar listing (`env / secret / creds`): 37
matches are exclusively documentation, example templates
(`config/examples/secrets.example.env`), audit/checklist/runbook reports, and
scanner scripts — consistent with the repo's secrets-by-path convention. No
live `.env`, creds file, or credential store path present in the archive.

## 3. Rollback procedure (documented, not executed)

```bash
git push origin :refs/tags/v1.3.1   # delete remote tag
git tag -d v1.3.1                   # delete local tag
rm -rf ops/releases/v1.3.1/         # remove on-box asset + manifest
```

Impact: tag-scoped only — the underlying tree/commit history is untouched; no
runtime service consumes the tag. If a GitHub release page was later created,
delete it via API before/with the remote tag deletion.

## 4. Residuals

| # | Item | Owner |
|---|---|---|
| R1 | Release-page visibility + asset download pending GITHUB_TOKEN; exact call sequence in phase42-79 §6; verify published digest equals §2b hash after upload | MCT SOC (token holder) |

## 5. Chain of evidence

phase42-77 (readiness READY) → phase42-78 (cut decision DECISION-V131-42-01)
→ phase42-79 (execution REL-EXE-42-01) → this assurance REL-ASR-42-01.
Custody lineage precedent: CUSTODY-41-01 byte-exact standard (phase41-75/-76).
