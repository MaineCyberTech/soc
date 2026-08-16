# Phase 10 Credential Rotation Runbook

## Order (P1)

1. DO Spaces keys
2. WAZUH_ADMIN_PASSWORD
3. Cloudflare tunnel token

## Procedure (per credential)

1. Obtain new value via secure channel (operator).
2. Update the store:
   - DO Spaces: ops/creds.env (DO_SPACES_ACCESS_KEY/SECRET_KEY)
   - Wazuh admin: ops/creds.env (WAZUH_ADMIN_PASSWORD) + coordinate indexer
     internal users if changed
   - Cloudflare: .env.cloudflare (TUNNEL_TOKEN)
3. Restart dependents:
   - DO: re-run dr-s3-bundle.sh (scripts read creds.env per run)
   - Wazuh: docker compose restart indexers (if internal user changed)
   - Cloudflare: docker compose -f docker-compose.cloudflare.yml up -d --force-recreate
4. Validate:
   - credential-rotation-validation.sh --check-all -> PASS
   - dr-s3-bundle.sh -> SUCCESS (no 403)
   - tunnel container healthy
5. Operator revokes old value.
6. Update phase10-p1-credential-rotation-status.md.

## Safety

- One at a time; validate before revoke.
- Never print values.
- creds.env perms 0600.

## No secrets

No secret values printed.
