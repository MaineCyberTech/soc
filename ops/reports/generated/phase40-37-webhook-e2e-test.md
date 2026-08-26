# Phase 40 Webhook E2E Test — Marked-Event Proofs

**Report ID:** phase40-37-webhook-e2e-test
**Phase:** 40
**Title:** Marked-Event End-to-End Proofs — Hook Probe f28cb7e2, Manual-Fire 46b8fe3d, Full-Chain Canary E2E-007 with Exact IDs at Every Hop
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:11:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-37-webhook-e2e-test.md`

---

## 1. Method

Three escalating marked-event proofs against workflow `eb937a37…`. All events carry
`MCT_SYNTHETIC=true` + `MCT_TEST_ID` (+ `MCT_TEST_ONLY` where sensor-injected);
no production contamination (IRIS rows are titled "Wazuh flow alert (Class A)" per
the existing notify-only template and carry test markers in payload).

## 2. Proof 1 — Direct hook probe (post hooks-doc registration)

```
POST http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-5244-46dc-95ff-62ad4c681322
-> {"success": true, "execution_id": "f28cb7e2…"}
```

| Hop | ID | Evidence |
|---|---|---|
| Execution | `f28cb7e2` FINISHED, source=webhook, started 1787705833 = 2026-08-26T00:57:13Z | executions API |
| IRIS row | **alert 40 @ 2026-08-26T00:57:16Z** | IRIS DB `alerts` table |

## 3. Proof 2 — MANUAL-FIRE-2 (post DNS fix)

Manual workflow execute after `docker network connect mct-security
multi-node-wazuh.master-1`; integrator-side manual fire returned HTTP 200.

| Hop | ID | Evidence |
|---|---|---|
| Execution | `46b8fe3d` FINISHED, source=webhook, started 1787706748 = 01:12:28Z | executions API |
| IRIS row | **alert 41 @ 2026-08-26T01:12:34Z**, HTTP action success | IRIS DB |

## 4. Proof 3 — Full-chain canary E2E-007 (the FINAL PROOF)

Exact IDs at every hop:

| # | Hop | Value |
|---|---|---|
| 1 | Sensor EVE flow_id | **999000777** |
| 2 | Signature / marker | sid **2027967** `[MCT-CANARY-P40-E2E-007]`, `MCT_SYNTHETIC=true`, `MCT_TEST_ID=P40-WEBHOOK-E2E-007`, pcap_cnt=7 |
| 3 | Agent → manager | agent **016** (`mct-packet-sensor`) → master analysisd |
| 4 | Wazuh alert id | **1787707735.1208554** @ 2026-08-26T01:28:55.267Z, rule 86601 lvl 3, groups [ids, suricata] |
| 5 | Indexer doc | `wazuh-alerts-4.x-2026.08.26/_doc/EMavO6ABpixMBj2JQ1tg` (found) |
| 6 | integratord file write | `/tmp/shuffle-1787707735-1303758191.alert was written.` |
| 7 | Workflow execution | **b6d07492** FINISHED src=webhook started 1787707735 = 01:28:55Z |
| 8 | Shuffle→IRIS HTTP | success 200 |
| 9 | IRIS row | **alert 42 @ 2026-08-26T01:28:57Z** (~2 s latency from alert id timestamp) |

Embedded integratord debug (master ossec.log 01:28:55Z, trimmed):

```
DEBUG: File /tmp/shuffle-1787707735-1303758191.alert was written.
DEBUG: # Running Shuffle script
DEBUG: # Sending message {"severity": 1, … "title": "Suricata: Alert - ET MALWARE
LiLocked [MCT-CANARY-P40-E2E-007]", … "id": "1787707735.1208554", "all_fields": {…
"data": {"flow_id": "999000777", … "signature_id": "2027967", … "MCT_SYNTHETIC":
"true", "MCT_TEST_ID": "P40-WEBHOOK-E2E-007", "MCT_TEST_ONLY": "true"}}} to Shuffle server
```

## 5. Contamination Check

- All three proofs carry synthetic markers end-to-end (visible at hop 2/9 payloads).
- IRIS rows created = 3 (alerts 40–42), all notify-only Class-A template; no cases
  opened; production counters untouched (AGENTS.md isolation rule honored).
- Post-proof observation window shows only fail-closed skips for non-lane traffic
  (phase40-34 §6).

## 6. Verdict

**MARKED-EVENT E2E: VERIFIED — FULL CHAIN PROVEN** (sensor → analysisd → integratord
→ webhook → workflow → IRIS) with exact IDs at every hop and ~2 s delivery latency.
