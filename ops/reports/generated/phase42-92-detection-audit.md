# Phase 42 Detection Audit — DET-AUD-42-01

**Report ID:** phase42-92-detection-audit
**Phase:** 42
**Title:** DET-42-05 Lanes Matrix — Class-A CERTIFIED Sustained (Fresh Monitor Run delivered=46; Two Real Fail-Closed Catches), Packet TEST-ONLY-DEFERRED (Blocker-Referenced), FP Qualitative Continuing (10-Universe, 2 Natural, Zero New SIDs), Archives Data-Quality Improved (Clean Compact Fields), Containment Detection-Impact VERIFIED-ZERO (Hourly Volume Steady Through Restart/Burst Windows); Coverage Gaps Stated Honestly
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T10:33:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-92-detection-audit.md`

---

## 1. DET-42-05 lanes matrix

| Lane | Disposition | Evidence anchor |
|---|---|---|
| Class-A (manager→Shuffle→IRIS) | **CERTIFIED — sustained** | MON-CERT-42-01 PASS-WITH-WINDOW-NOTE (phase42-59); fresh run this session `delivered=46 failed=31 aborted=3 other=4`, execs 83/1; **second real fail-closed ERROR caught ~07:45Z** (backend-restart correlation), green next slot — machinery proven on two genuine events now (04:15Z + 07:45Z) |
| Packet (suricata→workflow) | **TEST-ONLY / DEFERRED** | capability research DEFINITIVE-negative T1–T5 (phase42-15…32); exact blockers documented (refs-literal Tools + execute_python injection defect = R-PKT-PLATFORM); remediation B>A>C; production apply stays BLOCKED-platform |
| FP baseline framework | **CONTINUING — qualitative** | phase42-74/-75: rolling universe 10 alerts under review (2 natural, zero new SIDs); weekly standing cadence; no rates until ≥50 natural |

## 2. Archives data-quality improvement

Compact lane fields are CLEAN by construction: whitelisted flat counters only —
`eve.json` contains ZERO stats-type lines since source-side removal (sensor grep),
indexed histogram flat at ~51–54/hour with no malformed-field noise. The old
high-cardinality stats flood that drove field-growth is gone from both file and
index layers; archive indices now carry a bounded schema surface for the compact
type. Adjudicator C5 will certify the leaf-count side at 08.27 birth.

## 3. Detection-impact of containment — VERIFIED-ZERO

Claim: removing stats from eve and gating repair restarts did not degrade alert
detection at any point in the window.

```
$ wazuh-alerts-4.x-2026.08.26 hourly doc_count:
00h 2551 · 01h 2264 · 02h 2043 · 03h 2002 · 04h 2270 · 05h 2268 ·
06h 2316 · 07h 4764 · 08h 2642 · 09h 2424 · (10h partial 322)
```

Volume never dips through: the churn-proof window, the controlled restarts
(07:45–07:51Z), the rejection bursts, or the VT/nosniff change windows. The 07:00
hour spike (~2× baseline) coincides with the syscollector/vuln-detector burst
activity and returns to baseline immediately after — no gap, no trough, no
silent hour. Alert-count stability across every intervention is the zero-impact
proof.

## 4. Coverage gaps (honest)

- Packet lane disabled-in-production: network-side detection currently depends on
  sensor EVE→Wazuh path only; no Shuffle-side packet enrichment until R-PKT-PLATFORM
  remediation lands.
- Windows coverage partially idle: eventID-bearing docs exist (6,606 trailing-7d)
  but client activity is bursty; agent 013 offline >26h and 015 flapping shrink the
  endpoint detection surface (owner batch).
- Canary-based FP statistics remain qualitative until ≥50 natural accumulate.
- Strict 24h-contiguous monitor certificate completes 2026-08-27T01:45Z (window note).
