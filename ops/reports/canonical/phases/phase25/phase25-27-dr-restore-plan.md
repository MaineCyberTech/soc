# Phase 25 DR S3 Restore Drill Plan

Date: 2026-08-22
Status: **PLAN + EXECUTED (non-destructive, scratch-only).**

## Plan parameters

| Item | Value |
|---|---|
| Destination | `/tmp/opencode/dr-drill/restored` (scratch, OUTSIDE repo/production) |
| Object | `s3://wazuh/dr/current/config-20260822-040001.tar.gz` (160,538 bytes) |
| Checksum source | trusted local stage `/opt/wazuh-backups/dr-stage/` (same content uploaded at 04:00) |
| Expected contents | docker-compose files, .env.cloudflare, wazuh-local.env, indexer TLS certs, ops/scripts, config/, runbooks |
| Restore criteria | byte-identical checksum + full extraction + placeholder/syntax validation |
| Cleanup | scratch removed post-validation (or retained as drill evidence outside repo) |
| Rollback | n/a (no production touch); drill has no write to production paths |

## Safety

- Scratch-only; no destructive DR test against production. ETag NOT used as content checksum
  (SHA-256 vs trusted manifest instead).

## No secrets