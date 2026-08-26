# Phase 41 False-FINISHED Audit — Fresh Script Run Versus Stored Accounting

**Report ID:** phase41-37-false-finished-audit
**Phase:** 41
**Title:** FALSE-FIN-41-01 — Script Re-Run Fresh At 05:14Z: delivered=46 failed=31 aborted=3 Reconciles Exactly Against Logged Cycles; Zero New Failed-FINISHED Since 2026-08-10T19:24:16Z; Guard Definition Verified In Code
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:26:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-37-false-finished-audit.md`

---

## 1. What could go wrong, stated plainly

A "false FINISHED" is a terminal-FINISHED execution whose downstream actually
failed but which the accounting counts as DELIVERED. The P40-hardened monitor
guards this by construction: DELIVERED **only** when stored action results
contain an HTTP action parsed as `{"status": 200, body.status == "success"}`;
any result bearing `success": false` (ConnectionError/HTTP error class) forces
FAILED regardless of FINISHED status; ABORTED is its own class.

## 2. Fresh run [VERIFIED live]

Executed during this arc (05:14Z), not copied from the log:

```
eb937a37  executions=83  delivered=45  failed=31  aborted=3  other=4
e951db98  executions=1   delivered=1   failed=0   aborted=0  other=0
== ALERT-39-01 SUMMARY: delivered=46 failed=31 aborted=3 other=4 ==
EXIT=0
```

Reconciliation vs logged cycles (phase41-35): byte-identical structure; totals
match the latest logged era exactly. No drift between persisted accounting and
independent recomputation.

## 3. Failed-FINISHED currency check

`failed=31` is **unchanged** across all 14 overnight cycles and the fresh run.
Script-reported `last_failed_started_at=1786389856` converts to
**2026-08-10T19:24:16Z** — i.e., no new failed-FINISHED has been detected in
16 days, and certainly none today. The 31 are the historical Class-A DNS-failure
era population (evidence reuse in phase41-49), correctly still excluded from
delivered.

## 4. Guard liveness [VERIFIED]

Guard logic re-inspected in `p39-iris-delivery-check.sh` this session: flock
present; token sourced from `.env` and never printed; classification branches
(`ok`/`bad`) operate on parsed stored results, not workflow status alone.
Today's packet-lane API pull independently confirms the parser distinguishes
FAILURE-node executions (6 ABORTED identified with causal FAILURE nodes) from
clean FINISHED runs (report 46).

## 5. Verdict

False-FINISHED exposure: **none found**. Accounting current and reproducible.
This closes the false-FINISHED criterion feeding MON-CERT-41-01 (phase41-40).
