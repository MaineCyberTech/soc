# Phase 40 Webhook Real-Alert Proof — Honest Disposition

**Report ID:** phase40-38-webhook-real-proof
**Phase:** 40
**Title:** Real-Alert Evidence Beyond Marked Events — Live Lane Continuity, Natural-Traffic Quiet Window, and What the Canary Does and Does Not Prove
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:12:30Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-38-webhook-real-proof.md`

---

## 1. Purpose

phase40-37 proves the chain with marked events. This report answers the harder
question honestly: **has a REAL, unmarked alert traversed the newly wired webhook
lane?** Verdict up front: **NO natural eligible alert has fired since wiring went
active (01:28Z); the marked canary is therefore the available real-pipeline
representative — real path, synthetic content. Claims below are labeled accordingly.**

## 2. Live lane continuity (VERIFIED)

The delivery monitor (`ops/scripts/p39-iris-delivery-check.sh`, re-run 02:02Z):

```
eb937a37  executions=77  delivered=39  failed=31  aborted=3  other=4
e951db98  executions=1   delivered=1   failed=0   aborted=0  other=0
== ALERT-39-01 SUMMARY: delivered=40 failed=31 aborted=3 other=4 ==
```

The **delivered=40** counter is execution-level, not alert-level. Its composition:
the 36 pre-existing deliveries (phase39-100) were API-triggered workflow runs whose
payloads included REAL honeypot alert content (the P38-era corroboration: 53×
level-12, 11× level-10 OpenCanary payloads transiting this same workflow), plus the
4 new deliveries this arc (f28cb7e2, 46b8fe3d, b6d07492 + one Class-B). So the lane's
ENDPOINT (IRIS delivery) has demonstrably carried real alert content historically —
but through manual/API triggering, not through the new automated integratord path.

## 3. Attempted direct verification of a post-wiring real alert (attempt documented)

Method per plan: pull newest `execution_source=webhook` executions and grep
`opencanary` in stored results (`all_fields`).

```
b6d07492 FINISHED webhook … (all recent webhook-src executions scanned)
-> zero occurrences of "opencanary" or "suricata" in any post-wiring execution payload
```

Cross-check against the indexer for any eligible natural source since wiring:

```
opencanary-group alerts after 2026-08-26T00:50Z : total 0
last real honeypot alert overall: 2026-08-25T07:12:57.701Z | rule 121009 | lvl 12 |
    "OpenCanary: RDP connection" | agent wazuh.master   (33 total all-time)
```

Conclusion of attempt: nothing to find — **no real eligible alert exists in the
post-wiring window**, so absence in payloads is genuine quiet traffic, not a
delivery defect.

## 4. Natural suricata lane quiet too (VERIFIED)

```
last natural rule-86601 alert WITHOUT MCT marker:
  2026-08-25T19:18:18.014Z | mct-packet-sensor |
  "Suricata: Alert - SURICATA Applayer Wrong direction first Data"
(4 total non-synthetic 86601-family alerts all-time)
```

Last natural packet-lane activity predates the wiring by ~6 hours; the lane has been
correctly silent (fail-closed skips only) rather than firing on noise.

## 5. What the marked canary does and does not prove

| Claim | Status |
|---|---|
| The AUTOMATED path (sensor eve-alert.json → agent 016 → master analysisd → master integratord → hook → workflow → IRIS) executes end-to-end without human API calls | **PROVEN** (E2E-007; every hop a real production component doing real work) |
| IRIS delivery works for content arriving via integratord | PROVEN (~2 s latency) |
| A natural (unmarked) suricata/OpenCanary alert will deliver | **INFERRED, not yet observed** — same code path as E2E-007 modulo payload contents; first natural hit will close this |
| Real honeypot content CAN reach IRIS through this workflow | VERIFIED HISTORICALLY (pre-wiring API-triggered runs, §2) |

Honesty statement: E2E-007 was injected at the sensor log layer and traversed the
genuine pipeline; it is NOT a naturally occurring detection and is not counted as one.

## 6. Carry-forward

First post-wiring natural alert (any class matching `suricata,`) should be captured
as closure evidence: correlate indexer alert id ↔ execution id ↔ IRIS row, append to
this report's successor or the Phase 41 review. Monitor remains
ALERT-39-01 (`p39-iris-delivery-check.sh`).

## 7. Verdict

**REAL-ALERT PROOF: PARTIAL — honestly bounded.** Automated chain proven with a
marked event over real infrastructure; natural-traffic confirmation pending first
real occurrence; historical real-content delivery through the workflow endpoint
stands from P38/P39 evidence.
