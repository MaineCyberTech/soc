# Phase 41 FP Sample Extraction Record

**Report ID:** phase41-70-fp-sample-extract
**Phase:** 41
**Title:** FP-EXTRACT-41-01 — Extraction Record For The 12-Alert Rolling-7d Universe: SID Distribution Table With Canary-Marked Vs Natural Separation By MCT-CANARY Marker Fields, Sample Artifact Path + sha256, Notable Single External-Dest Natural Alert sid 2260001 Classified UNKNOWN-Benign-Leaning Pending Recurrence
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:40:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-70-fp-sample-extract.md`

---

## 1. Sample artifact — VERIFIED

| Field | Value |
|---|---|
| Path | `ops/evidence/p41-fp-sampling/sample-25.json` |
| sha256 | `27620584aefc7cf19eceb091a3b1e779e186794041001d2828c8e509ad14ae63` |
| Size / mtime | 4,398 bytes / 2026-08-26T04:39:28Z |
| Documents | **12** (`hits.total.value = 12`, relation `eq`, 60/60 shards successful) |
| Window | Rolling 7 days ending 2026-08-26 |
| Content class | Alert metadata only — no payload capture beyond metadata fields |

## 2. Separation method

An alert is classified **canary-marked (synthetic)** iff `rule.description`
contains the literal marker substring `MCT-CANARY` (marker fields carried in
the Wazuh rule description by our canary injection convention). All other
alerts are classified **natural candidates**. Method is deterministic,
reproducible from the stored artifact, and requires no external state.

Count reconciliation note: phase planning anticipated roughly 11 synthetic /
1 natural; the marker-based method on the actual artifact yields **8 marked /
4 unmarked**. Both splits support identical conclusions (see phase41-71); the
artifact-derived numbers are authoritative here.

## 3. SID distribution table — VERIFIED from artifact

### 3a. Canary-marked (synthetic) — 8 of 12 — excluded from FP math by design

| SID | Signature (abbreviated) | Count | Markers observed |
|---|---|---|---|
| 2027967 | ET MALWARE HTTP Request for Possible ELF/LiLocked Ransomware Note (+ LiLocked generic hits) | 8 | 7× `[MCT-CANARY-P40-E2E-001…007]` + 1× `[MCT-CANARY-P35-TEST-002]` |

All 8 originate from the two sanctioned canary injectors on the lab segment;
timestamps cluster around test-execution windows (Aug 25 18:14Z; Aug 26
01:07–01:28Z).

### 3b. Natural candidates — 4 of 12

| # | Timestamp (UTC) | SID | Signature | src → dst | Proposed label |
|---|---|---|---|---|---|
| N1 | 2026-08-25T19:18:18Z | **2260001** | SURICATA Applayer Wrong direction first Data | external → internal host | **UNKNOWN-benign-leaning** pending recurrence |
| N2 | 2026-08-25T17:53:54Z | 2210038 | SURICATA STREAM FIN out of window | internal → internal gateway | UNKNOWN-benign-leaning |
| N3 | 2026-08-19T06:10:16Z | 2100366 | GPL ICMP PING *NIX | internal host → internal host | UNKNOWN-benign-leaning (classic monitoring-ping pattern) |
| N4 | 2026-08-18T21:34:58Z | 2100366 | GPL ICMP PING *NIX | same pair as N3 | UNKNOWN-benign-leaning (repeat pair, low rate: 2 in 7d) |

Notable per plan: **N1 (sid 2260001)** is the single externally-initiated
natural event in the window — an application-layer protocol-ordering anomaly
on an inbound flow across the quiet SPAN segment. Classified
UNKNOWN-benign-leaning pending recurrence; a lone protocol-edge case with no
corroborating indicators is not actionable.

## 4. Observations

- Natural traffic on the SPAN segment is QUIET: 4 candidate events in ~7 days,
  none repeated at triage-worthy rates.
- Canary lane healthy: P35-era and P40-E2E markers both visible end-to-end
  through Wazuh indexing.
- Population is far too small for any tuning statistic (phase41-69 §6
  stop-condition applies).
