> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 5 Credential Rotation Results

Date: 2026-08-11
Status-only. No values.

| Credential | Priority | Status | Validation | Blocker / Rollback |
|---|---|---|---|---|
| DO Spaces access/secret keys | P1 | DEFERRED | PASS (S3 list works) | No new values in protected files (creds.env unchanged since 08-09). Rollback: creds.env.bak |
| WAZUH_ADMIN_PASSWORD | P1 | DEFERRED | PASS (indexer green, filebeat delivering) | No new values. Rollback: creds.env.bak + wazuh-local.env |
| Cloudflare tunnel token | P1 | DEFERRED | PASS (tunnel running, 0 restarts) | No new values (.env.cloudflare unchanged since 08-07). Rollback: previous token |
| IRIS admin pw + API key | P2 | READY | PASS (/api/ping pong) | Rotate when window approved |
| MISP admin pw + API key | P2 | READY | PASS (getVersion 200) | Rotate when window approved |
| Shuffle admin/API key | P3 | READY | PASS (backend health) | Rotate when window approved |
| VM103/DB secrets | P3 | READY | n/a | Rotate when window approved |

## Postcheck framework

- `ops/scripts/phase5-credential-postcheck.sh` - extended validation
  (indexer auth+health, filebeat freshness, DO Spaces, cloudflared state,
  snapshot cron). Currently: 4/5 PASS; filebeat archive check updated to local
  archives.json (PASS after fix).

## Blocker statement

No new credential values were supplied in protected files during Phase 5.
Per pack rule: "Do not automatically rotate credentials without provided new
values in protected files" - all P1 rotations remain DEFERRED with the
validation framework ready to execute on supply.

## Next action

Operator generates new values (DO Spaces UI, Wazuh security admin, Cloudflare
Zero Trust) into protected 0600 files, then execute one rotation per step
per ops/runbooks/phase5-p1-credential-rotation.md.
