# P1 Credential Rotation

Purpose: rotate P1 credentials one at a time with validation. Only if new values are supplied in protected local files.

## P1 order

1. **DO Spaces access/secret keys** - update creds.env; validate `--do-spaces`; test snapshot-s3 cron
2. **WAZUH_ADMIN_PASSWORD** - update creds.env + wazuh-local.env; validate `--wazuh`; restart indexer auth; keep old until green
3. **Cloudflare tunnel token** - update .env.cloudflare; restart wazuh-cloudflared; validate `--cloudflare`

## P2 readiness (no rotation required this phase)

IRIS admin/API, MISP admin/API, Shuffle admin/API, VM103/DB secrets - validation
checks exist in credential-rotation-validation.sh (all PASS).

## Rotation procedure (per credential)

1. Confirm new value exists in protected file (0600, never printed).
2. Backup old file: `cp creds.env creds.env.bak-$(date +%Y%m%d)`.
3. Update the value in the single source of truth.
4. Update dependent consumers (scripts source creds.env automatically; wazuh-local.env for indexer).
5. Restart affected service if required.
6. Run `/opt/mct-security-stack/ops/scripts/credential-rotation-validation.sh` (all checks).
7. Run `/opt/mct-security-stack/ops/scripts/phase5-credential-postcheck.sh` (extended checks).
8. Wait 30 min; verify stack health; then revoke old value in platform UI.
9. Update phase5-credential-rotation-results.md (status only).

## Rollback

- Validation fails -> restore `.bak` file, restart service, re-validate.
- Never revoke old value before validation passes.

## Status 2026-08-11

- **No new values present** (creds.env mtime 08-09, .env.cloudflare mtime 08-07 - unchanged since deployment).
- All three P1 rotations BLOCKED on operator-supplied new values.
- Validation framework ready and passing for current values.
