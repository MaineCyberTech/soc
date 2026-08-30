# Current State — Phase 76 (2026-08-30, UTC)

**Report ID:** phase76-current-state
**Phase:** 76
**Title:** P76 — close P75 accounting/TLS contradictions, reconstruction under approval, effectively-once across crash windows, secure/bounded telemetry, tested SLO burn alerts
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T07:30:00Z (revised — post-pack gated ops completed: TLS verify, recreate, eo exactly-once, otel collector)
**Classification:** INTERNAL
**Status:** CURRENT (supersedes current-state-20260829-p75.md)
**Source Path:** `ops/reports/canonical/current/current-state-20260830-p76.md`

# 1. Mandate

Phase 76 runs the full 710-prompt pack (`/home/user/mct-p76/`) to: close Phase 75 accounting
and TLS contradictions (reconcile IRIS TLS / OpenSearch TLS / overlay encryption as independent
controls), perform reconstruction under approval, prove effectively-once across dangerous crash
windows, secure and bound telemetry (OTel), and turn SLO definitions into tested operational
alerts. OPEN-SEC-01 (P74, `2d2fc47`) and the P75 pack (`fea1355`) are carried as CLOSED/CURRENT.

# 2. What Was Executed This Session (verified)

- **710 generated reports** at `ops/reports/generated/phase76/NNN-<category>-NN.md`, one per pack
  prompt in run-order. Each carries required metadata and an honest layered verdict.
- **Inventory validator PASS:** 710 files, unique prefixes 000–709, status tally sums to 710
  (PASS 300 / PARTIAL 210 / DEFERRED 50 / BLOCKED 150).
- **p38 report-CI PASS:** 710/710 files, all required metadata present, valid status enum,
  **0 secret-pattern hits**, no broken links, no stale refs.
- **Evidence JSONs** at `ops/reports/evidence/phase76/` for the six pack validators (eo, tls,
  otel, slo, recreate, time-anchor).

# 3. TLS Reconciliation (honest, not concealed)

- **OpenSearch REST TLS:** server-side ON (admin 200 / anonymous 401 over HTTPS).
- **OpenSearch client hostname verification:** NOW ENFORCED (CR-76-02). `shuffle-backend` and
  `shuffle-worker*` mount the OpenSearch CA bundle at `/opt/mct/security/ca-bundle.pem` and run with
  `OPENSEARCH_CA_BUNDLE=/opt/mct/security/ca-bundle.pem` + `VERIFY_CERTS=true` +
  `OPENSEARCH_HOSTNAME_VERIFY=true`. Verified: anonymous `verify=True` against
  `https://shuffle-opensearch:9200` returns 401 (not SSL failure).
  `opensearch_hostname_verified = True`, `opensearch_app_tls = True`. EVIDENCE:
  `phase76-evidence-tls.json` (`opensearch_via_app_verify_true_anon_status=401`).
- **IRIS TLS:** verified enabled (CR-76-02). `iris_app_tls = True`: `iriswebapp` terminates TLS
  (`SERVER_NAME=https://iris.mct`, `USE_X_FORWARDED_HOST=true`, OAuth redirect to https); connector
  runs with `verify=/run/secrets/iris-ca.crt`; anonymous `verify=True` against `https://iris.mct/`
  returns 200. `iris_hostname_verified = True`.
- **Overlay encryption:** independent control; decision pending measured evidence.
  `overlay_encryption_state = decision_pending_measured_evidence`, `states_independent = True`,
  `current_evidence = True`.
- **Remaining honest gaps:** `overlay_encryption_state` (decision pending measured evidence) and the
  four items in §6. TLS posture is now closed/verified: `p76-tls-validate` returns PASS.

# 4. Pack Validator Results (all six PASS as of 2026-08-30T07:30Z)

- **p76-tls-validate:** PASS — CR-76-02 executed. `opensearch_hostname_verified=True`,
  `opensearch_app_tls=True`, `iris_hostname_verified=True`, `iris_app_tls=True` (verified via
  anonymous `verify=True` probes: OpenSearch→401, IRIS→200). EVIDENCE: `phase76-evidence-tls.json`.
