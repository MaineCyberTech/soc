# P1 Credential Rotation Execution

## Sequence (one at a time)

1. DO Spaces keys -> validate `--do-spaces` + snapshot-s3 log
2. WAZUH_ADMIN_PASSWORD -> validate `--wazuh` + filebeat freshness
3. Cloudflare token -> validate `--cloudflare` (tunnel running, no crashloop)

## Rules

- Only rotate when new value exists in protected 0600 file.
- Backup old file first (creds.env.bak-<date>).
- Validate AFTER each rotation before the next.
- Do NOT revoke old value until validation passes + 30 min stability.
- Update tracker status only (never values).

## Validation commands

```bash
/opt/mct-security-stack/ops/scripts/credential-rotation-validation.sh
/opt/mct-security-stack/ops/scripts/phase5-credential-postcheck.sh
```

## Status 2026-08-11

DEFERRED (no new values). Framework validated PASS.
