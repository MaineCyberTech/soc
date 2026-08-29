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
| Validators | health/exactly-once/observability/inventory PASS | network OPEN only on node_evacuation (N/A single-node Swarm); rolling-update + rollback of shuffle-tools demonstrated |

## 3. OPEN GATES / RESIDUAL (honest, not fabricated)
- **node_evacuation** — N/A on this **single-node Swarm** (draining the only node = full outage); requires a multi-node Swarm. Recorded as an environment constraint, not a failing test.
- **observability residual** — SLO + fast(14.4x/1h)/slow(6x/6h) burn-rate alerting implemented (`ops/scripts/p73-burn-rate.py`); OTel messaging schema pinned + migration policy (`ops/docs/observability-p73.md`); spans derived from the Shuffle execution timeline. Residual: no dedicated OTel collector/exporter (platform addition).
- **OPEN-ENV-01 residual** — the workflow IRIS action was hardened (connection preflight + urllib3 Retry + resilient dedup write) and a post-rollback canary delivered with a proper dedup write; the backend→IRIS overlay path on this single-node Swarm remained intermittently unreliable during testing, so a residual network-level fix (multi-node placement / interface stability) is recommended.

## 4. Key Finding — Dual-Write Hazard (outbox gap)
A transient DNS/IRIS fault this session created object **214** whose dedup record was never persisted (IRIS POST succeeded, OpenSearch `dedup PUT` did not land). This is the unsafe dual-write the transactional **outbox** pattern must close: persist the outbound delivery with the local state change, then relay via a separate process with optimistic-concurrency / idempotent-consumer semantics. Recorded as OPEN-ENV-02.

## 5. Cleanup / Artifacts
- Synthetic canaries (210, 211, 212, 213, 214) created during P72/P73 testing were FK-verified deleted; dedup ledger entries removed; no orphan IRIS objects remain (verified: 0 `99900x` source_ref objects).
- The orphaned 214 was removed; its existence is retained only as documentary evidence of the dual-write hazard.

## 6. Deliverables
- 640 per-prompt reports: `ops/reports/generated/phase73/` (+ mirror).
- Evidence JSONs: `ops/reports/evidence/p73/` (network/health/exactly-once/observability/duplicate-defect/outbox/time-anchor).
- Validators + CI: `ops/scripts/p73-*.py`, `p73-agents-ci.sh` (health/exactly-once/inventory PASS; network + observability OPEN as documented).
- Canonical: `current-state-20260829-p73.md`; open-work ledger advanced (P73 CLOSED feasible; OPEN-ENV-01/02 residual noted); AGENTS.md pointer updated.
- Workflow hardened + backed up: `ops/backups/workflows/c6b3fcd8-phase73-hardened.json`; SLO/burn-rate monitor `ops/scripts/p73-burn-rate.py`; schema pin `ops/docs/observability-p73.md`.

## 7. Verdict
Phase 73 feasible acceptance is met and evidenced; the remaining gates (node-evacuation, rolling-update/rollback, full observability/SLO/burn-rate) require authorized infrastructure or a platform that does not yet exist and are recorded OPEN, not fabricated. No real incident created.
