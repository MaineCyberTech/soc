# Phase 43: RTO/RPO Signoff

**Report ID:** phase43-29-rto-rpo-signoff.md
**Phase:** 43
**Title:** Phase 43 RTO/RPO Owner Signoff
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T15:15:00Z
**Classification:** INTERNAL
**Status:** AWAITING-OWNER
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-29-rto-rpo-signoff.md`

---

## 1. RTO/RPO Proposal (from Phase 40/41)

| Service/Data Class | RPO (Proposed) | RTO (Proposed) | Basis | Status |
|--------------------|----------------|----------------|-------|--------|
| Wazuh Alerts | ≤ 1 hour | ≤ 4 hours | FS snapshots ~5-6/day | PROPOSED |
| Archives (14d) | ≤ 24 hours | ≤ 8 hours | S3 daily + FS ~5-6/day | PROPOSED |
| Config/Workflows | ≤ 24 hours | ≤ 2 hours | Git + exports + config backup | PROPOSED |
| Full Cluster | ≤ 24 hours (aspirational) | ≤ 24 hours | External target required | PROPOSED |

---

## 1. Measured Evidence (from Phase 41/42)

| Metric | Measured Value | Source |
|--------|----------------|--------|
| FS Snapshot Cadence | ~5-6/day (irregular) | `_cat/snapshots/wazuh-backup` |
| S3 Snapshot Cadence | 5/day (fixed) | `_cat/snapshots/do-spaces` |
| Spot-check Restore | < 10 min (small index) | Phase 39/40 spot-checks |
| Full Restore | Never tested | — |
| RTO Measured | Never measured | — |
| RPO Measured | ≤ 4h (FS) / ≤ 24h (S3) | Snapshots |

---

## 2. Signoff Sheet (Awaiting Owner)

| Service Class | RPO Adopted | RTO Adopted | Owner Signature | Date |
|---------------|-------------|-------------|-----------------|------|
| Alerts | [ ] ≤ 1h | [ ] ≤ 4h | | |
| Archives | [ ] ≤ 24h | [ ] ≤ 8h | | |
| Config/Workflows | [ ] ≤ 24h | [ ] ≤ 2h | | |
| Full Cluster | [ ] ≤ 24h | [ ] ≤ 24h | | |

---

## 3. Status

**AWAITING-OWNER** — Sheet ready; awaiting owner signature in scheduled session.