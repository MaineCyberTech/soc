# Phase 44: RTO/RPO Signoff

**Report ID:** phase44-29-rto-rpo
**Phase:** 44
**Title:** Phase 44 — RTO/RPO Owner Signoff
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:00:00Z
**Classification:** INTERNAL
**Status:** AWAITING-OWNER
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-29-rto-rpo.md`

---

## 1. RTO/RPO Proposal (from Phase 40/41)

| Service/Data Class | RPO (Proposed) | RTO (Proposed) | Basis | Status |
|--------------------|----------------|----------------|-------|--------|
| Wazuh Alerts | ≤ 1 hour | ≤ 4 hours | FS snapshots ~5-6/day | PROPOSED |
| Archives (14d) | ≤ 24 hours | ≤ 8 hours | S3 daily + FS ~5-6/day | PROPOSED |
| Config/Workflows | ≤ 24 hours | ≤ 2 hours | Git + exports | PROPOSED |
| Full Cluster | ≤ 24h (aspirational) | ≤ 24h | External target required | PROPOSED |

---

## 2. Evidence Basis (Fresh)

| Metric | Measured Value | Source |
|--------|----------------|--------|
| FS Snapshot Cadence | ~5-6/day | `_cat/snapshots/wazuh-backup` |
| S3 Snapshot Cadence | 5/day (fixed) | `_cat/snapshots/do-spaces` |
| Spot-check Duration | < 10 min (bounded) | P39/P40 spot-checks |
| Full Restore | Never executed | — |

---

## 2. Signoff Sheet (Awaiting Owner)

| Service Class | RPO Adopted | RTO Adopted | Owner Signature | Date |
|---------------|-------------|-------------|-----------------|------|
| Alerts | [ ] ≤ 1h | [ ] ≤ 4h | | |
| Archives | [ ] ≤ 24h | [ ] ≤ 8h | | |
| Config/Workflows | [ ] ≤ 24h | [ ] ≤ 2h | | |
| Full Cluster | [ ] ≤ 24h | [ ] ≤ 24h | | |

---

## 2. Status

**AWAITING-OWNER** — Sheet ready (DEC-40-01); awaiting owner signature in scheduled session.