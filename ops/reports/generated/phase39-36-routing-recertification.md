# Phase 39 Routing Recertification — Wazuh→IRIS Lane

**Report ID:** phase39-36-routing-recertification  
**Phase:** 39  
**Title:** ROUT-39-01 — Conditional Recertification of Manual/API-Path IRIS Routing After DNS + Parameter Remediation  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:00:38Z  
**Classification:** INTERNAL  
**Status:** PARTIAL (conditional pass)  
**Record ID:** ROUT-39-01  
**Author:** opencode/ox-alpha  
**Owner:** MCT SOC (automation: opencode/ox-alpha)  
**Review date:** Phase 40  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-36-routing-recertification.md`

---

## 1. Certification Criterion

> The Wazuh→Shuffle→IRIS routing lane may be certified when three consecutive real
> executions deliver distinct, context-complete alerts to IRIS with no duplicates,
> over a durable authentication and network path.

## 2. Criterion Assessment

| Sub-criterion | Evidence | Result |
|---|---|---|
| 3 consecutive real deliveries | executions `53e2e193…` / `ab14f34c…` / `413c137a…` all FINISHED with HTTP 200 (DLV-39-01 §3) | ✅ |
| Distinct alerts | alert_ids 37/38/39 | ✅ |
| Complete context | sev=6 Critical, cust=1 IrisInitialClient, tags source:wazuh,class:A preserved in DB rows @22:08:24Z | ✅ |
| No duplicates | 1:1 execution→alert mapping verified | ✅ |
| Durable authentication | IRIS JWT bearer long-lived inside workflow headers; rotation/recovery procedure documented (REA-39-01); token validated by differential probe | ✅ |
| Durable network path | overlay attach survives restarts; validated from exact exec plane (NET-39-01-APPLY §3) — residual: full container re-create requires re-attach | ✅ w/ condition |

## 3. DNS Durability Assessment

- Current attach (`docker network connect … --alias`) persists across daemon restarts
  and container restarts.
- **Not** persisted across full re-creation of the IRIS nginx container
  (`docker rm/run` or stack re-up) → mitigated by compose adoption change
  (phase39-32 §4) tracked as precondition (a).

## 4. Guardrails (unchanged)

- Workflow remains **notify-only**: creates alerts; no auto-case creation.
- Severity mapping fixed at 6/Critical for this lane.
- Workflow status `test` retained pending trigger wiring.

## 5. Rollback Options

1. Network layer: `docker network disconnect shuffle_swarm_executions iriswebapp_nginx`.
2. Workflow layer: re-import last exported workflow JSON
   (`ops/evidence/p38-workflow-export/eb937a37….json` lineage) or delete workflow.
3. Kill switch precedent: disabled Zeek integration block in ossec.conf demonstrates
   the comment-out-and-restart pattern used historically on this estate.

## 6. Remaining Conditions Before FULL Production Routing

| # | Condition | Reference |
|---|---|---|
| a | IRIS compose network persistence change (external overlay attach declared in compose) | phase39-32 §4 |
| b | Delivery-failure alerting live on a timer (script exists; wire schedule + state dedupe) | ALERT-39-01, phase39-35 §4 |
| c | Wazuh→Shuffle trigger wiring so alerts flow automatically instead of API-triggered (ossec.conf integration block + valid webhook trigger on the workflow) | CFG-39-01, phase39-37 |

## Verdict

**CONDITIONAL-PASS.** Manual/API-path routing is certified by direct evidence.
Automated production routing stays blocked until conditions (a)–(c) land.
Owner: MCT SOC. Review: Phase 40.
