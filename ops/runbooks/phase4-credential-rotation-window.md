# Credential Rotation Window

Purpose: rotate credentials one at a time with validation after each. Never
print values. No secret stored in docs.

## Priority

```text
P1: DO Spaces access/secret keys
P1: WAZUH_ADMIN_PASSWORD
P1: Cloudflare tunnel token
P2: IRIS admin password + API key
P2: MISP admin password + API key
P3: Shuffle admin/API key
P3: VM 103/root/DB secrets
P3: verify-only credentials (SO, PVE, VirusTotal, DB secrets)
```

## Rules

1. ONE credential per step. Validate before the next.
2. Source of truth: `/opt/wazuh-docker/multi-node/ops/creds.env` and `/opt/mct-security-stack/.env` (0600). Never write values to Markdown.
3. Generate new values with `openssl rand -base64 32` (or platform key generation).
4. Update ALL consumers of the credential in the same window (config files, Shuffle workflows, cron scripts).
5. After each rotation: run `/opt/mct-security-stack/ops/scripts/credential-rotation-validation.sh`.
6. Keep the old value in the rotation tracker comment (or a 0600 note file) until validation passes, then revoke/expire.
7. Record status-only in `ops/reports/phase4-credential-rotation-status.md`.

## Step-by-step

### P1-1: DO Spaces keys

1. Generate new keys in DO Spaces UI (or spaces API).
2. Update `DO_SPACES_ACCESS_KEY`/`DO_SPACES_SECRET_KEY` in creds.env (0600).
3. Validate: `credential-rotation-validation.sh --do-spaces` (S3 list works).
4. Test: run `elastic-snapshot-s3.sh` dry or check snapshot-s3-cron.log after next run.
5. Revoke old keys in DO Spaces.

### P1-2: WAZUH_ADMIN_PASSWORD

1. Backup current: `cp ops/creds.env ops/creds.env.bak-$(date +%Y%m%d)`.
2. Set new indexer password via security admin API/UI (`/internalusers` or `securityadmin.sh`).
3. Update `creds.env`, `wazuh-local.env`, and any consumer (filebeat, scripts read creds.env).
4. Validate: `credential-rotation-validation.sh --wazuh` (health check 200 + green).
5. Restart indexer nodes only if required by the security admin procedure; verify cluster green after.
6. Keep old value until cluster green for 30 min.

### P1-3: Cloudflare tunnel token

1. Generate new tunnel token in Cloudflare Zero Trust.
2. Update `.env.cloudflare` (0600).
3. Restart `wazuh-cloudflared`; verify no CrashLoopBackOff and tunnel connected.
4. Validate: `credential-rotation-validation.sh --cloudflare`.
5. Revoke old token in Cloudflare.

### P2-1: IRIS admin password + API key

1. Rotate admin password in IRIS UI (Admin -> Users).
2. Generate new API key (IRIS Admin -> API keys); update `ops/backups/iris-api-key.txt` (0600).
3. Update Shuffle workflow headers that call IRIS.
4. Validate: `credential-rotation-validation.sh --iris` (/api/ping pong).

### P2-2: MISP admin password + API key

1. Rotate password in MISP UI.
2. New API key: MISP -> Administration -> Auth keys; update `ops/backups/misp-api-key.txt` (0600).
3. Update any consumer (CDB export script reads key file - no change needed).
4. Validate: `credential-rotation-validation.sh --misp` (getVersion 200).

### P3: Shuffle / VM 103 / verify-only

- Shuffle: API key in Shuffle UI -> Settings; update consumers.
- VM 103 DB secrets: update .env on host + compose; restart affected stack.
- Verify-only: run validation script; document any that are stale.

## Validation matrix

| Credential | Validation | Evidence |
|---|---|---|
| Wazuh admin | indexer health green with new cred | validation script PASS |
| DO Spaces | S3 list non-destructive | validation script PASS |
| Cloudflare | tunnel running/connected | container state |
| IRIS | /api/ping 200 pong | validation script PASS |
| MISP | getVersion 200 | validation script PASS |
| Shuffle | backend /api/v1/health success | validation script PASS |

## Rollback

- If validation fails after rotation: restore old value from creds.env backup, restart affected service, re-validate.
- Full rollback index: ops/runbooks/phase4-rollback-index.md
