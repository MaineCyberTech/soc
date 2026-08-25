# Phase 38 Decision Ledger

**Report ID:** phase38-52-generate-decision-ledger
**Phase:** 38
**Title:** Decision History — Type, Description, Supersession, Effect-Today (Markdown + JSON)
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-52-generate-decision-ledger.md`
**Retention Class:** LONG
**Supersedes:** `phase38-15-decision-history.md` draft (retained as history)
**Owners:** ["ops-reports-owner", decision owners per record]

---

## 1. Conventions

Decision types: `approval` · `deferral` · `retirement` · `policy` · `scope`. Where no formal approval artifact exists (MIS-38-05), the record says so explicitly — commit messages and report prose are treated as evidence-of-decision, not evidence-of-approval. `effect_today` states what the decision means for the 2026-08-25 verified state.

## 2. Markdown Ledger

| ID | Type | Decision | Date | Source | Approval record | Superseded by | Effect today |
|---|---|---|---|---|---|---|---|
| DEC-38-001 | retirement | Retire SecurityOnion packet scanning; stop SO forward path (healthcheck 0 FAIL, CI PASS) | 2026-08-24→25 (P31) | git 43c4bf1 | ABSENT (commit-only) | — | SO out of packet path; Suricata-minimal owns it; retirement narrative rests on commits |
| DEC-38-002 | approval+scope | Select Suricata-minimal as packet engine; SPAN-gated production benchmarking (<2GiB ceiling) | 2026-08-24 (P31) | git 98d5baf, 43c4bf1 | ABSENT | — | Active engine: agent 016 forwards eve.json; 433 alerts indexed |
| DEC-38-003 | approval | Approve canary SID 2027967 for E2E detection proof | 2026-08-25 (P34) | `phase34-08-canary-approval.md` | **PRESENT** (the model record) | — | Canary proven E2E (synthetic + real SPAN alert, P35); basis for future routing approvals |
| DEC-38-004 | policy | Apply Zeek hard guardrails: rate-limit + kill switch (tested) | 2026-08-22 (P26) | git cb8ca76 | ABSENT | — | Zeek constrained; exec-bit cron incident later closed in P28 |
| DEC-38-005 | approval | Enable Zeek Class A routing: Wazuh integration rule_id 122001-122003 → Shuffle webhook → IRIS | 2026-08-22 (P25) | git 96970c4, 508b793 | "approved" asserted in commit; artifact ABSENT | — | Origin of real Shuffle execution stream (68 FINISHED OpenCanary L12 runs confirmed today) |
| DEC-38-006 | deferral | Defer production alert routing in Shuffle (observe-only; gate conditions listed) | 2026-08-25 (P33→P35 chain) | git 79f6cbe, cbcca53; `phase37-32-routing-decision.md` | ABSENT | — | No formally approved routing despite real traffic flowing informally; BCK-38-102 open |
| DEC-38-007 | policy (misattributed remediation) | Raise `analysisd.decoder_order_size` to 512 to eliminate field errors | 2026-08-25 AM (P36) | `phase36-32`; `phase36-75:24-30` | ABSENT | **DEC-38-013** (mechanism correction) | Knob staged but irrelevant; errors continue ~150/min; resolution claims retracted (CON-38-01/02) |
| DEC-38-008 | scope (unrecorded change) | Shuffle frontend exposure — binding such that UI listens on all interfaces ("was 127.0.0.1" implies deliberate change) | unknown (≤P36) | `phase36-75:21` parenthetical; listener audit | **ABSENT — no authorizing record at all** | Pending reversal via ACT-38-001 | P0 exposure: 0.0.0.0:3001, no TLS/firewall |
| DEC-38-009 | approval | Pin 8 mutable image refs to digests in compose + runtime | 2026-08-24 (P29) | git bbe14c8, c726182, 8e37ae9 | recorded as "approved" in P29 approvals commit; standalone artifact ABSENT | — | Supply-chain posture hardened; pins active |
| DEC-38-010 | approval+policy | Release v1.3.0 (tag 790968b8, release id 375979989, asset da72bde4…) | 2026-08-24 (P29) | git 8e37ae9 | ABSENT | — | Current release; hash VERIFIED in-session; on-box archival missing (MIS-38-04) |
| DEC-38-011 | policy | Indexer rotation attempted inside maintenance window; rolled back cleanly | 2026-08-24 (P29) | git 8e37ae9 | maintenance-window record implied only | — | Rotation NOT in effect; cluster unchanged (GREEN/3n) |
| DEC-38-012 | policy | Memory stabilization: swappiness 60→10 after stale-swap diagnosis | 2026-08-24 (P30) | git 0c24353 | ABSENT | — | In effect; swap still 64% — monitored, not resolved |
| DEC-38-013 | policy (corrective) | Reattribute field errors to indexer mapping limit; prescribe index-template total_fields.limit increase or source reduction | 2026-08-25 (P38) | phase38-25; CON-38-01 | N/A (analysis correction) | Supersedes DEC-38-007's rationale | Fix path corrected; implementation pending (ACT-38-002) |
| DEC-38-014 | scope+policy | Capture workflow exports as versioned evidence bundle | 2026-08-25 (P37) | `phase37-10-workflow-export.md`; exports on disk | ABSENT | Defect registered: trailing HTML comment breaks strict JSON; sha256 sidecars absent (MIS-38-06) | Exports usable read-only; re-export required for automation |
| DEC-38-015 | deferral | Defer Shuffle hardening execution (plan authored, not applied) | 2026-08-25 (P37/P38) | generated/phase38-73 | ABSENT | — | Exposure persists; ACT-38-001 remains open P0 |
| DEC-38-016 | deferral | Defer agent 013 recovery beyond marker/cert cycles; keep disconnected-not-retired status | 2026-08-25 (P36/P37) | `phase37-51-agent013-status.md` | ABSENT | — | Fleet at 8 active; 013 SAMSUNG disconnected; BCK-38-104 |

## 3. JSON Block

```json
{
  "ledger_id": "DEC-38",
  "generated": "2026-08-25T20:50:00Z",
  "decisions": [
    {"id":"DEC-38-001","type":"retirement","description":"Retire SO packet scanning","date":"2026-08-24","source":"git 43c4bf1","approval":"ABSENT","superseded_by":null,"effect_today":"Suricata-minimal owns packet path"},
    {"id":"DEC-38-002","type":"approval","description":"Select Suricata-minimal, SPAN-gated <2GiB","date":"2026-08-24","source":"git 98d5baf","approval":"ABSENT","superseded_by":null,"effect_today":"Active engine; 433 alerts indexed"},
    {"id":"DEC-38-003","type":"approval","description":"Approve canary SID 2027967","date":"2026-08-25","source":"phase34-08-canary-approval.md","approval":"PRESENT","superseded_by":null,"effect_today":"Canary E2E proven"},
    {"id":"DEC-38-004","type":"policy","description":"Zeek hard guardrails rate-limit + kill switch","date":"2026-08-22","source":"git cb8ca76","approval":"ABSENT","superseded_by":null,"effect_today":"Zeek constrained"},
    {"id":"DEC-38-005","type":"approval","description":"Enable Zeek Class A routing rule 122001-122003 -> Shuffle -> IRIS","date":"2026-08-22","source":"git 96970c4","approval":"asserted-in-commit, artifact ABSENT","superseded_by":null,"effect_today":"Source of 68 real Shuffle executions"},
    {"id":"DEC-38-006","type":"deferral","description":"Defer production Shuffle routing","date":"2026-08-25","source":"phase37-32-routing-decision.md","approval":"ABSENT","superseded_by":null,"effect_today":"Routing informal-only despite real traffic"},
    {"id":"DEC-38-007","type":"policy","description":"decoder_order_size=512 as field-error fix","date":"2026-08-25","source":"phase36-32","approval":"ABSENT","superseded_by":"DEC-38-013","effect_today":"Knob staged, irrelevant; errors ~150/min"},
    {"id":"DEC-38-008","type":"scope","description":"Shuffle frontend all-interface exposure (unrecorded)","date":"unknown<=P36","source":"phase36-75-final-report.md:21","approval":"ABSENT - no authorizing record","superseded_by":"pending ACT-38-001","effect_today":"P0 exposure 0.0.0.0:3001"},
    {"id":"DEC-38-009","type":"approval","description":"Pin 8 image refs to digests","date":"2026-08-24","source":"git 8e37ae9","approval":"recorded-in-commit, artifact ABSENT","superseded_by":null,"effect_today":"Pins active"},
    {"id":"DEC-38-010","type":"approval","description":"Release v1.3.0 (tag 790968b8, asset da72bde4...)","date":"2026-08-24","source":"git 8e37ae9","approval":"ABSENT","superseded_by":null,"effect_today":"Current release; on-box archival missing"},
    {"id":"DEC-38-011","type":"policy","description":"Indexer rotation attempted, rolled back cleanly","date":"2026-08-24","source":"git 8e37ae9","approval":"implied maintenance window","superseded_by":null,"effect_today":"Rotation not in effect"},
    {"id":"DEC-38-012","type":"policy","description":"swappiness 60->10","date":"2026-08-24","source":"git 0c24353","approval":"ABSENT","superseded_by":null,"effect_today":"In effect; swap 64% watched"},
    {"id":"DEC-38-013","type":"policy","description":"Corrective: field errors are indexer mapping limit; template/source fix prescribed","date":"2026-08-25","source":"phase38-25","approval":"N/A corrective","superseded_by":null,"effect_today":"Fix path corrected; ACT-38-002 pending"},
    {"id":"DEC-38-014","type":"scope","description":"Workflow exports as versioned evidence","date":"2026-08-25","source":"phase37-10-workflow-export.md","approval":"ABSENT","superseded_by":null,"effect_today":"Exports defective (trailing comment, no sidecars)"},
    {"id":"DEC-38-015","type":"deferral","description":"Defer Shuffle hardening execution","date":"2026-08-25","source":"generated/phase38-73","approval":"ABSENT","superseded_by":null,"effect_today":"Exposure persists (ACT-38-001)"},
    {"id":"DEC-38-016","type":"deferral","description":"Keep agent 013 disconnected-not-retired","date":"2026-08-25","source":"phase37-51-agent013-status.md","approval":"ABSENT","superseded_by":null,"effect_today":"Fleet 8 active; BCK-38-104"}
  ]
}
```

## 4. Governance Note

14 of 16 decisions lack a formal approval artifact; only DEC-38-003 meets the standard set by `phase34-08-canary-approval.md`. Retroactive ratification queue lives in REM-38-06 (phase38-54). Until ratified, certification narratives must qualify governance sections accordingly.
