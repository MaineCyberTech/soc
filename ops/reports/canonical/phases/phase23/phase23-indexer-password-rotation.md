# Phase 23 Indexer Password Rotation

Date: 2026-08-22
Status: **APPROVAL PENDING - NOT ROTATED** (approval-gated; env abstraction in place).

## 1. Current

- Values live in wazuh-docker `.env` (600) + ops/creds.env + dashboard wazuh.yml; compose uses
  ${VAR} refs. Rotation would change: INDEXER_PASSWORD, API_PASSWORD, DASHBOARD_PASSWORD,
  EF_OUTPUT_OPENSEARCH_PASSWORD, ES_PASS (+ WAZUH_ADMIN_PASSWORD/WUI in creds.env).

## 2. Procedure (on approval - change register C7)

1. Backup stores (.env, creds.env, wazuh.yml).
2. Generate new values (secure channel); update indexer internal users in-cluster first.
3. Update .env + creds.env + wazuh.yml.
4. Targeted recreate: indexers -> dashboard; then elastiflow + flow-relay (NOT `down -v`).
5. Verify: cluster green, dashboard login, API token, elastiflow/flow-relay fresh output,
   ops scripts RC 0.
6. Rollback: restore backups + recreate.

## 3. Blocker

- **Approval required** (service-affecting; change window). Not executed this phase.

## Files
- `ops/reports/phase23-indexer-password-rotation.md` (this)

## No secrets