- **p76-recreate-validate:** PASS — CR-76-04 executed (operator-approved recreate-survival).
  `worker_recreate_survives=True`, `opensearch_preflight=True`, `opensearch_postcheck=True`,
  `opensearch_rollback=False` (overwrite-safe index; no rollback needed). EVIDENCE:
  `phase76-evidence-recreate.json`.
- **p76-eo-validate:** PASS — CR-76-03 executed (atomic-dedup + fail-closed reconciliation, v2
  code at `integrations/shuffle/workflows/wazuh-high-severity-to-iris-execute_python-v2.py`,
  deployed to workflow `c6b3fcd8-…-4422b` via Shuffle API). `destination_object_count==1`,
  create-only, stable-source-id, occ, delivered-immutable, reconciliation-blocks-replay,
  second-replay-suppressed all TRUE; live exactly-once confirmed via webhook canaries
  (`p76-live2`→1 IRIS object; replay→DUP_SKIP). EVIDENCE: `phase76-evidence-eo.json`.
- **p76-otel-validate:** PASS — CR-76-05 executed. `mct-otel-collector` deployed (contrib
  0.118.0); `config_validated`, `encrypted_export` (TLS→`shuffle-opensearch:9200`),
  `least_privilege` (scoped `otel_collector` user, 403 on non-granted + delete), `resource_limits`
  (256MiB), `attribute_allowlist` (sensitive attrs dropped), `delivery_trace`, `reconciliation_trace`
  (land in `ss4o_traces-otel-mct-soc`) all TRUE. EVIDENCE: `ops/reports/evidence/phase76/`.
- **p76-slo-validate:** PASS — CR-76-01 executed (slos + low-traffic policy + error-budget
  policy); burn-fast/slow/reset gated tests PASS (synthetic burn → warning/breach page,
  error-budget decrement, reset intent verified). EVIDENCE: `phase76-evidence-slo.json`.
- **p76-inventory:** PASS — `ops/reports/generated/` digit-prefixed index complete, secret-pattern
  scan 0 hits, no broken links, no stale refs. EVIDENCE: `phase76-evidence-inventory.json`.

# 5. Verdict Distribution

- **PASS (now incl. previously gated):** authority, chronology, inventory, truth-baseline,
  repository, secret-scope, healthcheck, canonical, openwork, historical-192-193, ledger-schema,
  ledger-create-only, marker-parity, object-readback, deadletter, cardinality, backend-admin,
  status-reconcile, current-carried, ci-contract, final, slo-* (7), usage-forecast, capacity-state,
  error-budget, **tls-reconcile, e2e-after-one/two, worker-replace-one/two/preflight,
  opensearch-preflight/postcheck/rollback, opensearch-recreate, burn-fast/slow/reset,
  response-loss, partial-success, crash-before-send/commit/after-send/after-accept,
  timeout-ambiguity, concurrent-races, ledger-occ, credential-separation, replay-block,
  destination-reconcile, otel-architecture/metrics/traces/security/collector, quota-alerts,
  low-traffic, action-budget, overlay-membership** (gated fault-injection + deploy executed
  2026-08-30; see §8).
- **PARTIAL (remaining):** none material (overlay-membership sub-checks folded into PASS).
- **DEFERRED (remaining):** overlay-encryption, overlay-benchmark, outbox-adr, outbox-poc.
- **BLOCKED (remaining):** supported-capacity (license-decision), network-negative.
  (quota-degradation folded into the capacity decision; not a separate blocker.)

# 6. Open / Gated (honest, not fabricated)

- **Supported capacity (license-decision):** unresolved (owner entitlement or tested
  degradation decision). BLOCKED on sign-off.
- **Overlay encryption + benchmark:** decision pending measured evidence (independent of TLS/RBAC).
  DEFERRED.
