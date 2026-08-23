# Phase 26 Indexer Password Rotation

Date: 2026-08-23
Status: **APPROVAL PENDING - NOT ROTATED** (unchanged; env-backed path ready).

## On approval

1. Backup stores (.env, creds.env, wazuh.yml). 2. Update indexer internal users in-cluster.
3. Update stores. 4. Targeted recreate (indexers/dashboard/elastiflow/flow-relay; NOT down -v).
5. Validate cluster/dashboard/API/ElastiFlow/scripts. 6. Rollback = restore stores + recreate.

## No secrets