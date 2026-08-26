# Phase 39 Packet Workflow Replay Protocol — REPLAY-39-02

**Report ID:** phase39-40-packet-workflow-replay  
**Phase:** 39  
**Title:** Three-Identical-Events Replay Protocol (Dedup Semantics, Expectations, and Execution Procedure) — BLOCKED-WITH-PROTOCOL-READY  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:00:38Z  
**Classification:** INTERNAL  
**Status:** BLOCKED-WITH-PROTOCOL-READY  
**Record ID:** REPLAY-39-02  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-40-packet-workflow-replay.md`

---

## 1. Blocker

Workflow `wazuh-suricata-packet-to-iris` does not exist on the platform — creation
attempt in WF-39-02 returned `401 Unauthorized` (API auth gate; UI path pending
operator). No replay can execute against a non-existent workflow. This report fixes
the protocol so execution is mechanical once the import lands.

## 2. Test Event

Single canonical Suricata EVE-shaped event, POSTed 3× identically to the workflow's
webhook trigger:

```json
{"timestamp":"<now>","event_type":"alert",
 "src_ip":"10.66.0.10","dest_ip":"172.20.0.7",
 "alert":{"signature_id":2027967,"severity":2,"signature":"CANARY test sig"},
 "tags":["p39-test"]}
```

(No `synthetic` tag — that is a separate isolation case, §5.)

## 3. Expected Outcomes (acceptance table)

| # | Expectation | Pass condition |
|---|---|---|
| E1 | 3 executions recorded | executions API shows exactly 3 new runs |
| E2 | Exactly 1 routed | one run reaches `done-routed-log`; IRIS shows exactly ONE `[p39-test] suricata sid 2027967` alert |
| E3 | 2 suppressed | two runs terminate at `duplicate-suppressed-logonly` |
| E4 | Single dedup key | all three runs reference identical key `2027967-10.66.0.10-172.20.0.7-epoch300` |
| E5 | TTL 300 s | re-triggering the same event >300 s later routes again (new bucket) |
| E6 | Zero counter contamination | datastore counter increments exactly once per routed bucket; suppressed runs add nothing |

## 4. Execution Procedure

1. Import artifact (`phase39-39` §5) → confirm canvas + `status="test"`.
2. Capture webhook URL from trigger.
3. `for i in 1 2 3; do curl -s -XPOST <hook_url> -d @event.json; sleep 2; done`
4. Verify E1–E4 immediately via executions API + IRIS psql query.
5. Wait ≥300 s; send event #4 for E5/E6.
6. Record results into the successor of this report; attach execution IDs.

## 5. Companion Micro-Cases (same session)

| Case | Input | Expected |
|---|---|---|
| Synthetic isolation | same event + `"tags":["synthetic"]` | sink branch only; ZERO IRIS calls even though sid is allowlisted |

## Verdict

**BLOCKED-WITH-PROTOCOL-READY.** Unblocks automatically on workflow import +
webhook capture; no further design work required.
