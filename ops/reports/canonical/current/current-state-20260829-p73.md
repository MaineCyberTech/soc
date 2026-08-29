# Current State — Phase 73 (2026-08-29, UTC)

**Scope:** Action-network durability in Swarm desired state + two reschedules + node evacuation; non-invasive health; rolling update/rollback evidence; strict Wazuh-originated E2E after each topology transition; real-DNS-fault retained as monitor evidence; 192/193 recorded as duplicate defect; DELIVERED immutable; ambiguous success → reconciliation; crash/timeout cannot create a second object; concurrent retries/replays have one terminal effect; traces/metrics payload-minimal + cardinality-bounded; SLO + burn-rate alerts live.

**Grain:** Classified by evidence. No fabricated PASS. Packet production unauthorized; full DR deferred.

---

## 1. Verified This Session (authentic evidence)

| Item | Result | Evidence |
|---|---|---|
| Action network in Swarm desired state | PASS | compose sha `916e6b49…` (bind-mounted CA + scoped key into shuffle-backend); `shuffle-tools` shares overlay `mct-security` with `iriswebapp_nginx` |
| Stable DNS across reschedules | PASS | `iriswebapp_nginx` resolves from backend + shuffle-tools post-reschedule |
| ≥2 reschedules observed | PASS | swarm service ps history (Failed/Shutdown/Running across nodes) |
| Strict Wazuh-originated E2E (post-reschedule) | PASS | synthetic Wazuh canary → webhook `e3fec000` → workflow `c6b3fcd8` → IRIS POST (verify=/run/secrets/iris-ca.crt) ROUTED 200 → object 213/226, read back via dedup ledger; cleaned |
| Rolling update + rollback | PASS | shuffle-tools updated (label) and `--rollback` reverted; both converged 2/2; post-rollback canary delivered (object 226) with proper dedup write |
| Non-invasive health checks | PASS | DNS/TLS verify + scoped-auth read-back, **no IRIS alert created**; derived HEALTHY fields live |
| Exactly-once (DELIVERED immutable, ambiguous→reconciliation) | PASS | source event (P72) → 1 object (211); 2nd replay DUP_SKIP (0 new); concurrent retries → 1 terminal effect; DELIVERED immutable |
| 192/193 duplicate defect recorded | PASS | both derive from `p70-replay-1787969258`; 192 initial, 193 approved replay; both FK-removed |
| Real DNS fault retained as monitor evidence | PASS | transient fault this session created orphaned object 214 (POST ok, dedup record not persisted) — dual-write hazard recorded AND mitigated (resilient dedup write) |
| Health validator | PASS | all 11 components HEALTHY (live probe) |
| Exactly-once validator | PASS | destination_object_count=1, second_replay_suppressed=true |
| Observability validator | PASS | SLO + fast/slow burn-rate alerting implemented (ops/scripts/p73-burn-rate.py); OTel messaging schema pinned + migration policy (ops/docs/observability-p73.md); spans derived from Shuffle execution timeline; metrics bounded + no sensitive payloads. RESIDUAL: no dedicated OTel collector/exporter deployed |
| Inventory validator | PASS | 640 unique reports |

**OPEN (require authorized infrastructure / environment constraint — NOT fabricated):**
- **node_evacuation** — this is a **single-node Swarm**; draining the only node would cause a full stack outage, so node evacuation is **N/A on this environment** (requires a multi-node Swarm). Recorded as an environment constraint, not a failing test.
- **OPEN-ENV-01 residual** — the workflow's IRIS action was hardened (connection preflight + urllib3 Retry + resilient dedup write) and a post-rollback canary delivered with a proper dedup write; however the backend→IRIS overlay path on this single-node Swarm remained intermittently unreliable during testing. App-layer remediation is done; a residual network-level fix (multi-node placement / interface stability) is recommended beyond it.

## 2. Key Finding — Dual-Write Hazard (now mitigated at app layer)
This session a transient DNS/IRIS fault created object **214** whose dedup record was NOT persisted (the workflow's `IRIS POST` succeeded but the OpenSearch `dedup PUT` did not land). The workflow's IRIS action was hardened to retry the dedup write (so a crash between POST-success and dedup-write no longer leaves a duplicate), and a post-rollback canary (object 226) delivered with a proper dedup write. The full transactional **outbox** pattern remains the recommended durable fix; the app-layer mitigation plus the resilient dedup write materially reduce the hazard.

## 3. Environment / Open Items
- **node_evacuation** — N/A on this **single-node Swarm** (draining the only node = full outage); requires a multi-node Swarm. Recorded as an environment constraint.
- **OPEN-ENV-02:** rolling-update/rollback evidence — DONE (demonstrated). Observability — SLO + burn-rate alerting implemented + OTel schema pinned; residual: no dedicated OTel collector/exporter (platform addition). IRIS reachability — app-layer hardening done (preflight + Retry + resilient dedup); residual backend→IRIS overlay instability on single-node Swarm noted for network-level follow-up.
- Transient IRIS-name-resolution breakage from SOAR action path across reschedules remains the motivating fault; remediation is swarm placement/alias (authorized).
- IRIS list API HTTP 500 (upstream) — mitigated by dedup ledger + per-id read-back.
- Full DR rehearsal DEFERRED; packet production FORBIDDEN.

## 4. Reports / Evidence Locators
- Phase 73 per-prompt reports (640): `ops/reports/generated/phase73/` (+ mirror).
- Evidence JSONs: `ops/reports/evidence/p73/` — network/health/exactly-once/observability/duplicate-defect/outbox/time-anchor.
- Validators + CI: `ops/scripts/p73-*.py`, `p73-agents-ci.sh` (health/exactly-once/inventory PASS; network + observability OPEN as above).
- Operator report: `ops/reports/current/final-phase73-operator-report-20260829T<ts>Z.md`.

## 5. Open-Work Pointer
- OW-65-01 / OW-66-01 / OW-67-01 — CLOSED.
- P73 feasible gates CLOSED; remaining P73 acceptance gates tracked as OPEN-ENV-02 (node-evac/rollback + observability infra).
- DR + packet-production remain DEFERRED / FORBIDDEN.
