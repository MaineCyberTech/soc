# Phase 10 DR Config Bundle Validation

Date: 2026-08-15

## What was validated

- Local config bundle integrity: config-20260815-040001.tar.gz present (daily cron).
- dr-stage contents: REBUILD.md, cron-wazuh-backups, dr-assets, maxmind, scripts - all present.
- S3 snapshot repo (do-spaces): 35 snapshots, all SUCCESS (latest 2026-08-15 20:47) - data DR healthy.
- dr-s3 upload: FAILING (403) - see phase10-dr-s3-bundle-fix.md for decision.

## Validation table

| Artifact | Local | S3 | Readable |
|---|---|---|---|
| OpenSearch snapshots | yes (41) | **yes (35)** | via indexer repo API |
| Config bundle (compose/certs/creds) | yes (daily) | NO (403) | local only |
| dr-assets (S3 plugin zip) | yes | no | local |
| maxmind | yes | no | local |
| scripts + REBUILD.md | yes | no | local |

## Conclusion

- Data DR: fully validated (S3 snapshots + local).
- Config DR: local-only accepted for pilot; S3 upload blocked on keys.
- The critical restore path (snapshots) is not affected by the 403.

## No secrets

No secret values printed.
