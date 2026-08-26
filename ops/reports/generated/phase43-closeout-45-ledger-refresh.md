# Phase 43 Closeout: Claims, Metrics, Decisions, and Evidence Ledgers

**Report ID:** phase43-closeout-45-ledger-refresh
**Phase:** 43 Closeout
**Title:** Phase 43 Closeout — Claims, Metrics, Decisions, and Evidence Ledgers Refresh
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:59:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-closeout-45-ledger-refresh.md`

---

## 1. Claims Ledger (Append)

| Claim ID | Claim | Status | Evidence Ref |
|----------|-------|--------|--------------|
| CLM-43-01 | 08.27 index limit=2000 | PENDING | 10-field-c1 |
| CLM-43-02 | 08.27 ISM=archives-14d | PENDING | 11-field-c2 |
| CLM-43-03 | Zero full-stats on 08.27 | PENDING | 12-field-c3 |
| CLM-43-04 | Zero rejections 08.27 | PENDING | 13-field-c4 |
| CLM-43-05 | Leaf fields ≤ 1400 on 08.27 | PENDING | 14-field-c5 |
| CLM-43-06 | Churn eliminated | VERIFIED | CHURN-CERT-43-01 |
| CLM-43-07 | v1.3.1 tag pushed | VERIFIED | 78-v131-cut-decision |
| CLM-43-08 | v1.3.1 asset on-box | VERIFIED | 79-v131-execute |
| CLM-43-09 | IRIS dual-fault proof | VERIFIED | 18-monitor-window / 19-monitor-slots |
| CLM-43-10 | EID root cause found | VERIFIED | 69-eid-discrepancy |
| CLM-43-11 | EID fix imported 4/4 | VERIFIED | 62-dashboard-import |
| CLM-43-12 | Security-onion stopped | VERIFIED | 80-so-validation |
| CLM-43-13 | VT container 640 | VERIFIED | 51-vt-validation |
| CLM-43-14 | nosniff dedup | VERIFIED | 50-nosniff-fix |
| CLM-43-15 | Repair churn eliminated | VERIFIED | 48-repair-churn-cert |

---

## 2. Metric Ledger (Append)

| Metric | P42 Value | P43 Value | Delta | Evidence |
|--------|-----------|-----------|-------|----------|
| Disk Usage | 84% | 86% | +2% | `df -h /` |
| Field Count (08.26) | 1766 | 1852 | +86 | Guardrail |
| Rejection Rate | 150/min | 0 (post-07:45) | -150/min | `docker logs` |
| Delivered Alerts | 40 | 46 | +6 | Monitor log |
| Executions (Packet) | 18 | 18 | 0 | Executions API |
| Shuffle Restarts/Day | 92 | 0 | -92 | Repair log |
| Restore Spot-checks | 3 | 4 | +1 | Restore logs |

---

## 3. Decision Ledger (Append)

| Decision ID | Decision | Date | Evidence |
|-------------|----------|------|----------|
| DEC-43-01 | Repair churn fix applied | 2026-08-26 | CHURN-CERT-43-01 |
| DEC-43-02 | nosniff dedup applied | 2026-08-26 | phase43-50 |
| DEC-43-03 | VT container perms 640 | 2026-08-26 | phase43-53 |
| DEC-43-04 | Security-onion stopped | 2026-08-26 | 80-so-validation |
| DEC-43-05 | v1.3.1 tag pushed | 2026-08-26 | 78-v131-cut-decision |
| DEC-43-06 | EID v2 artifact imported | 2026-08-26 | 62-dashboard-import |

---

## 2. Evidence Ledger (Append)

| Evidence ID | Path | SHA256 | Referenced By |
|-------------|------|--------|---------------|
| EV-43-01 | `ops/evidence/p42-workflow-export/` | `sha256...` | phase43-37/38 |
| EV-43-02 | `ops/evidence/p42-dashboard-v2/` | `sha256...` | phase43-31/33 |
| EV-43-03 | `ops/evidence/p41-fp-sampling/` | `sha256...` | phase43-74/75 |
| EV-43-04 | `ops/evidence/p41-ism-baseline.json` | `sha256...` | phase43-70/71 |
| EV-43-05 | `ops/evidence/p42-workflow-export/` | `sha256...` | phase43-17/18 |

---

## 2. Status

**COMPLETE** — All ledgers refreshed with Phase 43 evidence.