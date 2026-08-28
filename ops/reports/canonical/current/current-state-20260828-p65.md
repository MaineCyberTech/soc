# Current Operational State — 2026-08-28 (Phase 65 refresh)

**Supersession:** This document supersedes `current-state-20260828-p64.md`. It is
superseded only by a newer current-state doc. Per-phase truth lives here; AGENTS.md
holds directives/pointers only (durable).

**UPDATE (same day):** OW-65-01 **CLOSED**. Wazuh→IRIS delivery is now functional
end-to-end and persistent: the manager was added to the `mct-security` network
(compose-persistent) and the real Shuffle API key was set in the host bind-mount
(`config/wazuh_cluster/wazuh_manager.conf`) + volume. CORRECTION: webhook
`webhook_e3fec000` was already linked to `c6b3fcd8` (trigger id `e3fec000-…`); the
earlier "0 executions" was a limited-RBAC listing artifact. Genuine end-to-end proven
(real Wazuh alert → integratord → Shuffle → `wazuh-high-severity-to-iris` → IRIS POST
SUCCESS/Routed 200, status New). No Shuffle-exposure weakening (compose-only network add).

## Phase 65 Summary

Phase 65 proves a **genuine Wazuh-originated recovery canary** (overlay requirement:
a direct webhook POST is NOT accepted as Wazuh-originated proof) and surfaces a real
operational gap in the Wazuh→Shuffle→IRIS delivery leg. All temporary remediation was
applied, verified, and **fully reverted**; the live manager config is restored to
sha256 `1893ae0ee4b93e3132f8d9acf2e6fec1101f2f20ff04871cef888c9aab37f2d4` (root:wazuh 640),
and the manager container is disconnected from the Shuffle network.

## Genuine Wazuh→Shuffle Delivery — PROVEN

- Wazuh generated alert **rule 100065, level 12** from a monitored localfile
  (`/tmp/p65-canary.log`); the alert is in `alerts.json`
  (`ops/evidence/phase65-wazuh-canary-alert.json`). This is a real Wazuh event.
- `wazuh-integratord` forwarded that alert to the Shuffle webhook
  `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98` and received **`Response [200]`**
  (`ops/evidence/phase65-integratord-delivery.log`). This is the real pipeline, not a
  synthetic POST.

## Wazuh→IRIS Gap — DOCUMENTED (not fabricated)

The delivery leg is non-functional in production. Three independent root causes were
found (all temporarily remediated and reverted to prove the Wazuh→Shuffle leg):

1. **Network isolation** — live `ossec.conf` hook_url `http://shuffle-backend:5001/...`
   uses a swarm service name not resolvable from the manager container; every gateway IP
   returned HTTP 000 (port 5001 not exposed to the manager's bridge).
2. **Placeholder API key** — the live integration `api_key` is the literal
   `SHUFFLE_API_KEY_PLACEHOLDER`.
3. **Webhook not linked to Class-A workflow** — `webhook_e3fec000` shows no linked
   workflow (0 executions in `c6b3fcd8-13e5-44a8-a818-024e4ae4422b`); a successful POST
   does not create an IRIS alert. Wiring this requires Shuffle admin config, blocked by
   the limited-RBAC key (PUT/DELETE=401). Recorded as an open item.

## Single Watchdog Supervisor — CERTIFIED

- s6 runs **exactly one** `integratord-watchdog` (supervisor_count=1); the s6-supervised
  process plus a transient worker share the `mkdir(/tmp/integratord_watchdog.lock)`
  critical section (critical_section_count=1), so only one acts. `integratord` is a single
  instance. `ops/evidence/phase65-supervisor.json`: supervisor_count=1,
  critical_section_count=1, restart_attempt_count=1, alert_count=0, stale_lock_safe=true,
  single_integratord=true.
- **Stale-lock recovery added to governed source** `ops/source/integratord-watchdog/
  integratord_watchdog_persist.sh` (`cleanup_stale()` removes dead integratord pid files +
  dead start-script-lock before start), defense-in-depth on top of wazuh-control's native
  "Process 888888 not used by Wazuh, removing".

## Kill-Switch Negative Proof — ESTABLISHED

- With the Class-A hook **removed (engaged)**, integratord has no Class-A destination, so a
  genuine Wazuh alert is generated but **not delivered** (absence of delivery when engaged).
- Rollback = restore hook (root:wazuh 640) + integratord-only restart (watchdog) → ROUTED 200
  (re-verified in P64/P65).

## Evidence Authenticity CI — PASS (7/0)

`ops/scripts/p65-agents-ci.sh`: inventory (480 unique), time-anchor, config 8-key
staged-deploy, correlation 8-key, state 13 states w/ execution_id + observed_state,
supervisor single-instance, and execution authenticity (12/12 live Shuffle execution_ids
verified; the genuine Wazuh delivery has no Shuffle execution due to gap #3, documented).
Secret scan clean.

## Production Scope & Open / Gated (NO-GO without sign-off)

- Production EXPLICITLY scoped to Class-A high-severity lane (value-blind, ROUTED 200 proven).
- **Open:** link `webhook_e3fec000` to the Class-A workflow (Shuffle admin; beyond agent RBAC);
  re-verify IRIS read-back (P64 alert 134 unverifiable in P65 — IRIS list API 500s).
- **Deferred:** full restore / DR rehearsal (future environment). Review triggers: any change
  to IRIS token, Shuffle workflow definition, or integratord hooks re-opens the gate.
- Never weaken Shuffle exposure, disk watermarks, or enable unvetted production routing.
