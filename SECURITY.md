# MCT Security Stack - Security

Date: 2026-08-16

## Secret handling rules

1. **Never commit or print secrets**: passwords, API keys, tokens, enrollment
   passwords, webhook URLs, private keys, DO Spaces keys.
2. **Secret locations** (0600 perms, git-ignored):
   - /opt/wazuh-docker/multi-node/ops/creds.env (Wazuh, PVE, DO, SO, sudo)
   - /opt/mct-security-stack/.env (stack services)
   - /opt/wazuh-docker/multi-node/.env.cloudflare (tunnel token)
3. **Examples**: .env.example + config/examples/secrets.example.env contain
   placeholders only.
4. **Scripts**: source creds.env, never hardcode values (P11.04 fixed 3 scripts).
5. **Reports**: cite variable names, never values.
6. **Backups**: config bundles exclude .env/creds.env; dr-s3 bundle includes
   creds.env by design (restore need) - S3 bucket access must be restricted.

## Secret hygiene scan

```bash
bash ops/scripts/scan-docs-for-secret-patterns.sh   # existing scanner
bash ops/scripts/secret-pattern-scan.sh             # added P11.08
```
Both print file/line/category only, never values.

## Credential rotation

- One credential at a time; validate before revoke (ops/runbooks/phase10-credential-rotation.md).
- P1 order: DO Spaces -> WAZUH_ADMIN_PASSWORD -> Cloudflare token.

## Reporting

- Client-safe QA checklist (reporting/output/internal/phase9-client-reporting-qa.md).
- No internal paths/hosts/rule IDs in client docs.

## No secrets

This document contains no secret values.
