# Phase 40 Billing Certification

**Report ID:** phase40-92-billing
**Phase:** 40
**Title:** BILL-40-03 — August 2026 Billing Coverage Matrix: Capture VERIFIED, Detection VERIFIED, Class-A Automated Routing NOW CERTIFIED (Upgraded from Conditional-Manual); Stance RECOMMENDED With Disclosures
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:00:00Z
**Classification:** INTERNAL (client-shareable only via phase40-93 §client-safe section)
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-92-billing.md`

---

## 1. Certification Statement

| Field | Value |
|---|---|
| Certification ID | BILL-40-03 |
| Invoice period | **August 2026** |
| Billable stance | **RECOMMENDED — with disclosures (§4)** |
| Supersedes | BILL-39-02 (phase39-98; routing was then PARTIAL/conditional) |
| Cross-references | SCORE-40-04 (phase40-93), MONTHLY-40-09 (phase40-94), BCK-40 register (phase40-91) |

## 2. Coverage Matrix per Service Line

| Service line | Status | Basis of verification | Evidence |
|---|---|---|---|
| Log capture (7 active-class endpoints + packet sensor) | **VERIFIED** | Fleet 7 active-class of 10 registered; ingest clean all cycle: archives 08.26 = 175,369 docs by 03:00Z under the corrected field template with ZERO rejections; sensor pipeline proven THRICE today via marked-event full chains | Live API counts in phase40-94 §3; fleet state phase39-80 + phase40 chain |
| Detection (rules + canary E2E) | **VERIFIED** | Field-data completeness RESTORED on the new index (limit=2000+ISM; last rejection ever 00:00:01.431Z; every post-cutover window zero vs ~150/min baseline); canary chains carry exact IDs at every hop | phase40-06/-07/-08/-13; phase40-37 §4 |
| Notification routing — Class-A lane | **CERTIFIED — AUTOMATED** (upgraded from P39 conditional-manual) | Wazuh→Shuffle webhook is PRODUCTION-WIRED and proven end-to-end: sensor flow 999000777 → wazuh alert 1787707735.1208554 → execution b6d07492 FINISHED src=webhook → IRIS HTTP 200 → alert 42 @01:28:57Z (~2 s). Config-of-record on both nodes. Delivery monitor live at */15 SLA-visible cadence | phase40-37/-38/-39/-40; phase40-66…68 |
| Packet-analysis lane | **DEFERRED (disclosed)** | Dedicated packet-workflow import deferred BY CHOICE pending payload refinement; path proven OPEN (POST works — the historical 401s were a trailing-newline token artifact, root-caused and codified); ×7 synthetic canary-class proofs banked today | phase40-41…53 |
| Endpoint service state | **HONEST-PARTIAL** | 7 of 10 registered endpoints active-class. Two offline, both OWNER-BLOCKED (013 power; 015 device-side flap after its manager-side permission defect was FIXED — 83,736 lifetime errors ended). One retired-stopped (008) | phase40-14…24 chain |
| Dashboards | **LIVE** | 8/8 saved objects imported via API into global tenant (private-tenant AUTHZ fail diagnosed en route); runtime visual check pending operator login | phase40-62 |
| Backup/retention service | **VERIFIED** | fs repo 42 snapshots (latest snap-20260826-0017 @00:17Z); s3 repo 86 snapshots (latest s3-snap-20260826-0047 @00:48Z); SECOND production-safe bounded restore this quarter (count parity 603=603); s3 snapshot cadence corrected to 5/day of record | Live snapshot API output in phase40-94 §7; phase40-57 |
| Evidence quality of this certification | **STRONG** | Every claim above traces to same-day command output embedded in cited reports; three CI gates GREEN same-day; corrections table maintained (C-40 series) | Triple-CI embed in phase40-96 §6 |

## 3. What Changed vs BILL-39-02

1. **Routing upgraded CONDITIONAL-MANUAL → CERTIFIED-AUTOMATED.** In P39 only the manual/API
   lane was certified. The webhook is now wired into production integratord config on both nodes
   and proven by a full marked-event chain with ~2 s delivery latency.
2. **Detection line strengthened** from "canary carried forward" to "field-data completeness
   restored with rejection flatline proof" — the ingest limitation that shaped early-August data
   quality is closed with before/after evidence.
3. **Silent-degradation era cannot recur silently:** delivery monitor is scheduled (*/15) rather
   than ad-hoc; accounting is machine-readable (delivered=40/failed=31/aborted=3).

## 4. Disclosures (client-visible honesty items)

1. **Self-signed TLS (TOFU posture):** Shuffle UI now served over TLS 1.2/1.3 via reverse proxy
   on the management plane (:3443) with HSTS/XFO/nosniff and LAN plaintext refused; certificate
   is self-signed with SHA-256 fingerprint pinned in the release record. Renewal procedure
   documented. Clients must verify fingerprint out-of-band on first connect.
2. **Webhook endpoint unauthenticated within the trusted LAN segment:** the Shuffle hooks
   endpoint accepts posts from the internal network without its own credential layer; exposure is
   internal-only (management segment), and the Wazuh-side trigger is the sanctioned producer.
   Disclosed as accepted-risk pending future hardening.
3. **Packet lane pending:** dedicated packet-workflow automation deferred by choice; detection
   coverage excludes packet-workflow-specific routing until BCK-40-006 completes.
4. **RTO/RPO objectives remain draft:** DEC-40-01 sheet ready-to-sign but AWAITING-OWNER;
   recovery objectives are planning-grade, not contractual, until signed.
5. **Capacity:** host filesystem ~82–83% used; ISM relief wave ETA 2026-08-29T21:00:44Z;
   ingest currently unaffected (zero rejections post-fix).

## 5. Billable Stance Rationale

- **RECOMMENDED** because capture and detection — the billable telemetry pipeline — are
  independently verified end-to-end for the invoice period, and the notification lane moved from
  conditional to fully automated WITHIN the period, with exact-ID proof at every hop.
- Evidence-quality statement: unlike earlier cycles where some lines rode carried-forward or
  conditional labels, every material claim in this certification rests on same-day, embedded,
  reproducible command output (API counts, execution IDs, IRIS rows, CI runs). This is the
  strongest evidence base of any phase to date.
- The two offline endpoints are disclosed as owner-blocked, not netted out; the packet-lane gap
  is a scoped exclusion, not an unstated one.

*No secret values appear in this report; credentials are referenced exclusively by storage location.*
