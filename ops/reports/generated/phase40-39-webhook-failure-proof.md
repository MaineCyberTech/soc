# Phase 40 Webhook Failure Proof — FAIL-40-01

**Report ID:** phase40-39-webhook-failure-proof
**Phase:** 40
**Title:** Failure Proofs FAIL-40-01 — DNS Isolation, Wrong Hook URL, Fail-Closed Skipping, FINISHED≠Delivered Trap, Recovery Behavior, No-Retry Limitation
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:14:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-39-webhook-failure-proof.md`

---

## 1. Purpose

Documents the failure modes DEMONSTRATED (not theorized) during the arc, each with
embedded live evidence, plus recovery behavior and the accepted no-retry limitation.

## 2. FAIL-40-01(a) — DNS isolation failure (reproduced, then fixed)

After adding the integration to master, integratord's manual fire failed. Embedded
evidence from master `/var/ossec/logs/integrations.log`:

```
HTTPConnectionPool(host='shuffle-backend', port=5001): Max retries exceeded with url:
/api/v1/hooks/webhook_eb937a37-5244-46dc-95ff-62ad4c681322 (Caused by
NameResolutionError("HTTPConnection(host='shuffle-backend', port=5001):
Failed to resolve 'shuffle-backend' ([Errno -2] Name or service not known)"))
```

Root cause: manager container lived only on `multi-node_default` and could not
resolve mct-security service names. Fix: `docker network connect mct-security
multi-node-wazuh.master-1` → next manual fire HTTP 200 (exec 46b8fe3d). The error
line above IS the failure-mode demonstration: lane fails LOUD and log-only,
detection unaffected.

## 3. FAIL-40-01(b) — Wrong hook URL (stale-block failure class)

The pre-arc stale commented block targeted `webhook_24636c49…` — the TRIGGER-node id,
not the workflow id. That URL class cannot resolve: hooks lookup by workflow-id
misses, backend answers during the ops window:

```
Failed getting hook … 404 hooks index        (shuffle-backend log, ops window)
```

Demonstrated consequence chain: hook POST → no execution created. Fixed by pointing
the config at `webhook_eb937a37…` AND registering `hooks/_doc/eb937a37…` (the second,
distinct failure — missing datastore doc — proven in phase40-36 §2).

## 4. FAIL-40-01(c) — Fail-closed semantics (no group match → no send)

Live debug from master ossec.log during post-proof observation (non-lane alerts):

```
2026/08/26 02:00:38 wazuh-integratord[15315] integrator.c:240 at OS_IntegratorD():
DEBUG: Skipping: Group doesn't match.
(repeated through 02:00:44Z; also the exact skip class that blocked the earlier
rule_id-only filter despite rule 86601 being present)
```

Semantics: unmatched alerts are skipped BEFORE any network call; nothing is queued;
nothing half-sent. Malformed payloads are logged-and-skipped by the same path.
Fail-closed verified both as designed behavior AND as the accidental early defect.

## 5. FAIL-40-01(d) — FINISHED ≠ delivered trap

A workflow can reach status FINISHED while its IRIS HTTP action actually failed.
The monitor distinguishes outcomes by PARSING stored action results — logic of
record in `ops/scripts/p39-iris-delivery-check.sh`:

```python
if rrj.get("status") == 200 and isinstance(body, dict) and body.get("status") == "success":
    ok = True                      # DELIVERED
elif rrj.get("success") is False or "success" in str(rrj.get("exception","")).lower():
    bad = True                     # FAILED
...
elif st == "ABORTED": A += 1       # ABORTED counted separately
```

Today's reading proves the classes coexist:

```
eb937a37 executions=77 delivered=39 failed=31 aborted=3 other=4
== ALERT-39-01 SUMMARY: delivered=40 failed=31 aborted=3 other=4 ==
```

31 historical executions are FINISHED-classified failures that ONLY this parsing
exposes — the trap is real and monitored.

## 6. Queue/retry — accepted limitation

Wazuh integratord has **no retry queue**: one POST per matching alert, failures land
in `integrations.log`, detection never blocks. Accepted as a documented limitation
with compensation = ALERT-39-01 monitoring (execution-level accounting + alerting on
FAILED growth). Risk window: an outage lasting exactly between two matching alerts
loses that event's delivery (index copy still exists; replay possible manually).

## 7. FAIL-40-01(e) — Recovery without manual replay

After EACH defect fix the chain resumed naturally, with no re-injection of earlier
stages: hooks-doc registration → probe executed immediately (f28cb7e2); network
connect → next manual fire succeeded (46b8fe3d); filter fix on group semantics →
the NEXT naturally flowing alert (E2E-007) fired through without any replay of the
sensor or analysisd stages. Recovery behavior: **VERIFIED three times in one session.**

## 8. Verdict

**FAIL-40-01: COMPLETE — five failure/recovery facets demonstrated with embedded
live evidence; no-retry limitation documented and monitor-compensated.**
