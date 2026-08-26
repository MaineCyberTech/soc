# Phase 38 Backlink Map

**Report ID:** phase38-63-backlink-map
**Phase:** 38
**Title:** Phase 38 Backlink Map — Dependency Edges, Orphan Candidates
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:13:00Z
**Classification:** INTERNAL
**Status:** PARTIAL
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-63-backlink-map.md`
**Retention Class:** canonical-current

---

## 1. Purpose

Record the known dependency graph over the corpus using four edge types, and enumerate orphan candidates. Status is PARTIAL: full edge extraction across ~1,900 files executes with the Phase D index build; this document pins the verified core edges and orphan candidates found during Phase 38 scans.

## 2. Edge Types

| Edge | Meaning |
|---|---|
| SUPERSEDES | A replaces B as truth for a domain (directional) |
| FEEDS | A supplies data/rows consumed by B |
| VERIFIES | A contains verification evidence for claims in B |
| REFERENCES-EVIDENCE | A points at a hash-pinned artifact in ops/evidence |

## 3. Core Edges

| Source | Edge | Target |
|---|---|---|
| current/49-current-state (reserved) | FEEDS | current/92-scorecard |
| current/49-current-state (reserved) | FEEDS | current/91-billing |
| current/49-current-state (reserved) | FEEDS | current/93-monthly |
| final-phase36-operator-report* | SUPERSEDES-CHAIN→ | current/49-current-state (inverse: superseded_by) |
| final-phase37-operator-report | SUPERSEDED-BY (truth scope) | current/49-current-state |
| ledgers/50..53 (claims/actions/verification/metrics) | FEEDS-FROM | phases/phaseNN scan reports 31–42 (contradiction/stale/unverified/missing/incomplete/duplicate/status/date/metric/security scans) |
| phases/phase31..42-era scan outputs | FEEDS | ledgers rows (each finding becomes ledger entries) |
| migration docs 59,67,68,69,70 | REFERENCES | schemas source: phase38-07-report-schema (schema id 07) |
| phase38-60-canonical-index | FEEDS | reports/INDEX.md (at apply) |
| generated/catalog-reports.json | VERIFIES | every generated/phase38-*.md (hash pinning) |
| ops/evidence/p37-workflow-export/*.json | REFERENCES-EVIDENCE (from) | phases/phase37/* workflow reports; final-phase37-operator-report |
| phase38-92-scorecard | FEEDS | client-safe/client-38-scorecard (future redaction) |
| phase38-95-release-assurance + phase38-21-release-claim-verification | FEEDS | releases/v1.0–v1.3 records |
| phase38-08-status-taxonomy | VERIFIES | status enums used corpus-wide (via report-ci 71) |

## 4. Orphan Candidates

### 4.1 Empty-stub files (0 bytes, nothing can reference content)

`phases/phase33/`: `phase33-61-.md`, `phase33-62-.md`, `phase33-63-.md`, `phase33-64-.md`, `phase33-65-.md`, `phase33-66-.md`, `phase33-67-.md`, `phase33-68-.md`

8 files. Disposition: review-required (phase38-58 §4.4), manual review 2026-09-01.

### 4.2 Pre-P13 stragglers

Numeric-prefixed legacy files outside the 13–37 main sequence:

- `01-preflight-20260810-060311.md` (no matching final-phase1 in finals set)
- `14-validation-20260810-062000.md`
- `15-memory-tuning-20260810-0645.md`, `15-vm103-provisioning-20260810-0650.md`, `15-misp-greenbone-deployment-20260810-0825.md`, `15-opencanary-rules-20260810-1825.md`, `15-alerting-shuffle-wiring-20260810-1935.md`, `15-shuffle-iris-wiring-20260810-2058.md`, `15-alert-routing-complete-20260810-2117.md`, `15-round3-complete-20260810-2155.md`, `15-services-deployed-20260810-1705.md`

11 files. These are early-corpus artifacts whose inbound links were never re-established after later rewrites. Disposition: keep, tag `orphan-candidate`, attempt inbound-link reconstruction during Phase D index build.

Orphan rule: a file is an orphan candidate iff (inbound edges == 0) ∧ (not AUTHORITATIVE-CURRENT) ∧ (not PHASE-FINAL). Finals/current docs are exempt by definition.

## 5. Machine Processing

At Phase D, edges above become `generated/backlinks.json` (`{src, edge, dst, evidence_ref?}`); CI check: no FEEDS edge pointing at a PENDING reserved slot in INDEX without an interim-truth annotation.
