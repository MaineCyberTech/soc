# Credential Rotation Checklist

PRIVATE — do not share. Contains no secret values; track rotation status only.

## Priority order (highest risk first)

| # | Credential | Location | Rotate how | Status |
|---|---|---|---|---|
| 1 | SUDO_PASSWORD | ops/creds.env | `passwd` on host; update ops/creds.env | PENDING |
| 2 | WAZUH_ADMIN_PASSWORD | ops/creds.env + indexer | Indexer password rotation procedure (wazuh ops/runbooks/password-rotation.md) | PENDING |
| 3 | Indexer/dashboard service creds | wazuh-local.env | Per Wazuh multi-node password rotation procedure | PENDING |
| 4 | Wazuh API users | Wazuh API users db | `manage_users` script on manager; rotate API user passwords | PENDING |
| 5 | DO_SPACES_ACCESS_KEY / SECRET_KEY | ops/creds.env | Regenerate in DO console; update creds.env; verify S3 snapshot + DR cron | PENDING |
| 6 | VIRUSTOTAL_API_KEY | ops/creds.env | Regenerate in VirusTotal account | PENDING |
| 7 | PVE_USERNAME / PVE_PASSWORD | ops/creds.env | Rotate in PVE; update creds.env | PENDING |
| 8 | SO_SSH_USERNAME / SO_SSH_PASSWORD | ops/creds.env | Rotate on Security Onion; update creds.env | PENDING |
| 9 | Cloudflare tunnel token | cloudflared container env | Re-issue token in Cloudflare dashboard if it ever appears outside host secret store | PENDING |
| 10 | Docker secret (if any) | Portainer / docker | Rotate if exposed | PENDING |

## Procedure per credential

1. Back up `ops/creds.env` to `ops/backups/` with timestamp before editing.
2. Generate new value: `openssl rand -base64 24` (or per-tool requirements).
3. Apply new value in the tool that owns the credential first.
4. Verify the tool works with the new credential.
5. Update `ops/creds.env` (mode 600, root).
6. Verify dependent automation (snapshots, DR, alerts, agent enrollment) still works.
7. Mark status ROTATED with date in the table above (keep this file private).

## Notes

- Wazuh API user rotation: `docker compose exec wazuh.master /var/ossec/framework/python/bin/python3 /var/ossec/api/scripts/manage_users.py -u <REDACTED_USERNAME> -p '<REDACTED_PASSWORD>'` — run on manager, then restart API. Do not put real passwords in shell history logs that get pasted.
- Indexer rotation must follow the Wazuh docs procedure to avoid breaking TLS internal users; keep a rollback copy of the security index config.
- If any value was pasted into chat/screenshots/docs, rotate immediately regardless of priority.

## Stack credentials (added 2026-08-10)

| # | Credential | Location | Rotate how | Status |
|---|---|---|---|---|
| 11 | DFIR-IRIS admin password | ops/backups/iris-admin-pw.txt (600) | IRIS UI → admin → change password; update file | PENDING |
| 12 | DFIR-IRIS API key | ops/backups/iris-api-key.txt (600) | Flask shell: set User.api_key = secrets.token_urlsafe(48); update Shuffle workflow headers | PENDING |
| 13 | MISP admin password | mct-soc-scan:/opt/mct-security-stack/.env (600) | MISP UI → admin change password; update .env | PENDING |
| 14 | MISP API key | ops/backups/misp-api-key.txt (host + VM, 600) | MISP UI Auth keys → regenerate; update misp-to-wazuh-cdb.py key file + Shuffle | PENDING |
| 15 | Shuffle admin password | set in Shuffle UI (org mct-soc) | Shuffle UI → profile → change | PENDING |
| 16 | Shuffle API key | /opt/mct-security-stack/.env SHUFFLE_API_KEY (600) | Shuffle UI → API keys → regenerate; update .env | PENDING |
| 17 | VM 103 root password | mct-soc-scan cloud-init (VM .env note) | `passwd` on VM; update CI config + ssh key still valid | PENDING |
| 18 | MISP DB/Redis/Greenbone DB passwords | mct-soc-scan:/opt/mct-security-stack/.env (600) | Regenerate in .env; restart containers | PENDING |
| 19 | IRIS DB password / IRIS_SECRET_KEY | /opt/mct-security-stack/data/dfir-iris/iris-web/.env (600) | Regenerate; restart iris stack | PENDING |
| 20 | Shuffle OpenSearch password | /opt/mct-security-stack/.env SHUFFLE_OPENSEARCH_PASSWORD | Regenerate; restart shuffle-opensearch + backend | PENDING |

### Key files index (all mode 600, never commit)

- /opt/mct-security-stack/.env — stack secrets (host)
- /opt/mct-security-stack/data/dfir-iris/iris-web/.env — IRIS stack secrets
- mct-soc-scan:/opt/mct-security-stack/.env — MISP/Greenbone secrets (VM)
- /opt/mct-security-stack/ops/backups/*.txt — IRIS admin pw, IRIS API key, MISP API key
- /opt/wazuh-docker/multi-node/ops/creds.env — pre-existing Wazuh/PVE/SO/DO secrets
