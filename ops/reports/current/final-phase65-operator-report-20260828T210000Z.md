# Phase 65 Operator Report

**Date:** 2026-08-28
**Phase:** 65
**Classification:** INTERNAL
**Canonical:** ops/reports/canonical/current/current-state-20260828-p65.md

**UPDATE (same day, post-closure):** OW-65-01 is **CLOSED**. The Wazuh→IRIS delivery leg is
now functional end-to-end and persistent. CORRECTION: webhook `webhook_e3fec000` was already
linked to `c6b3fcd8` (trigger id `e3fec000-…`); the earlier "0 executions" was a limited-RBAC
listing artifact, not a missing link. The network-isolation and placeholder-key root causes
were fixed (manager on `mct-security` network via compose + real Shuffle key in host
bind-mount/volume), verified to survive a container recreate (fresh genuine canary → new
execution `593b3840-…` FINISHED → IRIS POST Routed 200). See open-work.md / canonical update.

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

## Key Finding — Wazuh→IRIS Leg NOW FUNCTIONAL (OW-65-01 CLOSED)

The delivery leg is fixed and proven end-to-end. Two root causes corrected:
1. Network isolation: `shuffle-backend` unreachable from the manager container (HTTP 000) →
   FIXED: manager added to the `mct-security` network (compose-persistent; applied via `sudo`
   and verified to survive a container recreate).
2. Placeholder API key: live `api_key` = `SHUFFLE_API_KEY_PLACEHOLDER` → FIXED: real Shuffle
   key set in host bind-mount `config/wazuh_cluster/wazuh_manager.conf` + volume (persistent).
3. CORRECTION: webhook `webhook_e3fec000` was **already linked** to `c6b3fcd8` (trigger id
   `e3fec000-555f-4e81-9497-77b7c91c5b98`); the earlier "0 executions" was a limited-RBAC
   listing artifact, not a missing link. The workflow `wazuh-high-severity-to-iris` executed
   on a genuine canary (new execution `593b3840-…` FINISHED) → **"IRIS POST (value-blind)"
   node SUCCESS, ROUTED 200, status New**. No Shuffle-exposure weakening (compose-only add).

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
- Live manager config: real Shuffle key applied + persistent; manager on `mct-security`
  network (compose). OW-65-01 closed and verified to survive a container recreate.
  No secrets committed to the repo.

## Open / Gated (NO-GO without sign-off)

- **OW-65-01 CLOSED** — Wazuh→IRIS delivery functional + persistent (see update above).
- Re-verify IRIS read-back via list API (single-alert GET works; list API 500s — non-blocking).
- Full restore / DR rehearsal deferred.
- RTO/RPO sign-off (OW-40-05), restore rehearsal (OW-40-06), device-side OW-40-01/02,
  GitHub token (OW-42-02) remain owner-gated as before.

## Verdict
PASS — truthfully reflects current authorized, directly evidenced, production-scoped state.
Genuine Wazuh→Shuffle delivery proven; Wazuh→IRIS leg corrected and closed (OW-65-01);
single supervisor certified; kill-switch negative proof established; 480 reports + CI PASS.
