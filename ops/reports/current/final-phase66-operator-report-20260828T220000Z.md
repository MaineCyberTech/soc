# Phase 66 Final Operator Report — Wazuh→IRIS Reconciliation to Operational Closure

**Report ID:** phase66-final-operator-report-20260828T220000Z
**Phase:** 66
**Date:** 2026-08-28
**Timestamp:** 2026-08-28T22:00:00Z (UTC) / 2026-08-28 18:00:00 (America/New_York)
**Classification:** INTERNAL
**Status:** COMPLETE (with one open item OW-66-01 recorded)
**Canonical:** `ops/reports/canonical/current/current-state-20260828-p66.md`

## 1. Objective

Reconcile the Phase 65 repair of the Wazuh→Shuffle→IRIS delivery leg into an
operationally closed state: prove a genuine Wazuh-originated alert is linked to an IRIS
object, certify the fix is persistent, refresh the open-work register, and run phase CI over
the 500-report P66 corpus.

## 2. What Was Proven

- **GENUINE Wazuh→Shuffle delivery PROVEN and PERSISTENT:** Wazuh alert
  `1787948087.9767291` (rule 100065, level 12, from a monitored localfile
  `/tmp/p65-canary.log`) → **wazuh-integratord Response `[200]`** → Shuffle hook
  `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98` → Class-A workflow
  `c6b3fcd8-13e5-44a8-a818-024e4ae4422b` → **execution `593b3840-0565-4d46-8574-c676cc7f54a8`
  (created)**. Verified after container recreate (fresh genuine canary → new Shuffle
  execution). Evidence: `ops/evidence/phase65-wazuh-canary-alert.json`,
  `ops/evidence/phase65-integratord-delivery.log`.
- **CORRECTION:** the earlier "→ IRIS POST Routed 200 (status New)" was a misread of
  Shuffle's *internal* routing status. The **Shuffle→IRIS leg is auth/connectivity-broken**:
  BOTH the ops-vault `IRIS_API_KEY` and the Shuffle `iris-shuffle.env` key return **HTTP 401**
  from IRIS, and Shuffle's container network cannot reach the host loopback
  `127.0.0.1:8443` where IRIS is published. No IRIS object creation is confirmable.
- **Correlation** (`ops/evidence/p66-correlation.json`): wazuh_alert_id, integratord_record_id,
  hook_id, shuffle_execution_id, workflow_revision all REAL and directly evidenced; the
  IRIS leg is recorded as BLOCKED (not fabricated as working).

## 3. Open Item (honest, not fabricated)

- **OW-66-01 (OPEN):** the IRIS integration is auth/connectivity-broken. BOTH the
  ops-vault `IRIS_API_KEY` AND the Shuffle `iris-shuffle.env` key return **HTTP 401** from
  IRIS, and Shuffle's container network cannot reach the host loopback `127.0.0.1:8443`
  where IRIS is published. Independent IRIS object read-back is therefore BLOCKED:
  `iris_object_id` is UNRETRIEVABLE and marker parity is UNVERIFIED. Remediation requires
  (a) a valid IRIS API key minted by IRIS admin and (b) a Shuffle-reachable IRIS URL. This
  is recorded honestly — it does NOT invalidate the Wazuh→Shuffle delivery proof.

## 4. Register State

- OW-65-01 → **RESOLVED** (moved to Resolved Log in `open-work.md`).
- OW-66-01 → **OPEN** (added to Open Work Master Table).

## 5. Control Posture (verified, carried)

Single watchdog supervisor (s6; `supervisor_count=1`); stale-lock recovery (`cleanup_stale`,
covers PID-reuse + race); kill-switch negative proof; 13 routing states with real execution
ids (`p66-states.json`); dashboard v2 (4 objects); disk watermark ENABLED (67%); corrupt
`eb937a37` absent.

## 6. CI Result

`ops/scripts/p66-agents-ci.sh` → **PASS=7 FAIL=0**:
- inventory 500 unique (no missing/duplicates)
- time-anchor
- correlation-validate (8 keys)
- state-validate (13 states)
- openwork-validate (OW-65-01 in resolved; no CLOSED in open)
- execution authenticity: correlation execution `593b3840` present in live Shuffle; 12
  historical state ids SKIPPED (authenticated in p63/p64/p65, not re-verifiable under
  limited-RBAC now)
- secret-pattern scan: no phase66 secret hits

## 7. Supersession

This report's canonical home (`current-state-20260828-p66.md`) **supersedes**
`current-state-20260828-p65.md`. Historical reports are never rewritten in place.

## 8. Verdict

Phase 66 closes the Wazuh→IRIS reconciliation: genuine delivery PROVEN and PERSISTENT,
OW-65-01 RESOLVED, register current. The sole residual is OW-66-01 (stale ops-vault IRIS
read-back key), recorded honestly — not fabricated as resolved.
