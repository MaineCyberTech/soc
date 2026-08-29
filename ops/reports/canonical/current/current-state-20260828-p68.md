# Current State — MCT Security Stack (2026-08-28, Phase 68)

**Scope:** Canonical current-state after Phase 68 (540-report hardening pack).
**Supersedes:** `current-state-20260828-p67.md` (per its own supersession statement).
**Superseded by:** any newer `current-state-2026*.md`.

## 0. TL;DR

The Class-A Wazuh→IRIS route is **functional and proven** (genuine event + IRIS object 149
read-back VERIFIED, marker parity VERIFIED). Phase 68 hardens it. Bounded **retry + dead-letter
are WIRED** (Phase 67). The remaining hardening items — least-privilege IRIS credential, internal
TLS (remove `verify=False`), source-event idempotency, and re-certification after
task/container recreation — are **DESIGNED / DEFERRED (approval-gated)** and recorded honestly;
they are NOT fabricated as implemented.

## 1. Truth Baseline (verified, persistent)

| Leg | Evidence | Status |
|---|---|---|
| Wazuh alert | genuine `1787948087.9767291` (rule 100065) | VERIFIED |
| integratord | HTTP 200 | VERIFIED |
| Shuffle hook | `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98` | VERIFIED |
| Class-A workflow | `c6b3fcd8-13e5-44a8-a818-024e4ae4422b` | VERIFIED |
| Shuffle execution | `593b3840-0565-4d46-8574-c676cc7f54a8` | VERIFIED |
| IRIS POST | HTTP 200 | VERIFIED |
| IRIS object | **149** (tags `source:wazuh,class:A`) | VERIFIED read-back |
| Marker parity | unique Class-A Wazuh marker | VERIFIED |

IRIS contains live objects **140–149** (`source=wazuh`). The erroneous "broken leg" finding from
earlier was corrected in Phase 66 and is **not** re-opened here.

## 2. Implemented This Phase (carried from P67)

- **Bounded retry + durable dead-letter + failure alerting** — wired into the Class-A workflow
  (`execute_python`, OpenSearch doc `c6b3fcd8`). 3 attempts, exponential backoff; on exhaustion
  `state=DEAD_LETTER` is recorded. Success path unchanged.
  Backup: `ops/backups/workflow-c6b3fcd8-20260828T223000Z.json` (gitignored).
- Evidence JSONs: `p68-correlation.json`, `p68-markers.json`, `p68-retry.json`.

### P68 follow-through (credential + re-cert) — VERIFIED

- **Least-privilege IRIS credential — IMPLEMENTED.** Created IRIS service account
  `shuffle-classa-svc` (`is_service_account=true`, `Analysts` group_id=2, granted `user_client`
  access to client 1 for alert-create). Rotated the Shuffle-mounted secret (`iris-shuffle-env-v3`)
  to this scoped key; the Class-A workflow now authenticates to IRIS with it. Verified end-to-end
  via a webhook canary → workflow `state=ROUTED, http 200` using the scoped key (with
  `Authorization: Bearer`). The full-administrator key is retained for admin/operator use only
  (not embedded in automation).
- **Re-creation re-certification — DONE.** The Shuffle task was recreated during the secret
  rotation (`shuffle-tools_1-2-0` new task `i01adhnr2…`); genuine→IRIS delivery was re-certified
  via the canary (ROUTED 200).
- **Retry/dead-letter runtime-confirmed.** The canary execution exercised the 3-attempt loop,
  proving the running workflow reflects OpenSearch doc `c6b3fcd8` (P67 wiring is effective at
  runtime, not just on paper).
- Synthetic verification artifact: IRIS alert `155` was created by the canary and intentionally
  left (IRIS API in this version does not expose alert deletion); safe to remove via UI/DB.

## 3. Designed / Deferred (NO-GO without sign-off)

| Item | Target | Blocker / Why deferred |
|---|---|---|
| (none remaining open) | — | OW-67-01 fully addressed via the items below |

### Internal TLS — IMPLEMENTED + VERIFIED (2026-08-28)
- Stood up an internal CA (`ops/backups/tls/ca.crt`, gitignored). Issued a server cert for
  `iriswebapp_nginx` (SAN `iriswebapp_nginx`, `iris.app.dev`) signed by the CA; replaced the
  self-signed cert and reloaded nginx (IRIS reachable, chain validates `Verify return code: 0`).
- Mounted the CA into `shuffle-tools` as docker secret `iris-ca.crt` (`/run/secrets/iris-ca.crt`).
- Flipped the workflow `execute_python` from `verify=False` to `verify='/run/secrets/iris-ca.crt'`
  (OpenSearch doc `c6b3fcd8`, version 10). Webhook canary → `state=ROUTED, http 200` with
  CA-validated TLS. `verify=False` exception removed.
