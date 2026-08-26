# Detection Audit DET-39-02

**Report ID:** phase39-93-detection-audit
**Phase:** 39
**Title:** Detection Audit DET-39-02 — Pipeline Integrity, Delivery Reliability, Packet Lane, Routing Certification, FP Quality Plan, Gaps
**Date:** 2026-08-25
**Timestamp:** 2026-08-26T00:24:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `ops/reports/generated/phase39-93-detection-audit.md`

---

## 1. Pipeline Integrity End-to-End

Sensor → agent016 → manager → indexer chain VERIFIED in earlier phase arcs (agent 016 v4.14.7 with
Suricata EVE feed; today's alert index holds **53,288 docs**, archive index 879,734 docs — both
counted live). NEW this arc: **IRIS lane restored** — alerts 37–39 era deliveries confirmed after
DNS remediation; consecutive-delivery proof on record (phase39-34), fresh counter rerun §2.

## 2. High-Severity Workflow Payload Quality

Payload classes remain dominated by OpenCanary honeypot hits: L12 (service-level) majority with
L10 minority — consistent with P38 enumeration (53×L12 / 11×L10 within the finished set). Payloads
carry real source telemetry; no synthetic contamination.

## 3. Delivery Reliability (fresh run)

```
$ bash ops/scripts/p39-iris-delivery-check.sh   (live rerun)
eb937a37 executions=74 delivered=36 failed=31 aborted=3 other=4
e951db98 executions=1  delivered=1  failed=0 aborted=0 other=0
ALERT-39-01 SUMMARY: delivered=37 failed=31 aborted=3 other=4
```

Lifetime delivered advanced 36→37 during this audit window (one more real alert landed mid-session)
— lane is live and healthy post-fix. Historical failure mass (31) predates DNS remediation and is
retained as honest history; current-window failure behavior: protocol-ready fail-closed
(phase39-41 malformed/failure tests).

## 4. Packet Workflow Status

Import-ready artifact exists and is hashed: `ops/evidence/p39-workflow-export/
packet-workflow-import.json`. Runtime remains **BLOCKED by routing decision** (phase39-42): no
packet-lane execution until webhook trigger wiring lands (BCK-38-006/007 sequence). Dedup/counter
semantics are defined-but-not-exercised; failure/replay paths protocol-ready from phase39-40/41
dry proofs.

## 5. Routing Certification State

**CONDITIONAL-PASS manual lane** (phase39-36): API-triggered manual runs certified end-to-end;
production auto-routing pending native-control gates + approval per AGENTS.md. No change today;
wiring config documented phase39-37 awaiting enablement decision.

## 6. False-Positive Quality

**UNMEASURED to date** — no systematic FP review has been performed on IRIS-landed alerts.
Proposal (adopted into open-work): weekly sampling review of IRIS alert titles vs source
references (OpenCanary log lines / Suricata signatures), tracked as a recurring SOAR-owner task;
first cycle scheduled with the next weekly reporting pass. Rationale: delivery correctness is now
proven; content relevance is the remaining quality axis.

## 7. Case Outcomes

Notify-only by design — IRIS receives alerts; case creation remains a deferred product decision
(pending FP-quality data from §6). No auto-case automation exists or ran this phase.

## 8. Gaps → Open-Work Refs

| Gap | Register ref |
|---|---|
| Auto-routing webhook enablement | BCK-38-006 |
| Packet workflow runtime promotion | BCK-38-007 |
| FP sampling program | OW item via phase39-88 §2 (new, SOAR owner) |
| Delivery-failure alerting schedule | OW-39-03 |
| Case-creation decision | deferred, gated on §6 first cycles |

Verdict: detection plane **HEALTHY on manual lane; two open promotion decisions** (auto-routing,
packet runtime) correctly gated rather than drifting.
