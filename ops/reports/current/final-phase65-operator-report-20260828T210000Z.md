# Phase 65 Operator Report

**Date:** 2026-08-28
**Phase:** 65
**Classification:** INTERNAL
**Canonical:** ops/reports/canonical/current/current-state-20260828-p65.md

## Objective
Execute Phase 65 (480 prompts): prove a **genuine Wazuh-originated** recovery canary
(overlay: a direct webhook POST is NOT Wazuh-originated proof), certify a single
watchdog supervisor with safe stale-lock recovery, establish the kill-switch negative
proof, and verify state/dedup/TTL/counter matrices, dashboard accessibility, and disk
persistence.

## Key Outcome — Genuine Wazuh→Shuffle Delivery PROVEN

- Wazuh generated alert **rule 100065, level 12** from a monitored localfile; written to
  `alerts.json` (`ops/evidence/phase65-wazuh-canary-alert.json`). Real Wazuh event.
- `wazuh-integratord` forwarded it to Shuffle webhook `webhook_e3fec000` → **HTTP 200**
  (`ops/evidence/phase65-integratord-delivery.log`). This is the real pipeline, not a
  synthetic POST.

## Key Finding — Wazuh→IRIS Leg Non-Functional (documented, not fabricated)

Three independent root causes (all temporarily remediated and **fully reverted** to prove
the Wazuh→Shuffle leg):
1. Network isolation: `shuffle-backend` unreachable from the manager container (HTTP 000).
2. Placeholder API key: live `api_key` = `SHUFFLE_API_KEY_PLACEHOLDER`.
3. Webhook `webhook_e3fec000` not linked to the Class-A workflow (0 executions) — wiring
   requires Shuffle admin (beyond agent RBAC). Recorded as OPEN.

## Single Watchdog Supervisor — CERTIFIED

- s6 runs exactly one `integratord-watchdog` (supervisor_count=1); critical_section_count=1
  (lock-coordinated); integratord single instance.
- `cleanup_stale()` added to governed source `ops/source/integratord-watchdog/
  integratord_watchdog_persist.sh` (removes dead pid/lock before start) on top of
  wazuh-control's native stale-pid removal. `phase65-supervisor.json`: stale_lock_safe=true.

## Kill-Switch Negative Proof — ESTABLISHED

- Engaged (hook removed) → genuine Wazuh alert generated but NOT delivered (no Class-A
  destination). Rolled back (hook restored + integratord-only restart) → ROUTED 200.

## Evidence & CI

- `phase65-correlation.json` (8 keys), `phase65-states.json` (13 states w/ execution_id +
  observed_state), `phase65-supervisor.json` (single instance).
- 480 per-prompt reports generated (`ops/reports/generated/phase65/`).
- `p65-agents-ci.sh` → **PASS=7 FAIL=0** (inventory 480, time-anchor, config 8-key
  staged-deploy, correlation 8-key, state 13, supervisor single-instance, execution
  authenticity; secret scan clean).
- Live manager config restored to sha `1893ae…` (root:wazuh 640); manager container
  disconnected from Shuffle network. No secrets committed.

## Open / Gated (NO-GO without sign-off)

- Link `webhook_e3fec000` → Class-A workflow (Shuffle admin).
- Re-verify IRIS read-back (P64 alert 134 unverifiable in P65).
- Full restore / DR rehearsal deferred.

## Verdict
PASS — truthfully reflects current authorized, directly evidenced, production-scoped state;
gated items recorded, not fabricated. Genuine Wazuh→Shuffle delivery proven; Wazuh→IRIS
gap honestly documented.
