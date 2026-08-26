# Phase 31 Indexer Credential Maintenance

Date: 2026-08-24
Status: **DEFERRED** (P29 attempt rolled back cleanly; cluster verified healthy).

## Plan (maintenance window, operator present)

1. wazuh-passwords-tool.sh (atomic) or securityadmin with `-h wazuh1.indexer` (reachability
   fix recorded).
2. Update .env (INDEXER_PASSWORD) + dependent services (filebeat/dashboard/elastiflow).
3. Verify auth + cluster + ingest; rollback = restore prior password.

## No secrets
