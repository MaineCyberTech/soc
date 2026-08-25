# Phase 38 Repo Assessment — Gates, Classification, Commit Status

**Report ID:** phase38-96-repo
**Phase:** 38
**Title:** Phase 38 Repo Assessment — Gates, Classification, Commit Status
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-96-repo.md`

**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-96-repo.md`
**Retention Class:** LONG

| Field | Value |
|-------|-------|
| **Report ID** | phase38-96 |
| **Generated** | 2026-08-25 21:30 UTC |
| **Classification** | Internal / Release engineering |
| **Owner** | MCT SOC — release engineering |
| **Status** | **COMMIT-PENDING-APPROVAL** (no state-modifying git commands executed) |
| **Supersedes** | Draft written 2026-08-25T20:13Z |

---

## 1. Git State (read-only inspection)

| Field | Value |
|-------|-------|
| HEAD | `7bd3b82` — "Phase 37: 82 reports, workflow exports, Shuffle hardening plan, field resolution design" |
| Branch | main |
| Tracked-tree cleanliness | CLEAN at HEAD (zero modified tracked files) |
| Untracked payload | 4 top-level entries (below) |

```
?? ops/evidence/p38-workflow-export/        # workflow defs + execution exports + SHA256SUMS.txt
?? ops/reports/generated/                   # phase38 corpus: 108 files incl. catalogs + templates/
?? ops/reports/full-stack-health-20260825-202718.md
?? ops/scripts/p38-report-ci.sh
```

Recent history context (last five): Phase 37 → P36 update → P36 → P35 canary E2E → P34 agent forwarding. The untracked set is exactly the Phase 38 deliverable; nothing else in the tree moved.

Payload size: generated corpus ~1.1 MB (108 files), evidence exports ~1.5 MB (5 files). `.gitignore` verified non-conflicting — none of the payload paths match ignore rules (`check-ignore` exit 1 on samples).

## 2. Gates Run Before Commit Planning

| Gate | Result | Disposition |
|------|--------|-------------|
| Report-CI truthfulness gate (`ops/scripts/p38-report-ci.sh`, mode 0755) | **FAIL-honest** — by design: secret patterns match known credential locations in historical reports | Documented here as the correct signal; NOT suppressed. Gate goes GREEN only after BCK-38-002 redaction + re-hash |
| Secret pattern scan | 3 locations flagged: `generated/phase38-00-master.md:63`, `generated/phase38-01-preflight.md:131`, `generated/phase38-73-shuffle-hardening.md §Step1` | Values referenced by location only everywhere in this report; rotation prerequisite tracked as BCK-38-001 |
| Ignore-rule conformance | PASS — no payload path ignored or ignorable-by-pattern | None needed |
| Hash integrity of evidence | PASS — SHA256SUMS.txt covers all 4 export artifacts | Verified this phase |

## 3. Classification

| Plane | Content | Handling |
|-------|---------|----------|
| Source | `ops/scripts/p38-report-ci.sh` (+ index template definition living in cluster state, exported text inside report 78) | First-class repo source; versioned |
| Evidence | `ops/evidence/p38-workflow-export/*` (workflow JSONs, execution exports, SHA256SUMS) | Immutable evidence store; commit as-is with checksums |
| Reports | `ops/reports/generated/phase38-*` (98 numbered reports + catalogs + templates/) | Generated corpus; commit per standing practice from prior phases (P35–P37 committed their corpora) |
| Transient | `ops/reports/full-stack-health-20260825-202718.md` | Point-in-time health snapshot; include for provenance (prior full-stack-health snapshots follow same pattern) |

## 4. Planned Commit Structure

**Single logical commit** upon approval:

- Title pattern: `Phase 38: field-error root cause fixed (archives template), routing truth corrected, snapshot repos verified, corpus audited+cataloged, CI gate added (reports 00–97)`
- Contents (pathspec-scoped add):
  - `ops/scripts/p38-report-ci.sh`
  - `ops/evidence/p38-workflow-export/`
  - `ops/reports/generated/` (includes `catalog-reports.json/.csv`, `templates/*.tmpl`)
  - `ops/reports/full-stack-health-20260825-202718.md`
  - `ops/reports/current/final-phase38-operator-report-20260825-2130Z.md` (final operator summary)
- Template artifact note in body: 9 `.md.tmpl` files are the canonical report templates ratified by phase38-65; future reports should instantiate them.
- No force flags; no history rewrite; hooks run as configured.

## 5. Preconditions and Clean-Tree Requirement

Standing policy requires the working tree be fully reconciled by any commit (clean-tree rule). Current untracked set IS the payload, so reconciliation = inclusion, with ONE hard precondition:

> **Secret-gate precondition:** the three flagged credential locations must either be (a) redacted before the commit lands — preferred, since it keeps secrets out of git history entirely — or (b) explicitly accepted-and-waived in writing by the approver with the files still excluded via pathspec. Default plan is (a): sequence rotate (BCK-38-001) → redact (BCK-38-002) → re-hash → rerun CI to GREEN → then commit.

Committing first and redacting later would embed secrets permanently in history; that path is rejected by policy even though push is gated.

## 6. Push Status

**APPROVAL-GATED** per standing policy (consistent with P34–P37 handling). Push executes only after: operator approval recorded in the decision ledger, preconditions §5 met, and post-commit CI rerun green. No remote operations performed in this session.

## 7. What Was Deliberately NOT Done

- No `git add`, no commit, no push, no stash, no branch creation, no config changes.
- No modification of the three credential-bearing files outside the redaction task's ownership (they remain byte-identical to their catalog sha256 until BCK-38-002 executes).
- No suppression or weakening of the FAIL-honest CI result.

## 8. Status Line for Final Operator Report

> Repo: COMMIT-PENDING-APPROVAL — tree clean at HEAD 7bd3b82 with the complete Phase 38 payload (scripts + evidence + 100+ report artifacts) staged-in-plan as one logical commit; secret-gate FAIL documented honestly; redaction-before-commit is the required order; push approval-gated per policy.
