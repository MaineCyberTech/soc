# Phase 15 DR S3 Key Status and Config Bundle Review

Date: 2026-08-16

## Status: DATA TIER HEALTHY - CONFIG BUNDLE 403 UNCHANGED

## S3 data tier

- Repo: do-spaces (S3, bucket wazuh) - 37 snapshots, latest 05:47 today, all SUCCESS.
- Data DR: operational (verified via snapshot list).

## Config bundle

- creds.env DO Spaces keys: PRESENT but STALE (403 SignatureDoesNotMatch on
  bundle operations - P11 finding, unchanged).
- Working keys live in the indexer encrypted keystore (non-retrievable) - that
  is why snapshots succeed while the CLI bundle fails.
- ACCEPTED local-only risk (config restore via /opt/wazuh-backups + repo).

## Required to resolve

- New DO Spaces keys (operator) -> update creds.env -> validate bundle per
  ops/runbooks/do-spaces-key-refresh-procedure.md.

## Risk

- LOW (data tier fine); MEDIUM (config restore local-only). No change this phase.

## No secrets
