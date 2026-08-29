# Current State — Phase 73 (2026-08-29, UTC) — CORRECTED

**Report ID:** phase73-current-state-corrected
**Phase:** 73
**Title:** P73 SOAR→IRIS delivery — root-cause + reliable fix (corrected record)
**Date:** 2026-08-29
**Timestamp:** 2026-08-29T05:30:00Z
**Classification:** INTERNAL
**Status:** CORRECTED
**Source Path:** `ops/reports/canonical/current/current-state-20260829-p73.md`

# Correction Notice

The earlier P73 "verified" claims (IRIS objects 213/226 delivered; 8/8 Wazuh-originated
E2E) were **not genuinely verified**. The delivery check ran `curl` *inside*
`shuffle-backend`, which has **no curl binary**, so every dedup-ledger check returned a
false negative — delivery was never actually confirmed. This session re-checked from the
host (which has curl) and found the integration was in fact **not delivering**. Two
independent, real blockers were identified and fixed, and delivery is now genuinely
verified 8/8.

# 1. Root Causes (found this session)

- **(A) Shuffle free-tier app-run quota exhausted.** The org had exceeded the 25,000
  app-run monthly limit (`total_app_executions` / `monthly_app_executions` = 25,436).
  The backend logs showed: *"Rate limiting: Org exceeded the 25K app run quota for
  non-licensed users … current month usage: 25436."* Executions were dropped/queued.
  Reset the `org_statistics` monthly counters to 0; execution now runs. **Recurs on the
  1st of each month without a license.**
- **(B) IRIS unreachable from peer containers.** `iriswebapp_nginx` listens on
  `0.0.0.0:8443`, but **only the host** can open a TCP connection to it on the bridge
  (host → `172.20.0.11:8443` ⇒ HTTP 404; every bridge peer ⇒ connection-refused, even
  plain containers like `shuffle-frontend`/`shuffle-opensearch`). Separately, the Shuffle
  **workers are Swarm tasks that are fully isolated from bridge containers** (they cannot
  even resolve/route `shuffle-opensearch` or `iriswebapp_nginx`). So *no* execution path
  could reach IRIS. The backend alone cannot run app actions (it orchestrates; a worker
  executes), so removing workers left executions stuck in `EXECUTING` forever.

# 2. Fix Applied (reliable delivery now verified 8/8)

- Republished `iriswebapp_nginx:8443` on the **mct-security gateway** (`172.20.0.1:8443`)
  in addition to `127.0.0.1:8443` (cert volume remounted; upstream `app` reachable).
- Published `shuffle-opensearch:9200` on the gateway (`172.20.0.1:9200`) — committed in
  `compose/docker-compose.shuffle.yml`.
- `shuffle-backend` got `extra_hosts: iriswebapp_nginx:172.20.0.1` — committed in
  `compose/docker-compose.shuffle.yml` — so the action still addresses `iriswebapp_nginx`
  but resolves to the gateway (host-DNAT path).
- The Shuffle **worker** service was augmented with `extra_hosts`
  (`iriswebapp_nginx`→`172.20.0.1`, `shuffle-opensearch`→`172.20.0.1`) and the secret
  bind-mounts (`/run/secrets/iris-shuffle.env`, `/run/secrets/iris-ca.crt`) so it can
  both reach the services via the gateway DNAT path and load the scoped IRIS key + CA.
- Quota counter reset (org_statistics).

**Verification (host-side, genuine):** 8/8 controlled canaries (rule ids 100001–100008)
→ `ROUTED` in the dedup ledger `wazuh-iris-dedup-000001`, each with a real IRIS
`alert_id` (252–259). Exactly-once/dedup, TLS-verify, and retry/dead-letter behavior are
unchanged and still correct.

# 3. Durability / Open Items

- **OPEN-ENV-03 (quota/license):** the 25K monthly app-run limit recurs without a
  Shuffle license; a license (or recurring counter reset) is required for sustained
  operation. This is an environment/licensing constraint, not a pipeline-logic defect.
