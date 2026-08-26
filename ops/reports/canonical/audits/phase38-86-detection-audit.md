# Phase 38-86: Detection Audit Report

**Report ID:** phase38-86-detection-audit
**Phase:** 38
**Title:** Phase 38-86: Detection Audit Report
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-86-detection-audit.md`

| Field | Value |
|-------|-------|
| **Report ID** | phase38-86 |
| **Generated** | 2026-08-25 21:17 UTC |
| **Classification** | Internal / Operational |
| **Owner** | MCT SOC |
| **Status** | PARTIAL |

**Status:** PARTIAL
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-86-detection-audit.md`
**Retention Class:** LONG

---

## 1. Executive Summary

Packet-path detection is REAL and verified end-to-end at the index level: sensor 016 ships Suricata EVE to Wazuh, and the canonical full-text count `_count?q=suricata` across `wazuh-alerts-*` returns **433** — exactly matching the phase38-24 proof. Canary E2E (sid 2027967) was proven in P35. What is NOT proven: routing outcomes of the high-severity workflow's 68 executions, FP quality, and case closure. No isolated packet workflow exists; workflow-level controls are ABSENT.

## 2. Packet/Index Proof Status

### 2.1 Suricata alerts indexed — VERIFIED
```
$ GET wazuh-alerts-*/_count?q=suricata → {"count":433}   (57 shards, all green)
```
Sample docs confirm provenance:
```
agent.name = mct-packet-sensor
rule.description = "Suricata: Alert - SURICATA Applayer Wrong direction first Data" (id 86601)
location = /var/log/suricata/eve.json
```
Today's alert-tier suricata-grouped events: 5 (`rule.groups:suricata`, all-time). Archives tier holds 104 EVE lines today from agent 016 (102 `event_type=stats`, 1 `event_type=alert`) — i.e., EVE telemetry flows continuously but only a small fraction is alert-grade. The 433 figure is cumulative since sensor activation.

### 2.2 Canary E2E — PROVEN (P35)
sid 2027967 canary evidence chain documented via `p35-canary-manifest.sh`/`p34-canary-evidence.sh`; referenced in current-state doc as VERIFIED. No re-run performed this phase (no new canary fired); status carried forward as P35-proven.

### 2.3 Wazuh ruleset/decoder layer
Stock v4.14.7 decoders/rules handle EVE JSON (decoder path `json` → rule id 86601 family). The "544 ET Open curated" custom-ruleset claim could NOT be confirmed live: manager `/var/ossec/etc/{decoders,rules}` contain stock + local files only (`local_rules.xml` with 86 rule ids), no 544-rule ET bundle found on the master container filesystem this run. Treat "544 curated" as UNVERIFIED until a manifest/hash of the deployed ruleset is captured (backlog).

## 3. Workflow Controls — ABSENT

- No isolated packet workflow exists (phase38-75/76 are designs; not deployed).
- The two production workflows (`wazuh-high-severity-to-iris`, `wazuh-flow-classb-to-iris`) have no packet-source branch; their webhook trigger for the high-severity flow reports `"is_valid": false` in the API export — a latent breakage risk if re-saved.
- No rate-limit, dedup, or allowlist control exists between Wazuh alerts and IRIS case creation beyond workflow logic labeled "notify-only".

## 4. Routing State — NONE-production, with an open question

```
GET /workflows/eb937a37…/executions → 68 executions
  FINISHED: 65   ABORTED: 3
GET /workflows/e951db98…/executions → 1 execution
Workflow actions (high-severity):
  'Log received alert (notify-only)'
  'Create DFIR-IRIS alert (notify-only)'
```

The prior claim "796 executions, zero real routing" is superseded: live counts are **68** (high-sev) + **1** (classb). The open investigation question stands: are these 68 executions hitting a TEST IRIS project or creating REAL alert artifacts? Actions are labeled notify-only, but no reconciliation was found between execution count and IRIS alert inventory. Until reconciled, treat routing state as **NONE-production / unverified outcomes**. Required check (next phase): pull IRIS alert list filtered by creation timestamp vs Shuffle execution timestamps; expect 65 created artifacts if real.

## 5. False-Positive Quality — UNMEASURED

No FP baseline exists: no precision metric, no rule-hit histogram over time, no noise budget per rule family. Today's top mct-packet-sensor alert groups are host-noise categories (syslog 888, dpkg 467, config_changed 314, pam 302…) rather than network detections — indicating the sensor contributes mostly host telemetry to the alert tier so far, and network-detection volume is low. A noise-baseline query pack exists in ops/scripts (`noise-baseline-opensearch-query.example.json`) but has never been operationalized into a scheduled report.

## 6. Case Outcomes — UNKNOWN

DFIR-IRIS integration exists (stack up 3d, healthy) but no closed-loop record maps: alert → case → disposition. No case-outcome field in any ledger. This blocks any MTTR/closure KPI.

## 7. Gaps → Backlog References

| Gap | Sev | Backlog ref |
|-----|-----|-------------|
| 68-execution outcome reconciliation vs IRIS inventory | P1 | BL-detection-01 (new) |
| Deploy isolated packet workflow with test/prod separation | P1 | phase38-75 design → implement |
| Fix `is_valid:false` trigger on high-sev workflow | P2 | BL-detection-02 |
| Verify/manifest "544 ET Open curated" ruleset or correct docs | P2 | BL-detection-03 |
| Operationalize FP/noise baseline (scheduled report) | P2 | BL-detection-04 |
| Case-outcome capture in IRIS + ledger linkage | P3 | BL-detection-05 |
| Re-fire canary sid 2027967 to refresh E2E proof post-changes | P3 | BL-detection-06 |

## 8. Verdict

Detection pipeline: ingest VERIFIED, correlation PARTIAL, response UNPROVEN. The stack detects; it does not yet demonstrate controlled, auditable response.

---
*Live queries executed against OpenSearch + Shuffle API, 2026-08-25 21:00–21:15 UTC.*
