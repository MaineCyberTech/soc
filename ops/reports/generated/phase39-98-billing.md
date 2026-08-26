# Phase 39 Billing Certification

**Report ID:** phase39-98-billing
**Phase:** 39
**Title:** BILL-39-02 — August 2026 Billing Coverage Matrix: Capture VERIFIED, Detection VERIFIED, IRIS Lane RESTORED-TODAY (Disclosure), Automated Routing PARTIAL; Stance RECOMMENDED With Disclosures
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:58:00Z
**Classification:** INTERNAL (client-shareable only via phase39-99 §client-safe section)
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-98-billing.md`

---

## 1. Certification Statement

| Field | Value |
|---|---|
| Certification ID | BILL-39-02 |
| Invoice period | **August 2026** |
| Billable stance | **RECOMMENDED — with disclosures (§5)** |
| Supersedes | phase38-91 (routing NOT certifiable at that time) |
| Cross-references | phase39-99-scorecard (metrics), phase39-100-monthly (volumes), phase39-34/36/37 (IRIS proof chain) |

## 2. Coverage Matrix per Service Line

| Service line | Status | Basis of verification | Evidence |
|---|---|---|---|
| Log capture (7 active endpoints) | **VERIFIED** | Fleet active-class = 7/9 registered; alerts flowing all cycle (today `wazuh-alerts-4.x-2026.08.25` = 53,347 docs; 08.24 = 55,001; 08.23 = 49,602); archives ingest live (879,734 docs today) | Live API counts in phase39-100 §2; fleet state phase39-80 |
| Detection (rule + canary E2E) | **VERIFIED** | Canary end-to-end proven (P38, carried forward as labeled); ET-Open curated ruleset active; detection-proven flag TRUE on scorecard | phase38-86/91 carry-forward; phase39-99 M-series |
| IRIS notification lane | **RESTORED-TODAY** (see §3 disclosure) | Three consecutive real executions → IRIS HTTP 200 ×3 → distinct DB alerts 37/38/39 @22:08:24Z; direct endpoint probe alert 36; context fields complete | phase39-34 (DLV-39-01), phase39-33, phase39-36 |
| Automated routing (Wazuh→Shuffle trigger) | **PARTIAL — CONDITIONAL-PASS** | Manual/API lane certified by direct evidence; automated webhook wiring not yet performed (UI-gated) | phase39-36 verdict; phase39-37 config draft |
| Backup/retention service | **VERIFIED (spot-check grade)** | fs repo 42 snapshots latest snap-20260825-2017 @20:17Z; s3 repo 85 snapshots latest s3-snap-20260825-2047 @20:48Z; first real restore-cycle proof this quarter | Live snapshot API output in phase39-100 §5; phase39-73 |
| Reporting/governance evidence quality | **STRONG** | Hash-chained manifests (migration N=1992 M=0), three CI gates GREEN same-day, canonical tree with INDEX/evidence-index | phase39-48; triple-CI output embedded in phase39-102 |

## 3. Disclosure Note — IRIS Notification Lane Was Silently Degraded

**What the client must know:** between approximately **Aug-15 and Aug-25**, the SOAR→IRIS case
notification lane was degraded while *appearing* healthy in execution counts. Era analysis:

| Era | Behavior | Evidence |
|---|---|---|
| ≤ Aug-15 19:36Z | Deliveries worked (alerts 34–35 persisted normally) | IRIS DB rows |
| ~Aug-15 workflow edit | Authorization header inside the live workflow was corrupted (literal placeholder string introduced by a prior-phase redaction mistake); body placeholders left unescaped | phase39-32/33 header audit |
| Aug-15 → Aug-25 | Executions still showed FINISHED, but IRIS creation failed inside them — silent degradation invisible to config audits | 31 lifetime failures visible only via delivery-monitor analysis |
| Aug-25 22:03Z | Proof round exposed layer-2 fault (400 Bad Request HTML) | phase39-34 §5 preliminary round |
| Aug-25 22:08Z | **RESTORED**: alerts 37/38/39 delivered with full context; escape artifact gone from template interpolation | phase39-34 §4 |

Root cause class: a redaction error touching a live workflow — caught not by configuration review
but by a functional delivery probe. Monitoring cron to prevent recurrence is backlog BCK-39-012.

## 4. Capacity and Exposure Disclosures

1. **Capacity constraint disclosed:** host filesystem at **84%** (148G disk, 24G avail). Ingest
   currently unaffected; ISM relief wave ETA 2026-08-29T21:00Z; plateau risk documented.
2. **TLS pending:** Shuffle UI remains plaintext on the trusted, mgmt-restricted LAN segment
   (publish binding restricted to operator address; loopback/docker-bridges blocked). TLS decision
   forced for early September (BCK-39-007).
3. **Packet lane deferred:** dedicated packet-workflow import/replay proofs outstanding (BCK-39-006).
4. **Two endpoints offline of nine:** 013 offline since 06:30Z cutoff (owner physical ask dispatched);
   008 retired-absent (long-standing). 015 counted active-class with a caveat (sleep-correlated flap;
   real merged.mg permission defect found, fix minutes-level once owner reachable).

## 5. Billable Stance Rationale

- **RECOMMENDED** because the two core lines — capture and detection — are independently verified
  end-to-end for the invoice period, and the notification lane was restored to *proven* status within
  the period (Aug-25).
- The Aug-15→Aug-25 notification degradation is disclosed rather than netted out: capture and
  detection (the billable telemetry pipeline) were never interrupted; the degradation affected
  downstream case creation only, and its full root-cause/fix evidence trail is provided (§3).
- Routing certification remains explicitly conditional (manual/API lane proven; automated wiring
  pending one UI session) — billed as PARTIAL, not claimed as PASS.

## 6. Limitations Summary (honest)

| Limitation | Effect on this certification |
|---|---|
| TLS not terminated (plaintext on trusted LAN) | Security-posture caveat only; no capture/detection impact |
| Packet-lane deferred | Detection line excludes packet-workflow-specific coverage |
| 2 endpoints offline | Capture line verified across the 7 active-class endpoints, not the full register |
| Full-cluster restore never rehearsed (spot-check only) | Backup line certified at spot-check grade, not DR grade |
| Published release asset unretrieved (rebuilt-labeled substitute archived) | No billing impact; noted for completeness |

*No secret values appear in this report; credentials are referenced exclusively by storage location.*
