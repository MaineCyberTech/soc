# Phase 39 Packet Workflow Baseline Reconciliation — BASE-39-01

**Report ID:** phase39-38-packet-workflow-baseline  
**Phase:** 39  
**Title:** P38 Packet-Workflow Design vs Current Estate — Routing Lanes, SID Evidence Inventory, and the Standing Decision That a Dedicated Lane Remains Required  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:00:38Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Record ID:** BASE-39-01  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-38-packet-workflow-baseline.md`

---

## 1. Purpose

Reconcile the P38 design artifact (`phase38-75-packet-workflow.md` skeleton) against
the post-P39 estate and re-state whether a dedicated packet workflow is still
justified.

## 2. Estate Snapshot (report time)

| Asset | State |
|---|---|
| Shuffle workflows | **2** — `wazuh-high-severity-to-iris` (production-capable for Class A/OpenCanary lane) + `wazuh-flow-classb-to-iris`; no packet workflow exists |
| High-severity lane | DNS + parameter layers repaired; 3-consecutive-delivery proven (DLV-39-01); recertified CONDITIONAL-PASS (ROUT-39-01) |
| Packet/Suricata routing | **no lane** — candidate second workflow |

## 3. Routing Class Map

| Class | Source | Lane status |
|---|---|---|
| Class A honeypot (OpenCanary/canary events) | Wazuh rules | ✅ DONE this phase via high-severity workflow (API path certified; auto-path pending CFG-39-01) |
| Class B flow | classb workflow | operational (1/1 delivered) |
| Packet/Suricata SID-routed | Suricata EVE → Wazuh | ❌ **candidate lane, not built** |

## 4. SID Evidence Inventory

| Evidence | Detail |
|---|---|
| Canary sid **2027967** | E2E-proven in P35 (`phase35-canary-*` evidence chain); natural first allowlist entry |
| ET Open 544 curated population | curated sid set available from P31–P33 sensor work as expansion pool |
| Schema | `suricata eve.json` fields available at sensor: `timestamp`, `alert.signature_id`, `alert.severity`, `src_ip`, `dest_ip` (+ tags where present) — matches the normalization field map of the P38/P39 design |

## 5. Guardrails Recap (inherited from P38 design)

| # | Guardrail |
|---|---|
| I1 | disabled-by-default (`status="test"`) until ROUT decision |
| I2 | internal-only destinations (IRIS), no third-party egress |
| I3 | synthetic-tag sink branch before any routing action |
| I4 | malformed input dead-letters, never routes |
| I5 | target-failure try/catch → dead-letter, never silent crash |
| +  | datastore dedup TTL 300 s; per-branch counters |

## 6. Why Not Fold Into the Honeypot Lane

The high-severity workflow's semantics are: coarse trigger, notify-only, fixed
severity mapping, no dedup. The packet lane requires: SID allowlist, event-field
validation, TTL-based dedup, per-class counters, synthetic isolation. Overloading one
workflow would couple allowlist/dedup changes to the production honeypot lane and mix
dedup semantics (event-identity vs alert-presence).

## Decision

**A dedicated, isolated packet workflow REMAINS REQUIRED.**
Design finalized into import-ready artifact WF-39-02 (phase39-39);
routing verdict deferred to ROUT-39-02 pending build+proofs.
