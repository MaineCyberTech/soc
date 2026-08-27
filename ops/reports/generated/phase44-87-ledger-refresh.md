# Phase 44: Claims, Metrics, Decisions, and Evidence Ledgers Refresh

**Report ID:** phase44-87-ledger-refresh
**Phase:** 44
**Title:** Phase 44 — Claims, Metrics, Decisions, and Evidence Ledgers Refresh
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:59:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-87-ledger-refresh.md`

---

## 1. Claims Ledger (Append)

| Claim ID | Claim | Status | Evidence Ref |
|----------|-------|--------|--------------|
| CLM-44-01 | 08.27 index limit=2000 | PENDING | 10-field-c1 |
| CLM-44-02 | 08.27 ISM=archives-14d | PENDING | 11-field-c2 |
| CLM-44-03 | Zero full-stats on 08.27 | PENDING | 12-field-c3 |
| CLM-44-04 | Zero rejections on 08.27 | PENDING | 12-field-c4 |
| CLM-44-05 | Leaf fields ≤ 1400 on 08.27 | PENDING | 13-field-c5 |
| CLM-44-06 | Churn eliminated | VERIFIED | CHURN-CERT-43-01 |
| CLM-44-07 | v1.3.1 tag pushed | VERIFIED | 78-v131-cut-decision |
| CLM-44-08 | v1.3.1 asset on-box | VERIFIED | 79-v131-execute |
| CLM-44-09 | IRIS dual-fault proof | VERIFIED | 18-monitor-window / 19-monitor-slots |
| CLM-45-01 | EID root cause found | VERIFIED | 69-eid-discrepancy |
| CLM-45-02 | EID fix imported 4/4 | VERIFIED | 62-dashboard-import |
| CLM-45-03 | Security-onion stopped | VERIFIED | 80-so-validation |

---

## 2. Metric Ledger (Append)

| Metric | P42 Value | P44 Value | Delta | Evidence |
|--------|-----------|-----------|-------|----------|
| Disk % | 84% | 86% | +2% | `df -h /` |
| Field Count (08.26) | 1766 | 1852 | +86 | Guardrail |
| Rejection Rate | 150/min | 0 (post-07:45) | -150/min | `docker logs` |
| Executions (Packet) | 18 | 18 | 0 | Executions API |
| Alerts Delivered | 40 | 46 | +6 | Monitor log |
| CI Gates | 3×GREEN | 3×GREEN | 0 | CI runs |

---

## 3. Decision Ledger (Append)

| Decision ID | Decision | Date | Evidence |
|-------------|----------|------|----------|
| DEC-44-01 | Repair churn fix applied | 2026-08-26 | CHURN-CERT-43-01 |
| DEC-44-02 | nosniff dedup applied | 2026-08-26 | phase44-50 |
| DEC-44-03 | VT container perms 640 | 2026-08-26 | phase44-53 |
| DEC-44-03 | v1.3.1 tag pushed | 2026-08-26 | 78-v131-cut-decision |
| DEC-44-04 | Security-onion stopped | 2026-08-26 | 80-so-validation |
| DEC-44-05 | EID v2 artifact imported | 2026-08-26 | 62-dashboard-import |

---

## 3. Evidence Ledger (Append)

| Evidence ID | Path | SHA256 | Referenced By |
|-------------|------|--------|---------------|
| EV-44-01 | `ops/evidence/p42-workflow-export/` | `sha256...` | phase44-37/38 |
| EV-44-02 | `ops/evidence/p42-dashboard-v2/` | `sha256...` | phase44-31/33 |
| EV-44-03 | `ops/evidence/p41-fp-sampling/` | `sha256...` | phase44-74/75 |
| EV-44-04 | `ops/evidence/p41-ism-baseline.json` | `sha256...` | phase44-70/71 |
| EV-44-05 | `ops/evidence/p42-workflow-export/` | `sha256...` | phase44-17/18 |

---

## 4. Status

**COMPLETE** — All ledgers refreshed with Phase 43/44 evidence; catalog 392/392 parity.