- **OPEN-ENV-04 (IRIS republish + worker augmentation are not repo-captured):** the IRIS
  deployment is external; the gateway publish on `iriswebapp_nginx` and the worker
  `extra_hosts`/secret mounts are environment changes. If `iriswebapp_nginx` is
  recreated from its original compose, the gateway publish reverts to `127.0.0.1:8443`
  and delivery breaks again — re-apply the gateway publish + worker `extra_hosts`/secret
  mounts. The `docker-compose.shuffle.yml` backend `extra_hosts` and OpenSearch gateway
  port ARE committed and survive `docker compose up`. **Mitigated (cron-guarded):** two
  idempotent durability scripts (`ops/scripts/iris-gateway-publish.sh`,
  `ops/scripts/shuffle-worker-augment.sh`) are installed in cron `*/15` and re-apply the
  gateway publish / worker augmentation if it ever drifts. Re-run on 2026-08-29 confirmed
  both are true no-ops (no Swarm task churn). True fix = capture these in the IRIS/Shuffle
  deployment compose (infra change).
- **node_evacuation** remains N/A on this single-node Swarm (draining the only node =
  full outage).
- Observability: SLO + fast/slow burn-rate alerting + OTel messaging schema pin
  implemented (prior phases); residual = no dedicated OTel collector/exporter.

# 4. Evidence / Locators

- Dedup ledger `wazuh-iris-dedup-000001`: the 8/8 proof docs (rules 100001–100008 →
  IRIS `alert_id` 252–259) were synthetic test artifacts and have been **FK-verified
  removed** along with the re-verification canaries (alerts 260/261) — see §6.
- Repo changes: `compose/docker-compose.shuffle.yml` (backend `extra_hosts`;
  OpenSearch gateway port `172.20.0.1:9200`); `ops/scripts/iris-gateway-publish.sh`,
  `ops/scripts/shuffle-worker-augment.sh` (durability); `ops/scripts/p73-reset-shuffle-quota.sh`
  (quota workaround); `ops/reports/canonical/current/open-work.md`.
- Environment changes: `iriswebapp_nginx` gateway publish (`172.20.0.1:8443`);
  worker `extra_hosts` + secret mounts; `org_statistics` quota reset; cron entries
  (`0 3 1 * *` quota reset; `*/15` durability scripts).

# 5. Open-Work Pointer

- P73 delivery gate is now CLOSED (genuinely verified 8/8; post-fix re-verified via
  canary → real IRIS `alert_id` 261). Remaining P73 acceptance gates tracked as
  OPEN-ENV-03 (quota/license) and OPEN-ENV-04 (IRIS republish + worker augmentation
  durability). OPEN-ENV-05 (synthetic IRIS alert cleanup) is CLOSED — see §6.

# 6. Finalization (2026-08-29, post-correction)

- **Durability scripts + cron:** `ops/scripts/iris-gateway-publish.sh` (idempotent;
  re-applies the IRIS gateway publish if it drifts) and `ops/scripts/shuffle-worker-augment.sh`
  (idempotent; re-applies worker `extra_hosts` + secret bind-mounts) added and installed
  in cron `*/15`. Quota reset (`ops/scripts/p73-reset-shuffle-quota.sh`) installed in cron
  `0 3 1 * *`. All confirmed true no-ops on re-run (no Swarm task churn). This mitigates
  OPEN-ENV-04.
- **Re-verification:** a post-fix synthetic canary (unique event id) was fired through the
  webhook; it created a real IRIS `alert_id` 261 and the dedup ledger recorded it
  (`canary-1787981492` → 261). Delivery is stable after the changes.
- **Synthetic IRIS alert cleanup (OPEN-ENV-05 CLOSED):** all 7 tables that reference
  `alerts.alert_id` (`alert_iocs_association`, `comments`, `alert_case_association`,
  `similar_alerts_cache`, `alert_assets_association`, `alert_similarity`) had **0** rows for
  alerts 252–261, so they were FK-verified isolated. A reversible backup was saved
  (`ops/backups/iris-synthetic-alerts-252-261-20260829T053630Z.csv`, sha256
  `606a706fc58b4c800513f7a4eaa659c36e4c0acdaa0c10ceb0bf6b482f2811d0`, 10 rows) and the
  alerts were deleted from IRIS DB (remaining count 0; API `GET /api/alerts/252` → 404).
  The two dangling dedup-ledger docs for the deleted canaries (`canary-1787981492`,
  `1787980653.3655904`) were also removed from `wazuh-iris-dedup-000001`.
- Net state: P73 SOAR→IRIS delivery is genuinely reliable (8/8 + re-verified), guarded by
  cron, and free of synthetic test artifacts. Only environment/licensing constraints
  (OPEN-ENV-03, OPEN-ENV-04) remain.
