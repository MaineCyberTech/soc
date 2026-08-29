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
| Strict Wazuh-originated E2E (post-reschedule) | PASS | synthetic Wazuh canary → webhook `e3fec000` → workflow `c6b3fcd8` → IRIS POST (verify=/run/secrets/iris-ca.crt) ROUTED 200 → object 213, read back via dedup ledger; cleaned |
| Non-invasive health checks | PASS | DNS/TLS verify + scoped-auth read-back, **no IRIS alert created**; derived HEALTHY fields live |
| Exactly-once (DELIVERED immutable, ambiguous→reconciliation) | PASS | source event (P72) → 1 object (211); 2nd replay DUP_SKIP (0 new); concurrent retries → 1 terminal effect; DELIVERED immutable |
| 192/193 duplicate defect recorded | PASS | both derive from `p70-replay-1787969258`; 192 initial, 193 approved replay; both FK-removed |
| Real DNS fault retained as monitor evidence | PASS | transient fault this session created orphaned object 214 (POST ok, dedup record not persisted) — dual-write hazard recorded |
| Health validator | PASS | all 11 components HEALTHY (live probe) |
| Exactly-once validator | PASS | destination_object_count=1, second_replay_suppressed=true |
| Inventory validator | PASS | 640 unique reports |

**OPEN (require authorized infrastructure / missing platform — NOT fabricated):**
- **node_evacuation** — draining a Swarm node was not performed (production operation, needs sign-off).
- **rolling-update / rollback** — service update + rollback not performed (authorized infra op).
- **observability (all 10 gates)** — no OpenTelemetry tracing/metrics pipeline, no SLO, no burn-rate alerting exist; trace_context/delivery_spans/retry_spans/replay_spans/reconciliation_spans/metrics_bounded/slo_defined/burn_rate_fast/slow/no_sensitive_payloads all OPEN.

## 2. Key Finding — Dual-Write Hazard (outbox gap)
This session a transient DNS/IRIS fault created object **214** whose dedup record was NOT persisted (the workflow's `IRIS POST` succeeded but the OpenSearch `dedup PUT` did not land). This is the unsafe dual-write the transactional **outbox** pattern must close: persist the outbound delivery durably with the local state change, then relay via a separate process with optimistic-concurrency / idempotent-consumer semantics, so a crash between POST-success and dedup-write cannot create a duplicate. Recorded as open (OPEN-ENV-02).

## 3. Environment / Open Items
- **OPEN-ENV-02:** (a) swarm node-evacuation + rolling-update/rollback evidence — authorized infra ops; (b) deploy OpenTelemetry tracing/metrics + SLO/burn-rate alerting and pin the messaging schema + migration policy. Neither present; both required for full P73 acceptance.
- Transient IRIS-name-resolution breakage from SOAR action path across reschedules (carried from P72) remains the motivating fault; remediation is swarm placement/alias (authorized).
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