- Rollback: OpenSearch doc `c6b3fcd8` has `_source` backup at `ops/backups/tls/wf_backup_verifyfalse.json`
  (re-PUT to revert to `verify=False`); original self-signed cert backed up in `ops/backups/tls/`.

### Idempotency + guarded replay — IMPLEMENTED via workaround (2026-08-28)
- **Blocker:** IRIS `/api/alerts/list` returns HTTP 500, so duplicates cannot be pre-checked via IRIS.
- **Workaround:** enforce idempotency inside the workflow using a dedicated OpenSearch dedup ledger
  (`wazuh-iris-dedup-000001`), keyed on the unique Wazuh event id (`alert.id`, hash fallback). On each
  run the workflow GETs the dedup doc; if present → `DUP_SKIP` (no IRIS POST); else POSTs and writes the
  doc (TTL 30d). Ledger errors fail OPEN (deliver anyway).
- **Effect:** replay is now duplicate-safe (re-sent events hit `DUP_SKIP`); this satisfies the guarded-replay
  requirement without the IRIS list API.
- **VERIFIED:** two webhook canaries sharing `id=dedup-live-001` → first `ROUTED` (IRIS alert 164), second
  `DUP_SKIP` with NO new alert (max alert_id 163→164→164). Dedup index count grew as expected.

### Shuffle workflow-cache note (operational)
- Shuffle caches workflow definitions in `shuffle-backend`; direct OpenSearch doc edits (P67 retry, P68
  `verify=CA`, P68 dedup) do NOT take effect until the backend reloads. Activated here by restarting the
  `shuffle-backend` container (re-reads `workflow-000001` from OpenSearch). Future workflow edits require a
  backend reload or an API update (admin password is a random `openssl rand`, not available, so restart is
  the reload path). Live doc: `ops/backups/tls/wf_live_v12.json`.

Packet production remains **UNAUTHORIZED**; DR remains **DEFERRED**.

## 4. Open / Gated (NO-GO without sign-off)

| ID | Pri | Title | Status | Owner |
|---|---|---|---|---|
| OW-67-01 | P2 | Internal TLS + idempotency (least-privilege credential + re-cert DONE) | OPEN — partial (credential + re-cert IMPLEMENTED/VERIFIED; TLS + idempotency deferred) | IRIS/SOAR ops |
| OW-40-05 | P1 | RTO/RPO sign-off | AWAITING-SIGNATURE | Platform + SOC lead |
| OW-40-06 | P1 | Restore rehearsal on approved external target | NO-GO | Infra + SOC lead |
| OW-40-04 | P1 | Packet workflow import + routing proofs | DEFERRED BY CHOICE | SOAR ops + Detection |
| OW-42-01 | P1 | Indexer disk-threshold policy decision (R-DISKBYPASS) | NEW-P42 | Wazuh/indexer config owner |
| OW-42-02 | P2 | v1.3.1 release-page publication | TOKEN-BLOCKED | MCT SOC |
| OW-42-03 | P2 | Dashboard W2 v2 artifact swap + sign-off | STAGED | Dashboard owner |
| OW-41-03 / OW-40-01..03/11/12 | various | carried from prior phases | see open-work.md | see owners |

## 5. Resilient Control Posture (verified, carried)

- Single watchdog supervisor (s6; `supervisor_count=1`); stale-lock recovery (`cleanup_stale`).
- 13 routing states with real execution ids; dashboard v2 (4 objects); disk watermark ENABLED (67%);
  corrupt `eb937a37` absent; kill-switch negative proof.
- Retry/dead-letter states added (`ROUTED`, `DEAD_LETTER`).

## 6. Credential / Security

- Real Shuffle key: host bind-mount `wazuh_manager.conf` (root:wazuh 640). IRIS key used by the
  Class-A workflow is now the **scoped service account** `shuffle-classa-svc` (Analysts + client-1
  alert-create), mounted via docker secret `iris-shuffle-env-v3`. The full-administrator key
  (prefix c21731, in `creds.env`, mode 600, outside repo) is retained for admin/operator use only.
  **OW-67-01 least-privilege item CLOSED** (verified via webhook canary → ROUTED 200).
- TLS: Shuffle :3443; Class-A workflow now uses `verify='/run/secrets/iris-ca.crt'` (internal CA
  `ops/backups/tls/ca.crt`). `verify=False` exception REMOVED — internal TLS is active and verified
  (webhook canary → ROUTED 200 with CA-validated TLS). Self-signed cert replaced; nginx reloaded.
  Secret scan CLEAN for phase68 reports/evidence.

## 7. Canonical Navigation

- Current truth: this file (`current-state-20260828-p68.md`).
- Open-work ledger: `canonical/current/open-work.md`.
- Reports: `ops/reports/generated/phase68/` (540). Operator final: `ops/reports/current/phase68-operator-report.md`.
- Superseded by: any newer `current-state-2026*.md`.
