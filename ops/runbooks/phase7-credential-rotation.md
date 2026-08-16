# Phase 7 Credential Rotation

## Sequence (one at a time)

1. DO Spaces keys -> validate --do-spaces + snapshot-s3 log
2. WAZUH_ADMIN_PASSWORD -> validate --wazuh + filebeat freshness
3. Cloudflare token -> validate --cloudflare (tunnel running)

## Rules

- Only when new value in protected 0600 file.
- Backup old file first.
- Validate after each; no revoke until validated + 30 min stable.
- Status-only tracker updates.

## Commands

```bash
/opt/mct-security-stack/ops/scripts/credential-rotation-validation.sh
/opt/mct-security-stack/ops/scripts/phase5-credential-postcheck.sh
```

## Status

DEFERRED (no new values, 2026-08-12).
