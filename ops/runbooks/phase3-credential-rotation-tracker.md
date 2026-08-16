# Credential Rotation Tracker

Status-only tracker. **Never** store secret values in this file or in any report.

Legend: `NEEDS_ROTATION` | `ROTATED` | `VERIFY_ONLY` | `N/A` | `PENDING_OWNER`

| # | Credential | Owner | Status | Last rotated | Notes |
|---|---|---|---|---|---|
| 1 | WAZUH_ADMIN_PASSWORD | host operator | NEEDS_ROTATION | unknown | indexer superuser; rotate via indexer security admin |
| 2 | Wazuh API users | host operator | VERIFY_ONLY | unknown | confirm per-user keys not shared admin default |
| 3 | kibanaserver / dashboard service user | host operator | VERIFY_ONLY | unknown | internal service account |
| 4 | Security Onion Elastic superuser | SO admin | VERIFY_ONLY | unknown | on Security Onion VM 192.168.222.116 |
| 5 | DO Spaces access key / secret key | host operator | NEEDS_ROTATION | unknown | used by elastic-snapshot-s3.sh / dr-s3-bundle.sh |
| 6 | VirusTotal API key | host operator | VERIFY_ONLY | unknown | enrichment only; low risk but track |
| 7 | PVE root/user password | infra admin | VERIFY_ONLY | unknown | Proxmox host access |
| 8 | Security Onion SSH password | SO admin | VERIFY_ONLY | unknown | |
| 9 | Cloudflare tunnel token | host operator | NEEDS_ROTATION | unknown | stored in .env.cloudflare |
| 10 | IRIS admin password / API key | host operator | NEEDS_ROTATION | unknown | API key in ops/backups/iris-api-key.txt |
| 11 | MISP admin password / API key | host operator | NEEDS_ROTATION | unknown | API key in ops/backups/misp-api-key.txt |
| 12 | Shuffle admin / API key | host operator | VERIFY_ONLY | unknown | API key in shuffle backend env |
| 13 | VM 103 root password/key | host operator | VERIFY_ONLY | unknown | |
| 14 | MISP/IRIS/Shuffle DB secrets | host operator | VERIFY_ONLY | unknown | in /opt/mct-security-stack/.env and compose files |

## Rotation procedure (summary)

1. Open ticket/change record in ops/reports with a timestamped backup of the affected config.
2. Generate new value; do not reuse old value.
3. Update the single source of truth (`creds.env` or `.env` or secret manager).
4. Restart the affected service(s); verify health after.
5. Revoke/expire the old value where the platform supports it.
6. Update this tracker: status `ROTATED`, last-rotated date.
7. Never write the new value to any Markdown/report file.

## Command wrapper rule (safe sourcing)

Never run `echo $VAR` after sourcing `creds.env`/`.env`. Use:

```bash
set -a; source /opt/wazuh-docker/multi-node/ops/creds.env; set +a
# reference $VAR inside the same shell; never print it
```

If a value must be consumed by another tool, pass it via environment, never via command line that is logged.
