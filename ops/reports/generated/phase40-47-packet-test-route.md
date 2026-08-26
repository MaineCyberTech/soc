# Phase 40 Packet Test-Route Control — Packet-Route-40-01

**Report ID:** phase40-47-packet-test-route
**Phase:** 40
**Title:** Test-Route Design — Synthetic/Allowlisted-SID-Only Destination (IRIS Notify With p40-test Tag), Production Prohibition Until Certification, Kill-Switch Points — BLOCKED-RUNTIME
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:34:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-RUNTIME
**Record ID:** PACKET-ROUTE-40-01
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-47-packet-test-route.md`
**Design anchor:** `ops/evidence/p39-workflow-export/packet-workflow-import.json` (sha256 `8242145e…37fc`)

---

## 1. Blocker (explicit)

Workflow not imported (IMP-40-01); no packet event has ever been routed anywhere.
Destination design, admission rules, and kill switches are pre-committed.
**No simulated PASS.**

## 2. Control Design — As Frozen in the Artifact

Node `iris-test-route-p39tag` (`bf4ba8f5…`, HTTP app `post_request`):

| Parameter | Verbatim value |
|---|---|
| url | `https://iriswebapp_nginx:8443/alerts/add` |
| body | `{"alert_title": "[p39-test] suricata sid ${normalize-fields.sid}", "alert_source": "suricata", "alert_source_ref": "${…sid}-${…src_ip}", "alert_source_event_time": "${…timestamp}", "alert_customer_id": 1, "alert_severity_id": 6, "alert_tags": "packet,suricata,sid:${…sid},class:packet,test:p39"}` |
| headers | `{"Authorization": "Bearer <FROM_DATASTORE>", "Content-Type": "application/json"}` — secret by reference; artifact contains NO credential value |
| verify / timeout | `false` / `10` |

Arms: success → `done-routed-log` (`ROUTED-OK sid=…`); failure →
`DEADLETTER-target-fail` (`P39DL TARGETFAIL sid=…`). No silent crash path.

## 3. Admission Rules (who may reach this destination)

An event reaches the route node ONLY after passing, in frozen topological order:
1. validation (43) — well-formed required fields;
2. synthetic isolation gate (44) — NOT tagged synthetic;
3. SID allowlist filter — frozen regex `^(2027967)$` (canary first).

⇒ **Approved synthetic-class events (which bypass 2–3 only to their own sink) and
allowlisted-SID real-shaped events are the sole routable classes.** Everything else
terminates at dead-letter/sink. P40 amendment: era tag updated p39→p40
(`[p40-test]` title prefix, `test:p40` tag) in the same import-session edit as
amendments A1–A10/§3 of reports 42–45; triple marker redundancy preserved.

## 4. Production Prohibition Until Certification

Until ROUT-PKT-40-01 flips from DEFERRED:
- destination remains **notify-only IRIS alerts** on internal test tenant
  (`alert_customer_id=1`, fixed severity id 6) — no escalation policies, no case
  conversion, no client-visible queue;
- the workflow's webhook MUST remain unbound from Wazuh integration blocks on BOTH
  cluster nodes (frozen trigger description states exactly this);
- any production-client action derived from this lane is prohibited;
- the high-severity webhook lane (production-proven today, E2E-007 chain,
  phase40-37/-40) is a SEPARATE workflow — this lane's controls neither inherit nor
  alter it.

## 5. Kill-Switch Points (any one, effective immediately)

| # | Switch | Layer | Precedent |
|---|---|---|---|
| K1 | Remove/disable the integration group-filter entry feeding this lane in ossec.conf (both nodes) | source | CFG block pattern, phase40-35 §8 rollback |
| K2 | Shuffle UI workflow toggle OFF | execution | ROUT-39-02 §6.2 |
| K3 | Delete/unbind the workflow webhook URL | ingress | ROUT-39-02 §6.3 |

K1/K2/K3 are independent; K2 requires no config change and is the default first move.

## 6. Proof Protocol (expectations only)

1. Single marked allowlisted canary POST → assert EXACTLY ONE new IRIS alert row:
   title `[p40-test] suricata sid 2027967`, tags contain `class:packet,test:p40`,
   customer 1, severity 6, source_ref `<sid>-<src>`; `done-routed-log` terminal.
2. Allowlist-miss probe (well-formed, sid 9999999) → zero IRIS calls; terminal at
   `DEADLETTER-malformed` (drop-with-record semantics).
3. Synthetic-tagged allowlisted probe → zero IRIS calls (sink per 44).
4. Kill-switch drill (K2): toggle OFF mid-sequence → next POST yields no execution;
   toggle ON → processing resumes; record toggle latencies.
5. Export executions + IRIS row dumps (psql) to
   `ops/evidence/p40-packet-runtime/route/`; hash into successor report.

## 7. Rollback

Route-level rollback = K1–K3 above plus optional deletion of the imported workflow
instance; evidence artifact and corpus unaffected. No Wazuh-side change exists to
undo until post-certification wiring, by construction.

## Verdict

**BLOCKED-RUNTIME.** Destination, admission rules, prohibition posture, kill
switches, and rollback fully specified from the frozen artifact + registered
amendments; zero runtime evidence exists today.
