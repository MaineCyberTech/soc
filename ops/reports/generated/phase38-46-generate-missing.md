# Phase 38 Missing / Broken Artifacts Register

**Report ID:** phase38-46-generate-missing
**Phase:** 38
**Title:** Missing, Broken, or Inaccessible Artifacts — Impact, Recovery, Certification Blocking
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-46-generate-missing.md`
**Retention Class:** LONG
**Supersedes:** prior draft of this report ID and `phase38-34-missing-artifact-scan.md` candidate set
**Owners:** ["ops-reports-owner", artifact-specific owners per record]

---

## 1. Conventions

Each record: ID, artifact, state, impact, recovery options, and whether it **blocks certification** (of deployability, release assurance, or client-readiness narratives). Blocks flags: **CERT-BLOCK** (must fix before any certification claim), **CERT-QUALIFY** (certification may proceed only with explicit caveat), or **NON-BLOCK**.

---

## 2. Records

### MIS-38-01 — Final operator report, Phase 1 — ABSENT

| Field | Content |
|---|---|
| State | No `final-phase1-operator-report-*` (or equivalent canonical final) exists anywhere in scope |
| Impact | Phase 1 closure cannot be evidenced; certification trail starts effectively at Phase 2 |
| Recovery | Author retrospective final from phase-1 artifacts + git history, clearly marked retrospective |
| Blocks | CERT-QUALIFY (historical completeness only) |

### MIS-38-02 — Final operator report, Phase 36 — ABSENT (canonical)

| Field | Content |
|---|---|
| State | `phase36-75-final-report.md` exists but is summary-style, contains two claims since contradicted (~7.9GB relief; field-fix efficacy), and does not follow the canonical final naming/content standard |
| Impact | The most consequential remediation week lacks a trustworthy closing document; its final propagates a misattributed fix |
| Recovery | Author phase36 final addendum referencing phase38-44 CON-38-01/06 corrections rather than editing the original |
| Blocks | CERT-QUALIFY |

### MIS-38-03 — Dashboard JSONs W1/W2 — NEVER BUILT

| Field | Content |
|---|---|
| State | Dashboard work-streams W1/W2 (packet-routing card, trend panels) referenced across phases 32–37 reports; no dashboard JSON export exists under `ops/dashboards/` or evidence roots |
| Impact | Dashboard deliverables are narrative-only; cannot be imported/rebuilt deterministically |
| Recovery | Build + export JSONs from OpenSearch Dashboards; commit under `ops/dashboards/` with sha256 sidecars |
| Blocks | CERT-QUALIFY for reporting workstream |

### MIS-38-04 — v1.3.0 release asset not persisted on-box

| Field | Content |
|---|---|
| State | Asset sha256 `da72bde4…` matched byte-exact during in-session fetch, but no copy archived under `/opt/mct-security-stack/ops/evidence/` (or anywhere durable); `gh` CLI absent limits re-fetch |
| Impact | Provenance integrity VERIFIED but availability PARTIAL; future audits cannot independently re-verify without network + GitHub access |
| Recovery | Download once, store at `ops/evidence/releases/v1.3.0/<asset>` + `<asset>.sha256`; mirror same pattern forward for releases |
| Blocks | CERT-BLOCK for release-assurance claims that assert reproducible provenance |

### MIS-38-05 — Approval records absent (multiple decisions)

| Field | Content |
|---|---|
| State | No signed approval records exist for: SO packet-scanning retirement (P31), production-routing deferrals (P33–P35 chain), Shuffle frontend exposure change implied by "(was 127.0.0.1)" (`phase36-75-final-report.md:21`), export/versioning conventions. Canary SID 2027967 approval DOES exist (`phase34-08-canary-approval.md`) — it is the exception proving the standard |
| Impact | Governance narrative rests on commit messages and report prose instead of approval artifacts; exposure change in particular has **no authorizing record at all** |
| Recovery | Ratify retroactively: decision ledger entries (phase38-52) + operator sign-off file per decision under `ops/checklists/approvals/` |
| Blocks | CERT-BLOCK for governance/security sections |

### MIS-38-06 — Export hash references pointing to absent files

| Field | Content |
|---|---|
| State | Reports cite workflow-export SHA256 values whose standalone `.sha256` sidecar files are absent; the hashes survive only as trailing HTML comments inside the exports themselves (`<!-- SHA256: … -->`), which also makes the JSON files fail strict parsers (trailing-comment defect) |
| Impact | Hash chain is unverifiable from files alone; automated ingestion of exports breaks |
| Recovery | Re-export cleanly (valid JSON), write `<file>.json` + `<file>.json.sha256`, mark old exports superseded-but-retained |
| Blocks | CERT-QUALIFY |

### MIS-38-07 — Snapshot repository unregistered

| Field | Content |
|---|---|
| State | `_snapshot/*` returns `repository_missing_exception` cluster-wide (`phase38-26-retention-claim-verification.md:18,78-80`); nightly `elastic-snapshot.sh` cron has no working destination via cluster API |
| Impact | Retention/restore narratives that assume snapshot-backed recovery are unsupported; full-cluster restore NO-GO is reinforced |
| Recovery | Register fs/S3 repository, take + restore a canary snapshot, record drill evidence |
| Blocks | CERT-BLOCK for DR/restore claims |

### MIS-38-08 — RTO/RPO targets absent from deployability certification

| Field | Content |
|---|---|
| State | `phase37-78-deployability.md` certifies PARTIAL with restore NO-GO but defines no Recovery Time Objective or Recovery Point Objective; corpus scan of phases 37–78 finds none |
| Impact | "How long to recover / how much data loss" is unanswerable; deployability status is unanchored |
| Recovery | Author RTO/RPO targets, map to current capability gap, fold into REM-38-11 |
| Blocks | CERT-BLOCK for deployability section |

### MIS-38-09 — `gh` CLI absent on-box

| Field | Content |
|---|---|
| State | Tooling gap: release-object verification, issue/PR automation impossible locally |
| Impact | Forced manual/network workarounds; contributed to MIS-38-04 persistence gap |
| Recovery | Install gh; authenticate with least-privilege token stored in `creds.env` pattern (env-abstraction per P22 practice) |
| Blocks | NON-BLOCK |

### MIS-38-10 — Exec-mode audit timed out (incomplete artifact)

| Field | Content |
|---|---|
| State | Exec-mode/exec-bit CI audit did not complete this session (timeout); partial output only |
| Impact | Exec-bit posture across `ops/scripts/` partially unverified this cycle; prior pass (P28 exec-bit incident closure, git 21ba3d1) is the latest complete evidence |
| Recovery | Re-run with narrowed scope/chunking; see REM-38-09 |
| Blocks | NON-BLOCK (prior complete audit stands; this cycle marked PARTIAL) |

---

## 3. Roll-up

| Blocks level | Count | IDs |
|---|---|---|
| CERT-BLOCK | 3 | MIS-38-04, MIS-38-05, MIS-38-07 (+MIS-38-08 for deployability specifically) |
| CERT-QUALIFY | 3 | MIS-38-01, MIS-38-02, MIS-38-03, MIS-38-06 |
| NON-BLOCK | 2 | MIS-38-09, MIS-38-10 |

**Certification statement required until cleared:** "Release/deployability assurance is qualified by missing approval records, unarchived release asset, unregistered snapshot repository, and undefined RTO/RPO."

## 4. Cross-references

Remediation owners/steps: `phase38-54-generate-remediation.md`. Open-work tracking: `phase38-47-generate-openwork.md`. Evidence classification context: `phase38-53-generate-evidence-ledger.md`.
