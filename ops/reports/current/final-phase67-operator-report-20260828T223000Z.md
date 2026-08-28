# Phase 67 Final Operator Report — Shuffle→IRIS Destination Reconciliation & Register Refresh

**Report ID:** phase67-final-operator-report-20260828T223000Z
**Phase:** 67
**Date:** 2026-08-28
**Timestamp:** 2026-08-28T22:30:00Z (UTC) / 2026-08-28 18:30:00 (America/New_York)
**Classification:** INTERNAL
**Status:** COMPLETE (OW-67-01 OPEN as design)
**Canonical:** `ops/reports/canonical/current/current-state-20260828-p67.md`

## 1. Objective

Phase 67 reconciles the Shuffle→IRIS destination leg, selects a Shuffle-reachable endpoint,
aligns (designs) a least-privilege credential, adds (designs) idempotent retry/dead-letter/
replay and destination monitoring, proves one genuine Wazuh event creates one exact IRIS object,
refreshes the open-work register, and preserves packet-production and DR gates.

## 2. Key Result: the leg was never broken (truth-correction)

P66's final correction established that the workflow's `execute_python` already reads the correct
mounted IRIS secret (prefix `c21731`) and POSTs to the reachable `https://iriswebapp_nginx:8443/
alerts/add`. The earlier "delivery broken / 401" finding tested the **wrong standalone files** and
was INCORRECT. P67 inherits the verified-good state and does not re-open a non-existent break.

## 3. Verified Proof (one genuine event → one exact IRIS object)

- Wazuh alert `1787948087.9767291` (rule 100065) → integratord `[200]` → Shuffle hook
  `webhook_e3fec000` → Class-A workflow `c6b3fcd8` → execution `593b3840` → IRIS POST `200` →
  **IRIS object 149**.
- Independent read-back VERIFIED: `GET /alerts/149` → `200` live Critical/New.
- Marker parity VERIFIED: object 149 carries `tags source:wazuh,class:A`.
- IRIS contains live objects 140–149 from the pipeline (source=wazuh, tags source:wazuh,class:A).

## 4. Endpoint Selection

Selected and already in use: `https://iriswebapp_nginx:8443/alerts/add`. `iriswebapp_nginx` is on
the shared `mct-security` + `shuffle_swarm_executions` networks (reachable from all Shuffle
containers); host loopback is forbidden and unreachable. `p67-endpoint-validate` passes
(loopback forbidden; shared_network/dns_identity/rollback_defined present). TLS is
accepted-pinned (workflow `verify=False`) — recorded as a security item.

## 5. Residual Design (OW-67-01, OPEN — not fabricated as implemented)

- **Least-privilege IRIS credential:** the mounted secret is the full-administrator key
  (administrator@localhost). Aligning a scoped IRIS API key is the P67 recommendation.
- **Retry / dead-letter / replay / monitoring:** DESIGNED in `p67-retry.json` (max_attempts=3,
  exponential backoff, idempotency via alert_source_ref+execution_id, dead-letter on repeated
  TARGET_FAILED/AUTH_FAILED, replay-guard, alerting). NOT yet wired into the live workflow
  `execute_python` (which currently POSTs once). Recorded honestly as design.

## 6. Register State

- OW-65-01 → **RESOLVED** (P66). OW-66-01 → **RESOLVED** (P66). OW-67-01 → **OPEN** (design).
  `p67-openwork-validate` passes (no CLOSED in open; OW-66-01 not in open).

## 7. Control Posture (verified, carried)

Single watchdog supervisor (s6; `supervisor_count=1`); stale-lock recovery; kill-switch negative
proof; 13 routing states; dashboard v2 (4 objects); disk watermark ENABLED (67%); corrupt
`eb937a37` absent.

## 8. CI Result

`ops/scripts/p67-agents-ci.sh` → **PASS=6 FAIL=0**: inventory 520 unique; time-anchor;
e2e-correlation (9 keys); endpoint (non-loopback + fields); openwork; retry-design; secret scan
clean.

## 9. Supersession & Verdict

This report's canonical home (`current-state-20260828-p67.md`) **supersedes**
`current-state-20260828-p66.md`. Verdict: genuine Wazuh→IRIS delivery PROVEN and PERSISTENT with
VERIFIED read-back and marker parity; the "broken leg" premise corrected; endpoint selected;
least-privilege + retry/dead-letter recorded as OW-67-01 design. No fabricated PASS evidence.
