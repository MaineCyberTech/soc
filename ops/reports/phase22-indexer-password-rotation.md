# Phase 22 Indexer Password Rotation

Date: 2026-08-22
Status: **TEMPLATED - ROTATION APPROVAL-GATED** (values moved to protected .env; rotation requires approval + change control).

## 1. Templating (DONE this phase)

- `docker-compose.yml` + `docker-compose.override.yml` literals replaced with `${VAR}` refs:
  INDEXER_PASSWORD, API_PASSWORD, DASHBOARD_PASSWORD, EF_OUTPUT_OPENSEARCH_PASSWORD, ES_PASS.
- Values moved to `/opt/wazuh-docker/multi-node/.env` (mode 600, user-owned, gitignored).
- Verified: `docker compose config` RC=0, all refs substituted, services intact (560 lines).
- **No container recreation** - runtime unchanged. Backups: `*.bak-phase22` next to files.
- SSL_KEY left as a path (not a secret value).

## 2. Rotation procedure (when approved)

Per `ops/checklists/phase22-secret-rotation-checklist.md` section A:
1. Update indexer internal users in-cluster.
2. Update ops/creds.env + wazuh-docker .env + dashboard wazuh.yml.
3. `docker compose up -d --force-recreate wazuh1.indexer wazuh2.indexer wazuh3.indexer wazuh.dashboard`
   (NOT `down -v` - volumes untouched).
4. Restart elastiflow + flow-relay (they read the new password from .env).
5. Verify: cluster green, dashboard login, API token, elastiflow/flow-relay index growth.
6. Rollback: restore prior values in stores + recreate again.

## 3. Rollback plan

- Prior values retained in `.env` backup + `docker-compose.yml.bak-phase22`.
- Restore + recreate -> verify.

## 4. Decision

- **Templated + verified. Rotation pending approval** (no disruption made).

## No secrets