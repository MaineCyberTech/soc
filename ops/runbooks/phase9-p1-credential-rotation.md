# Phase 9 P1 Credential Rotation Runbook

## Order (per pack)

1. DO Spaces keys
2. WAZUH_ADMIN_PASSWORD
3. Cloudflare tunnel token

## Procedure (per credential)

1. Obtain new value via secure channel (operator).
2. Edit the store:
   - DO Spaces: ops/creds.env (DO_SPACES_ACCESS_KEY / DO_SPACES_SECRET_KEY)
    - Wazuh admin: ops/creds.env (WAZUH_ADMIN_PASSWORD) - also used by indexer
      internal users (admin: from ${INDEXER_PASSWORD}/WAZUH_ADMIN_PASSWORD in compose) - coordinate indexer user update
   - Cloudflare: .env.cloudflare (TUNNEL_TOKEN)
3. Restart dependents:
   - DO: no restart needed (scripts read creds.env each run); re-run dr-s3-bundle.sh
   - Wazuh: `docker compose restart wazuh1.indexer wazuh2.indexer wazuh3.indexer`
     (if indexer internal user changed)
   - Cloudflare: `docker compose -f docker-compose.cloudflare.yml up -d --force-recreate`
4. Validate:
   - `bash ops/scripts/credential-rotation-validation.sh --check-all` -> PASS
   - dr-s3-bundle.sh -> SUCCESS (no 403)
   - tunnel container healthy
5. Operator revokes the old value.
6. Update phase9-p1-credential-rotation.md (status only).

## Safety

- One credential at a time; validate before revoke.
- Never print values in logs/reports.
- creds.env permissions: 0600.

## No secrets

No secret values printed.