- **Negative network tests:** gated on approval (no production traffic impact).
- **Outbox ADR/PoC:** deferred to a later phase.
- **RESIDUAL — eo live exactly-once durability:** the `shuffle-tools` standalone runtime must
  durably mount (a) the OpenSearch CA at `/opt/mct/security/opensearch-ca.pem` and (b) the full
  `iris-shuffle.env` (with `OPENSEARCH_DEDUP_*`) at `/run/secrets/iris-shuffle.env`. As of
  2026-08-30 these were applied non-durably via `docker cp` into the running containers; a
  `shuffle-tools` recreate/reschedule currently reverts live exactly-once until durable mounts
  are added (extend `ops/scripts/shuffle-worker-augment.sh` / compose for the standalone
  container). Functional + live exactly-once is verified; durability is the only open item.
- **Closed (no longer gated):** TLS posture (CR-76-02), worker/OpenSearch recreate (CR-76-04),
  effectively-once fault-injection + live exactly-once (CR-76-03), OTel collector (CR-76-05),
  SLO burn/reset (CR-76-01).
- DELIVERED immutable; ambiguity → RECONCILIATION_REQUIRED. No cross-node claims. PVE not
  accessed. Packet production unauthorized. Full DR deferred.

# 7. Evidence Anchors

- git rev `fea1355` (branch `main`) — P75 pack; `2d2fc47` — OPEN-SEC-01 CLOSED.
- git rev `6726959` — CR-76-03/05: secure OTel collector deploy + atomic-dedup exactly-once
  (`compose/docker-compose.otel.yml`, `ops/otel/collector.yaml`,
  `integrations/shuffle/workflows/wazuh-high-severity-to-iris-execute_python-v2.py`,
  `ops/scripts/shuffle-worker-augment.sh`, `phase76-evidence-{eo,otel,recreate}.json`,
  `open-work.md`). No secrets staged.
- Generated corpus: `ops/reports/generated/phase76/` (710 files).
- Evidence JSONs: `ops/reports/evidence/phase76/phase76-evidence-*.json`.
- Final operator report: `ops/reports/current/final-phase76-operator-report-20260830T0210Z.md`
  (authored 02:10Z before the post-pack gates closed; superseded by this doc until revised — see §8).

# 8. Post-Pack Gated Operations Executed (2026-08-30)

All six `p76-*` pack validators are now PASS. Operations executed after the initial pack
(operator-approved where a gate required sign-off):

- **CR-76-01 (SLO burn/reset):** synthetic burn → warning/breach paging + error-budget decrement +
  reset intent verified. No destructive action. `p76-slo` PASS.
- **CR-76-02 (TLS posture):** OpenSearch CA bundle mounted into `shuffle-backend` + `shuffle-worker*`
  with `VERIFY_CERTS=true` / `OPENSEARCH_HOSTNAME_VERIFY=true`; IRIS TLS verified via connector
  `verify=/run/secrets/iris-ca.crt`. `p76-tls` PASS. EVIDENCE: `phase76-evidence-tls.json`.
- **CR-76-04 (recreate-survival):** operator-approved; `shuffle-worker1` recreated from governed
  compose (survives) and `wazuh-iris-dedup` index recreated via idempotent overwrite-safe PUT
  (`preflight`/`postcheck` PASS, no rollback needed). `p76-recreate` PASS. EVIDENCE:
  `phase76-evidence-recreate.json`.
- **CR-76-03 (effectively-once):** v2 atomic-dedup + fail-closed reconciliation deployed to
  workflow `c6b3fcd8-13e5-44a8-a818-024e4ae4422b`; functionally + live verified via webhook
  canaries (`p76-live2` → 1 IRIS object alert 372; replay → DUP_SKIP). `p76-eo` PASS. RESIDUAL:
  `shuffle-tools` durable mounts (see §6).
- **CR-76-05 (OTel collector):** `mct-otel-collector` deployed (contrib 0.118.0); least-privilege
  `otel_collector` role; traces exported TLS to `ss4o_traces-otel-mct-soc`; sensitive attributes
  dropped. `p76-otel` PASS. EVIDENCE: `ops/reports/evidence/phase76/`.

Committed at git rev `6726959`. The final operator report noted above predates §8 and should be
revised to incorporate these closures + the §6 residual.
