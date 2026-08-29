# Phase 73 — Final Operator Report

**Date:** 2026-08-29 (UTC) · **Phase:** 73 · **Status:** PARTIAL (feasible gates CLOSED; infra-gated gates OPEN — recorded, not fabricated)
**Canonical truth:** `ops/reports/canonical/current/current-state-20260829-p73.md`

## 1. Mandate
Action-network durability in Swarm desired state (survives two reschedules + node evacuation); non-invasive health checks; rolling update/rollback evidence; strict Wazuh-originated E2E after each topology transition; retain the real DNS fault as monitor evidence; record 192/193 as a duplicate defect; DELIVERED immutable; ambiguous success → reconciliation; crash/timeout cannot create a second destination object; concurrent retries/replays have one terminal effect; traces/metrics payload-minimal + cardinality-bounded; SLO + burn-rate alerts live.

## 2. Authentic Evidence (verified this session)
| Capability | Result | Key IDs |
|---|---|---|
| Action network in Swarm desired state | PASS | compose sha `916e6b49…`; `shuffle-tools` shares overlay `mct-security` with `iriswebapp_nginx` |
| Stable DNS across reschedules | PASS | `iriswebapp_nginx` resolves post-reschedule |
| ≥2 reschedules observed | PASS | swarm service ps history |
| Strict Wazuh-originated E2E (post-reschedule) | PASS | canary 213: webhook `e3fec000` → workflow `c6b3fcd8` → IRIS POST ROUTED 200 → 1 object, read back via dedup ledger; cleaned |
| Non-invasive health | PASS | DNS/TLS verify + scoped-auth read-back; **no IRIS alert created**; HEALTHY fields live |
| Exactly-once | PASS | DELIVERED immutable; 2nd replay DUP_SKIP (0 new); concurrent retries → 1 terminal effect |
| 192/193 duplicate defect | PASS | both derive from `p70-replay-1787969258`; 192 initial, 193 approved replay; both FK-removed |
| Real-fault retained | PASS | orphaned object 214 (POST ok, dedup record not persisted) — dual-write hazard recorded |
| Validators | health/exactly-once/inventory PASS | network + observability OPEN (see below) |

## 3. OPEN GATES (require authorized infra / missing platform — NOT fabricated)
- **node_evacuation** — Swarm node drain not performed (production op, needs sign-off).
- **rolling-update / rollback** — service update + rollback not performed (authorized infra op).
- **observability (all 10 gates)** — no OpenTelemetry tracing/metrics, no SLO, no burn-rate alerting exist; trace_context / delivery_spans / retry_spans / replay_spans / reconciliation_spans / metrics_bounded / slo_defined / burn_rate_fast / burn_rate_slow / no_sensitive_payloads all OPEN.

## 4. Key Finding — Dual-Write Hazard (outbox gap)
A transient DNS/IRIS fault this session created object **214** whose dedup record was never persisted (IRIS POST succeeded, OpenSearch `dedup PUT` did not land). This is the unsafe dual-write the transactional **outbox** pattern must close: persist the outbound delivery with the local state change, then relay via a separate process with optimistic-concurrency / idempotent-consumer semantics. Recorded as OPEN-ENV-02.

## 5. Cleanup / Artifacts
- Synthetic canaries (210, 211, 212, 213, 214) created during P72/P73 testing were FK-verified deleted; dedup ledger entries removed; no orphan IRIS objects remain (verified: 0 `99900x` source_ref objects).
- The orphaned 214 was removed; its existence is retained only as documentary evidence of the dual-write hazard.

## 6. Deliverables
- 640 per-prompt reports: `ops/reports/generated/phase73/` (+ mirror).
- Evidence JSONs: `ops/reports/evidence/p73/` (network/health/exactly-once/observability/duplicate-defect/outbox/time-anchor).
- Validators + CI: `ops/scripts/p73-*.py`, `p73-agents-ci.sh` (health/exactly-once/inventory PASS; network + observability OPEN as documented).
- Canonical: `current-state-20260829-p73.md`; open-work ledger advanced (P73 row + OPEN-ENV-02); AGENTS.md pointer updated.

## 7. Verdict
Phase 73 feasible acceptance is met and evidenced; the remaining gates (node-evacuation, rolling-update/rollback, full observability/SLO/burn-rate) require authorized infrastructure or a platform that does not yet exist and are recorded OPEN, not fabricated. No real incident created.
