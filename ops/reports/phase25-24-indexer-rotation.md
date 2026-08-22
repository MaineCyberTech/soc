# Phase 25 Indexer Password Rotation

Date: 2026-08-22
Status: **APPROVAL PENDING - NOT ROTATED** (unchanged).

## State + procedure

- Env-backed (wazuh-docker .env 600 + creds.env + dashboard wazuh.yml; ${VAR} compose refs).
- On approval: backup stores -> update indexer internal users in-cluster -> update stores ->
  targeted recreate (indexers/dashboard/elastiflow/flow-relay, NOT down -v) -> validate.

## Blocker

- **Approval** (service-affecting). Not executed.

## No secrets