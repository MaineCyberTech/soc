# Canonical Current State — Phase 69 (Resilience Demonstration)

**Report ID:** phase69-final-current-state
**Phase:** 69
**Date:** 2026-08-29
**Timestamp:** 2026-08-29T00:35:00Z (UTC) / 2026-08-28T20:35:00-04:00 (America/New_York)
**Classification:** INTERNAL
**Status:** COMPLETE
**Supersedes:** current-state-20260828-p68.md (Phase 68 hardening refresh)

---

## 1. Scope

Phase 68 **implemented** the Class-A Wazuh→Shuffle→IRIS hardening (least-privilege
credential, internal-CA TLS, OpenSearch idempotency ledger, retry/dead-letter, DR
runbook) and closed OW-67-01. Phase 69 **demonstrates** those controls end-to-end
against the live, hardened pipeline — turning design/implementation claims into
directly observed resilience. This document is the authoritative current state.

## 2. Current Architecture (live, verified)

- Wazuh → Shuffle webhook `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98` → workflow
  `c6b3fcd8-13e5-44a8-a818-024e4ae4422b` (`wazuh-high-severity-to-iris`) → IRIS POST
  `https://iriswebapp_nginx:8443/alerts/add`.
- Credential: scoped IRIS service account `shuffle-classa-svc` (Analysts + client-1
  alert-create only), delivered via docker secret `iris-shuffle-env-v3`. Full-admin key
  retained only in `creds.env` (gitignored) for admin/maintenance.
- TLS: internal CA (`ops/backups/tls/ca.crt` + `ca.key`); IRIS cert
  `data/dfir-iris/iris-web/certificates/web_certificates/iris_dev_cert.pem` (SAN
  `iriswebapp_nginx`); workflow sets `verify='/run/secrets/iris-ca.crt'`. `verify=False`
  is eliminated from the effective Class-A path.
- Idempotency: OpenSearch dedup ledger `wazuh-iris-dedup-000001`, keyed on the stable
  Wazuh event id; first delivery writes the IRIS object + records `alert_id`; replays
  return `DUP_SKIP` (0 new objects).
- Retry/dead-letter: `execute_python` retries 3× with backoff, then transitions to
  `DEAD_LETTER` (no 4th attempt) and raises an operator alert.
- Change management: Shuffle caches workflows in `shuffle-backend`; OpenSearch doc edits
  become effective only after restarting `shuffle-backend` (proven by cache-activation
  test below).

## 3. Demonstrated Resilience (this session, all directly observed)

| Control | Proof | Status |
|---|---|---|
| TLS chain/SAN/expiry | `Verify return code 0`; SAN `iriswebapp_nginx`; notAfter year 2036; certificate survives container recreation | VERIFIED |
| Least-privilege (positive) | scoped key, customer-1 alert write → HTTP 200, read → 200 | VERIFIED |
| Least-privilege (negative) | customer-2 write → "User not entitled"; GET `/api/users` → 404 (no admin module) | VERIFIED |
| Marker parity + routing | fresh event → IRIS object 168 (tags `source:wazuh,class:A`, source_ref preserved) | VERIFIED |
| Replay suppression | replay of same event → `DUP_SKIP`, 0 new objects (replay_object_id=168) | VERIFIED |
| Concurrency idempotency | 5 identical rapid events → exactly 1 IRIS object | VERIFIED |
| Retry → dead-letter | broken target → 3 attempts then `DEAD_LETTER` (no 4th), operator alert=1, persisted across restart (exec `88c3c3f8…`) | VERIFIED |
| Self-healing delivery | after restoring correct target, same workflow ROUTED HTTP 200 (exec `4470fb33…`) | VERIFIED |
| Cache activation | dedup suppression only effective after `shuffle-backend` restart → stored==effective | VERIFIED |
| DB-cleanup governance | FK-verified transactional delete of synthetics 165-169 (0 FK refs); 140-149 + 158 preserved; 170 (timestamp event_id, possibly genuine) retained | VERIFIED |
| Alert-158 adjudication | source_ref 100065 → assessed ambiguous canary → LEFT (not deleted) | ADJUDICATED |
| E2E re-cert | canary traversed live hardened pipeline → ROUTED 200; object 169 read-back VERIFIED | VERIFIED |

**Pipeline is HEALTHY** (verified ROUTED 200 after the controlled dead-letter test was
reverted).

## 4. Validator Reconciliation

Phase 69 ships validators (`ops` of the pack at `/home/user/mct-p69/ops/scripts`):
`p69-resilience-validate`, `p69-permissions-validate`, `p69-ci-matrix-validate`,
`p69-e2e-validate`, `p69-inventory`. All were **RUN and PASS** against
`ops/reports/evidence/p69/` and the 560 generated reports. `p69-agents-ci.sh` re-derives
the CI matrix and asserts declared==actual (no mismatch). Secret scan: clean.

## 5. Evidence Locations

- Reports: `ops/reports/generated/phase69/` (560, 000–559), inventory validator PASS.
- Evidence JSONs: `ops/reports/evidence/p69/` (`p69-resilience.json`,
  `p69-permissions.json`, `p69-ci-matrix.json`, `p69-e2e.json`, `p69-time-anchor.json`).
- CI: `ops/scripts/p69-agents-ci.sh`.
- DR runbook (Phase 68): `ops/runbooks/dr-class-a-hardening.md`.

## 6. Open / Deferred / Forbidden

- **DR full rehearsal**: DEFERRED (approval-gated, needs approved external target). Rotation
  of TLS/secret documented in DR runbook.
- **Packet production**: FORBIDDEN by the Phase 69 overlay — never performed.
- **IRIS `/api/alerts/list`**: returns HTTP 500 (upstream defect); mitigated by the
  OpenSearch dedup ledger + per-id read-back via the IRIS DB.

## 7. Closures

- **OW-67-01 CLOSED** (Phase 68 implementation) with **Phase 69 demonstrated proof** (all
  controls exercised end-to-end; pack validators PASS).
- OW-65-01, OW-66-01 CLOSED (Phase 66); carried as resolved log.

## 8. Standing Rule

Do not act on any claim older than this document without re-verification. The canonical
pointer in `AGENTS.md` advances to this file.
