# DR Runbook — Class-A Hardened Pipeline (extension to disaster-recovery-addendum.md)

This runbook extends `disaster-recovery-addendum.md` with the artifacts and procedures introduced
by the Phase 67/68 Class-A hardening. Read the base addendum for host/VM layout, S3 integration,
and the general recovery order. This document covers ONLY the hardened-pipeline specifics.

## Scope & assumptions

- The Class-A Wazuh→Shuffle→IRIS route is the subject. Genuine delivery is proven (IRIS object 149
  and its read-back; verified canaries through the live webhook).
- "Hardened" state (current): IRIS uses a **scoped service account** `shuffle-classa-svc` (not the
  full-admin key), TLS is CA-validated (`verify='/run/secrets/iris-ca.crt'`, internal CA), delivery is
  duplicate-safe (OpenSearch dedup ledger), and the workflow has bounded retry/dead-letter.
- Base DR still applies for Wazuh, IRIS case DB (pg_dump), MISP, Velociraptor, OpenCanary, OpenSearch
  Alerting. This document adds the artifacts the base DR does not call out.

## Critical artifacts to back up

| Artifact | Location (live) | Backup | Restore |
|---|---|---|---|
| IRIS scoped service account | `iris_db` table `user`/`user_group`/`user_client` (user `shuffle-classa-svc`) | IRIS `pg_dump` (base DR cron) — **ensure dump is post-2026-08-28** | `pg_restore` (restores the account + scoped key) |
| IRIS full-admin key | `iris_db` + `creds.env` (`IRIS_API_KEY`, prefix `c21731`) | `pg_dump` + `creds.env` backup | restore DB + `creds.env` |
| Internal CA | `/opt/mct-security-stack/ops/backups/tls/ca.crt` + `ca.key` (gitignored) | file copy / S3 bundle | file copy back |
| IRIS server cert/key | host `/opt/mct-security-stack/data/dfir-iris/iris-web/certificates/web_certificates/iris_dev_cert.pem` + `iris_dev_key.pem` (CA-signed) | file copy / S3 bundle | file copy back, reload nginx |
| Shuffle secret `iris-shuffle-env-v3` (scoped IRIS key) | docker secret store | recreate from IRIS DB (scoped key is in `iris_db`) — or capture secret value pre-loss | `docker secret create iris-shuffle-env-v3` |
| Shuffle secret `iris-ca.crt` (internal CA) | docker secret store | recreate from `ops/backups/tls/ca.crt` | `docker secret create iris-ca.crt` |
| Workflow doc `c6b3fcd8` (v12: dedup + verify=CA + retry) | OpenSearch `workflow-000001/_doc/c6b3fcd8` | `ops/backups/tls/wf_live_v12.json` (gitignored) | PUT to OpenSearch, then **restart `shuffle-backend`** |
| Dedup ledger | OpenSearch `wazuh-iris-dedup-000001` | OpenSearch snapshot (optional) | recreate index (auto-created on first write) or restore snapshot |
| `creds.env` | `/opt/wazuh-docker/multi-node/ops/creds.env` (outside repo, mode 600) | existing host backup | restore file |

**Gaps / risk acceptance:**
- If the IRIS `pg_dump` predates 2026-08-28, the scoped service account is missing → after restore,
  recreate it (see `credential-rotation-checklist.md` analogue / runbook below) before starting Shuffle.
- The internal CA + IRIS cert are only in `ops/backups/tls/` (gitignored) and the live host cert dir.
  They are NOT in the base S3 bundle unless `dr-s3-bundle.sh` is extended to include `ops/backups/tls/`.
  **Action:** add `ops/backups/tls/` to the DR S3 bundle before the next drill.

## Pre-restore checklist

1. Confirm IRIS `pg_dump` is post-2026-08-28 (contains `shuffle-classa-svc`). If not, plan to recreate
   the scoped account after restore.
2. Confirm `ops/backups/tls/` (CA + cert + `wf_live_v12.json`) is present and current. If missing,
   you will need to regenerate the CA/cert and re-PUT the workflow doc from this runbook.
3. Do NOT start stack services until OpenSearch/DBs are green (per base DR).

## Restore procedure (ordered)

