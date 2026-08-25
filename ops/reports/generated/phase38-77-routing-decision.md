# Phase 38-77 Production Routing Decision

**Report ID:** phase38-77-routing-decision  
**Phase:** 38  
**Title:** Phase 38-77 Production Routing Decision — DEFERRED to Phase 39 with Pre-Approval Requirements  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T21:13:25Z  
**Classification:** INTERNAL  
**Scope:** Go/No-Go for production alert routing via Shuffle → DFIR-IRIS  
**Status:** DEFERRED  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Deciders:** ["human-operator", "opencode/ox-alpha"]  
**Evidence Roots:** ["/opt/mct-security-stack/ops/evidence/p38-workflow-export/", "/opt/mct-security-stack/ops/reports/generated/phase38-74-shuffle-inventory.md"]  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-77-routing-decision.md`  
**Retention Class:** canonical-current  

---

## 1. Decision

**PRODUCTION ROUTING: DEFERRED** (revisit = Phase 39).

## 2. Rationale

| # | Blocking condition | Evidence |
|---|---|---|
| B1 | No isolated packet workflow exists yet — nothing proven idempotent/isolated | phase38-75 (design only), phase38-76 (BLOCKED) |
| B2 | Hardening unapplied — frontend on `0.0.0.0:3001`, no TLS, no firewall | phase38-73 §1; live docker ps 2026-08-25 |
| B3 | Token rotation pending — current bearer token disclosed in ≥7 corpus files | phase38-73 §7 |
| B4 | Existing "production-shaped" workflow has degraded delivery: 65/68 executions contain IRIS DNS resolution failures (`iriswebapp_nginx` unresolvable from workers) | phase38-74 §4 |

Enabling production routing now would mean relying on an exposed control plane, a burned token,
and a delivery path with an unresolved DNS failure mode.

## 3. Pre-Approval Requirements (ALL must close before revisit)

### 3.1 SID Shortlist
Start minimal, expand by evidence:

| Priority | SID | Source | Rationale |
|---|---|---|---|
| 1st candidate | **2027967** | Suricata canary (`mct-canary01`) | High-fidelity deception hit; already exercised in P31/P33 evidence chain |
| 2nd | TLS-related high-sev SIDs from p32 rule inventory | Suricata | Pending FP review below |
| Excluded | any SID with observed FP rate >2% over 14d | — | Auto-pruned at review |

### 3.2 False-Positive Review Process
- Baseline each candidate SID ≥14 days against archives (query `wazuh-alerts-*` + EVE logs).
- Weekly FP review: operator marks misfires; SID stays on shortlist only if FP <2% and no severity inflation.
- Decisions recorded as decision-register entries, not chat history.

### 3.3 Rate Limits
- Workflow-level dedup (sid+src+dst+60s bucket, phase38-75 stage 5).
- Cap: ≤20 IRIS alerts/hour per workflow; overflow → dead-letter counter, not silent drop.
- Wazuh-side integration filter level ≥7 to keep volume bounded.

### 3.4 Kill Switch
Immediate disable path (no Shuffle dependency):

```bash
# comment out the suricata/shuffle integration block in ossec.conf on master
docker exec multi-node-wazuh.master-1 sed -i 's/<integration>/<!--DISABLED <integration>/' /var/ossec/etc/ossec.conf
docker restart multi-node-wazuh.master-1
```

Target kill-switch time: <5 minutes, documented in runbook `ops/runbooks/alert-routing.md`.

### 3.5 Rollback
- Disable integration (§3.4).
- Set workflow status test/draft in UI.
- Re-import pre-change export from `ops/evidence/p38-workflow-export/`.
- Verify zero new executions after switch-off (`executions` API delta check).

### 3.6 Client-Impact Assessment
- IRIS alert creation writes into customer 1 (IrisInitial) — confirm acceptable volume and labeling (`[P38TEST]` prefix dropped only at go-live).
- Confirm no client-visible reporting depends on routed counts until stability window (30 days, <0.1% dead-letter rate) completes.

### 3.7 Review Date
Re-evaluation at **Phase 39** or immediately upon closure of B1–B4, whichever first.

## 4. What This Decision Does NOT Block

- Hardening execution (phase38-73) — explicitly encouraged next.
- Field-error fix (phase38-78) — independent and already applied.
- Continued test-only executions of existing workflows.
