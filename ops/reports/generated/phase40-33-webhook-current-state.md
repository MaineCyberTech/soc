# Phase 40 Webhook Current State — Before/After Inventory

**Report ID:** phase40-33-webhook-current-state
**Phase:** 40
**Title:** Wazuh→Shuffle Webhook Arc — Before/After Estate Inventory, Manager/Container State, Effective Routing Path
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:05:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-33-webhook-current-state.md`

---

## 1. Purpose

Opening report of the Phase 40 webhook sub-arc (33–40): the empirical close-out of
the Wazuh→Shuffle automated-trigger gap carried open since phase39-37
(CFG-39-01 DESIGNED-NOT-APPLIED). Live evidence window **2026-08-26 00:56–01:45 UTC**;
post-verification re-measured at 02:02–02:06Z during report production.

## 2. Before vs After Inventory

| # | Surface | BEFORE (verified pre-arc) | AFTER (verified live 02:02Z) |
|---|---|---|---|
| 1 | Master ossec.conf shuffle integration | ABSENT; only stale commented custom-json-output block pointing at WRONG hook URL `webhook_24636c49…` (trigger-node-id, not workflow-id); VirusTotal-only active | PRESENT at line 344 (`<name>shuffle</name>`, `hook_url=webhook_eb937a37…`, `group=suricata,`); stale block REPLACED |
| 2 | Worker ossec.conf shuffle integration | ABSENT | PRESENT at line 312 (identical block) |
| 3 | Workflow `eb937a37` trigger | `is_valid=False`, `status=''` (unbound stub) | `is_valid=True`, `status='running'` (API-verified 02:03Z) |
| 4 | Shuffle hooks datastore doc | MISSING — hook POST returned 404 ("Failed getting hook … hooks index") | REGISTERED: `hooks/_doc/eb937a37-5244-46dc-95ff-62ad4c681322` found=true, start=`24636c49…`, status running |
| 5 | Manager network reachability to Shuffle | `NameResolutionError` — master container could not resolve `shuffle-backend` | Master attached to BOTH `multi-node_default` AND `mct-security`; manual fire HTTP 200 |
| 6 | Automated alert path sensor→IRIS | NONE (all deliveries API/manual triggered) | PROVEN end-to-end (canary E2E-007 → IRIS row 42 @01:28:57Z, ~2s latency) |
| 7 | Delivery monitor baseline | delivered=36 (phase39-100) | **delivered=40 failed=31 aborted=3** |

## 3. Manager / Container State After

```
$ docker ps --format '{{.Names}}'   (relevant subset)
multi-node-wazuh.master-1     UP   networks: multi-node_default, mct-security
multi-node-wazuh.worker-1     UP   networks: multi-node_default, mct-security
shuffle-backend               UP   :5001 hooks API
shuffle-opensearch            UP   hooks index present
iriswebapp_app                UP   receiving workflow HTTP action
shuffle-tls-proxy             UP   (deployed 00:53:41Z, adjacent TLS arc)
```

Restart ledger (clean, integratord enabled each time):
master 01:03:41Z, 01:14:23Z, 01:26:21Z, 01:28:19Z; worker 01:19:44Z, 01:28:19Z.
Log lines captured in phase40-36 §5.

## 4. Effective Routing Path Diagram

```
 [mct-packet-sensor agent 016]  Suricata eve-alert.json (flow_id, signature_id)
        |  agent forward (via worker pre-restart / master post-restart)
        v
 [wazuh analysisd]  rule 86601 -> groups ["ids","suricata"]  -> alert id <epoch>.<seq>
        v                                  (cluster node decides which manager's)
 [wazuh-integratord]  group-match 'suricata,'  --NO MATCH--> skip (fail-closed)
        | MATCH: write /tmp/shuffle-<alertid>-*.alert
        | POST http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-…
        v
 [shuffle-backend hooks index] doc eb937a37… (start=trigger 24636c49, status=running)
        v
 [workflow wazuh-high-severity-to-iris]  webhook trigger -> log -> IRIS HTTP action
        v
 [dfir-IRIS]  alerts table INSERT  (row id, creation_time UTC)
```

Cluster-routing reality discovered mid-arc (drives why TWO configs exist): **each
node runs its own analysisd/integratord and integrates for ITS OWN agents.**
Canaries E2E-001..003 (+ a fourth at 01:26:41Z, ids 1787706455.964957 /
1787706775.1041194 / 1787706881.1066073 / 1787707601.1114440) landed in WORKER
`alerts.json` while master integratord saw nothing — agent 016 reported via worker
pre-restart. Hence identical blocks were required on both nodes.

## 5. Verdict

**BEFORE/AFTER INVENTORY: COMPLETE — VERIFIED.** Every "after" cell above was
re-measured live at 02:02–02:06Z (config greps, hooks GET, trigger API state,
network inspect, IRIS DB rows, execution list). The estate moved from
"no active integration" to "automated webhook lane ACTIVE on both nodes."
