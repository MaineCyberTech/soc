# Phase 41 Asset Custody Decision — DEC-CUSTODY-41-01

**Report ID:** phase41-76-asset-custody-decision
**Phase:** 41
**Title:** DECISION-DEC-CUSTODY-41-01 — Release Custody CLOSED-VERIFIED: Byte-Exact Published Original On-Box Supersedes Rebuilt-As-Primary, Rebuilt Retained As Provenance-Comparison Artifact, MANIFEST.md Updated With Original-Asset Row, Backup-Inclusion Gap Flagged For Owner Backup Policy
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:52:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-76-asset-custody-decision.md`

---

## 1. Decision

| Field | Value |
|---|---|
| Decision ID | **DEC-CUSTODY-41-01** |
| Decision | **CLOSED-VERIFIED** — the v1.3.0 published-asset custody gap (open since P38, blocker BCK-40-007) is formally closed with byte-exact on-box evidence |
| Basis | phase41-75 retrieval record: sha256 `da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c` matches the P36-published identity exactly; size corroborated at 10,348,557 bytes against the API-reported asset size |

## 2. Supersession statement

- The rebuilt archive (`v1.3.0-rebuilt-from-tag.tar.gz`, sha256 `65f794a7…`)
  is **superseded as primary custody artifact** by the retrieved published
  original.
- The rebuilt variant is **retained, not deleted**, as a provenance-comparison
  artifact: it demonstrates tag-content equivalence independent of gzip stream
  nondeterminism, which remains useful reference material for future
  reproducibility discussions.
- All future references to "the v1.3.0 release artifact" MUST mean the
  published original unless explicitly labeled otherwise.

## 3. MANIFEST update — EXECUTED this batch (VERIFIED)

`ops/releases/v1.3.0/MANIFEST.md` updated in place as a living manifest:

- Title generalized from "(REBUILT)" to cover both retained artifacts.
- New section 1 added carrying the published-original row: asset filename,
  size, full sha256, discovery/retrieval URLs, retrieval timestamp
  (2026-08-26T04:39:08Z), retrieval method (unauthenticated GitHub REST API →
  direct download → hash verification PASS).
- Rebuilt entry relabeled provenance-comparison-only; its historical
  DIFFERENCE-FROM-PUBLISHED warning preserved verbatim with a dated resolution
  note appended.
- Custody note added documenting the gitignore consequence (below).

## 4. Backup-inclusion note (flagged, not resolved here)

Because `*.tar.gz` is gitignored by design, the only copy of the verified
published original lives **on this box**. Hashes travel in git via MANIFEST.md,
but bytes do not. Host-backup coverage for `ops/releases/` therefore remains a
**flagged gap in the owner backup policy** — inclusion of `ops/releases/**`
(non-gitignored portions plus a backup-policy decision on the archives
themselves) belongs to the owner's backup policy review. Agents do not modify
backup scope unilaterally.

## 5. Residuals

None for v1.3.0 custody. The pattern established here (REST-API retrieval →
hash match → MANIFEST row) is reusable verbatim for the v1.3.1 flow
(phase41-79 step 6).