1. Restore base stack (Wazuh, IRIS DB via `pg_restore`, MISP, etc.) per base DR.
2. If IRIS DB was restored from a pre-2026-08-28 dump, recreate the scoped service account:
   - INSERT into `user` (`shuffle-classa-svc`, `is_service_account=true`, `api_key=<new 64-hex>`,
     `email=shuffle-classa@localhost`, active=true); add `user_group` (group_id=2) and `user_client`
     (user_id, client_id=1, access_level=2, allow_alerts=true). Record the new key.
3. Restore IRIS cert/CA: copy `ops/backups/tls/ca.crt` + regenerated-or-backed-up `iris_dev_*.pem`
   into the host cert dir; reload `iriswebapp_nginx` (`nginx -s reload`). Verify chain
   (`openssl s_client -connect iriswebapp_nginx:8443 -CAfile ca.crt` → `Verify return code: 0`).
4. Recreate docker secrets (if swarm was rebuilt): `docker secret create iris-shuffle-env-v3` from
   the scoped key (from IRIS DB or recorded value); `docker secret create iris-ca.crt` from
   `ops/backups/tls/ca.crt`. Ensure `shuffle-tools` mounts both (`iris-shuffle.env` ← v3,
   `iris-ca.crt` → `/run/secrets/iris-ca.crt`).
5. Restore the workflow doc: `PUT ops/backups/tls/wf_live_v12.json` to
   `workflow-000001/_doc/c6b3fcd8`, then **restart `shuffle-backend`** so Shuffle reloads the doc
   (Shuffle caches workflows; OpenSearch edits are invisible until the backend reloads).
6. Start services in base-DR order (iris → shuffle → …). Confirm the Shuffle webhook is reachable.

## Post-restore verification (canary)

Send a webhook canary and confirm the hardened path end-to-end:

```
CT=$(docker ps --filter name=shuffle-tools --format '{{.Names}}' | head -1)
docker exec "$CT" curl -s -X POST \
  'http://shuffle-backend:5001/api/v1/hooks/webhook_e3fec000-555f-4e81-9497-77b7c91c5b98' \
  -H 'Content-Type: application/json' \
  -d '{"rule":{"id":"100065"},"id":"dr-smoke-<ts>"}'
sleep 7
# expect: workflow state=ROUTED, http 200 (scoped key + CA-validated TLS + retry)
# send the SAME id a second time -> expect state=DUP_SKIP (dedup ledger live)
```

Confirm in IRIS: `GET /alerts/<new_id>` → 200 with tags `source:wazuh,class:A`. Then clean up the
smoke alert (IRIS API does not expose deletion in this version; remove via FK-verified DB delete).

## Internal CA / IRIS cert rotation (cert lifecycle)

- CA + server cert are valid 10 years. Rotation (no key change needed in the workflow):
  1. `openssl req -new -key ca.key -out ir_iso.csr -subj "/CN=iris.app.dev/O=MCT Security"` (or reuse
     existing key).
  2. `openssl x509 -req -in ir_iso.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out iris_dev_cert.pem
     -days 3650 -sha256 -extfile <(echo "subjectAltName=DNS:iriswebapp_nginx,DNS:iris.app.dev,DNS:localhost,IP:127.0.0.1")`.
  3. Replace host `iris_dev_cert.pem`/`iris_dev_key.pem`; reload nginx.
  4. `verify='/run/secrets/iris-ca.crt'` is UNCHANGED (the CA did not change) → no workflow edit needed.

## Shuffle workflow-cache caveat (important)

Shuffle (`shuffle-backend`) caches workflow definitions. Any direct OpenSearch edit to
`workflow-000001/_doc/c6b3fcd8` (including restore) is **not** live until the backend reloads.
Activate by `docker restart shuffle-backend` (or an API update with admin creds — the Shuffle admin
password is a random `openssl rand`, so restart is the reload path). Verify with the canary above.

## Known gaps / risk acceptance

- Disk watermark remains advisory-only (R-DISKBYPASS, owner decision OW-42-01) — DR must NOT enable
  `cluster.routing.allocation.disk.threshold_enabled`.
- Dedup ledger reset (if OpenSearch lost) is fail-open: delivery continues, just without duplicate
  suppression until the index is re-created (automatic on first write). Acceptable.
- Packet production remains UNAUTHORIZED and is out of DR scope.
