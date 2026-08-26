# Phase 38 Canonical Index

**Report ID:** phase38-60-canonical-index
**Phase:** 38
**Title:** Phase 38 Canonical Index — Human-Readable INDEX.md Blueprint
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:10:00Z
**Classification:** INTERNAL
**Status:** PASS
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-60-canonical-index.md`
**Retention Class:** canonical-current

---

## 1. Purpose

Define the human-readable master index for the corpus. On migration apply (Phase D), the body below becomes `reports/INDEX.md`. Machine-readable counterpart: `generated/catalog-reports.json` (phase38-61).

Table format everywhere: **path | title | status | authority | date**.

## 2. CURRENT STATE

| Path | Title | Status | Authority | Date |
|---|---|---|---|---|
| current/49-current-state.md | Current System State | PENDING | AUTHORITATIVE-CURRENT | — (slot reserved; interim truth: final-phase37-operator-report) |
| current/90-backlog.md | Open Backlog | PASS | AUTHORITATIVE-CURRENT | 2026-08-25 |
| current/91-billing.md | Billing Summary | PASS | AUTHORITATIVE-CURRENT | 2026-08-25 |
| current/92-scorecard.md | Scorecard (Internal + Client-Safe Metrics) | PASS | AUTHORITATIVE-CURRENT | 2026-08-25 |
| current/93-monthly.md | Monthly Summary | PASS | AUTHORITATIVE-CURRENT | 2026-08-25 |
| current/94-deployability.md | Deployability Assessment | PASS | AUTHORITATIVE-CURRENT | 2026-08-25 |
| current/95-release-assurance.md | Release Assurance | PASS | AUTHORITATIVE-CURRENT | 2026-08-25 |
| current/96-repo.md | Repository State | PASS | AUTHORITATIVE-CURRENT | 2026-08-25 |

## 3. BY PHASE (13–37)

| Path | Title | Status | Authority | Date |
|---|---|---|---|---|
| phases/phase13/final-phase13-operator-report-20260816-040452.md | Phase 13 Final Operator Report | RETIRED | PHASE-FINAL | 2026-08-16 |
| phases/phase15/15-shuffle-iris-wiring-20260810-2058.md | Shuffle ↔ IRIS Wiring | STALE | PHASE-FINAL | 2026-08-10 |
| phases/phase22/final-phase22-operator-report-20260822-034811.md | Phase 22 Final Operator Report | RETIRED | PHASE-FINAL | 2026-08-22 |
| phases/phase31v2/final-phase31v2-operator-report-20260824-235617Z.md | Phase 31v2 Final Operator Report | RETIRED | PHASE-FINAL | 2026-08-24 |
| phases/phase36/final-phase36-*-operator-report-*.md | Phase 36 Final Operator Report | SUPERSEDED | PHASE-FINAL (truth → 49-current-state) | 2026-08-25 |
| phases/phase37/final-phase37-operator-report-20260825-1943Z.md | Phase 37 Final Operator Report | RETIRED | PHASE-FINAL | 2026-08-25 |

(Full per-phase listing generated mechanically into INDEX.md at Phase D; representative rows shown.)

## 4. AUDITS (82–89)

| Path | Title | Status | Authority | Date |
|---|---|---|---|---|
| audits/82-code-audit.md | Code Audit | PASS | GENERATED-AUDIT | 2026-08-25 |
| audits/83..89 (reserved slots 83-security-audit … 89-dr-audit-rollup) | Reserved audit slots | NOT APPLICABLE (unassigned) | GENERATED-AUDIT | — |
| audits/backup-dr-audit-20260815-025021.md | Backup/DR Audit (latest instance) | PASS | GENERATED-AUDIT | 2026-08-15 |

## 5. LEDGERS (50–53)

| Path | Title | Status | Authority | Date |
|---|---|---|---|---|
| ledgers/50-claims-ledger.md | Claims Ledger | PENDING | AUTHORITATIVE-CURRENT (ledger domain) | slot reserved |
| ledgers/51-actions-ledger.csv | Actions Ledger | PENDING | AUTHORITATIVE-CURRENT (ledger domain) | slot reserved |
| ledgers/52-verification-ledger.md | Verification Ledger | PENDING | AUTHORITATIVE-CURRENT (ledger domain) | slot reserved |
| ledgers/53-metrics-ledger.csv | Metrics Ledger | PENDING | AUTHORITATIVE-CURRENT (ledger domain) | slot reserved |

Interim ledger seeds: `action-item-verification-20260822-053455.md`, `alert-volume-by-rule-*` series.

## 6. RELEASES (v1.0–v1.3)

| Path | Title | Status | Authority | Date |
|---|---|---|---|---|
| releases/v1.0.md | Release v1.0 Record | PASS | RELEASE-RECORD | 2026-08 |
| releases/v1.1.md | Release v1.1 Record | PASS | RELEASE-RECORD | 2026-08 |
| releases/v1.2.md | Release v1.2 Record | PARTIAL | RELEASE-RECORD | 2026-08 |
| releases/v1.3.md | Release v1.3 Record | IN PROGRESS | RELEASE-RECORD | 2026-08 |

Derived from phase38-21-release-claim-verification + phase38-95-release-assurance.

## 7. EVIDENCE

| Path | Title | Status | Authority | Date |
|---|---|---|---|---|
| ops/evidence/p37-workflow-export/wazuh-flow-classb-to-iris.json | Workflow export: class-B flow → IRIS | UNVERIFIED (hash-pin pending index build) | IMMUTABLE-EVIDENCE | 2026-08-25 |
| ops/evidence/p37-workflow-export/wazuh-high-severity-to-iris.json | Workflow export: high-severity → IRIS | UNVERIFIED (hash-pin pending index build) | IMMUTABLE-EVIDENCE | 2026-08-25 |
| evidence-indexes/p37-workflow-export.index.md | Evidence index (to be built Phase D) | PENDING | GENERATED-AUDIT | — |

## 8. ARCHIVE

| Path | Title | Status | Authority | Date |
|---|---|---|---|---|
| archive/pre-p38/** | Frozen mirror of pre-Phase-38 layout (1,834 files) | NO-GO for citation | ARCHIVE | 2026-08-25 |

## 9. Apply Note

On migration apply this document is rendered verbatim as `reports/INDEX.md`; reserved-slot rows (PENDING) are replaced automatically when the underlying files land, via the Phase D index rebuild.
