# Phase 24 Indexer Password Rotation

Date: 2026-08-22
Status: **APPROVAL PENDING - NOT ROTATED** (C5).

## 1. Current

- Values in wazuh-docker .env (600) + ops/creds.env + dashboard wazuh.yml; compose ${VAR}
  refs. Rotation affects: INDEXER_PASSWORD, API_PASSWORD, DASHBOARD_PASSWORD,
  EF_OUTPUT_OPENSEARCH_PASSWORD, ES_PASS (+ WAZUH_ADMIN_PASSWORD/WUI in creds).

## 2. Procedure (on approval)

1. Backup stores. 2. Update indexer internal users in-cluster. 3. Update .env + creds + wazuh.yml.
4. Targeted recreate: indexers -> dashboard -> elastiflow/flow-relay (NOT down -v).
5. Verify: cluster green, dashboard login, API token, elastiflow fresh, scripts RC 0.
6. Rollback: restore backups + recreate.

## 3. Blocker

- **Approval** (service-affecting). Not executed.

## No secrets