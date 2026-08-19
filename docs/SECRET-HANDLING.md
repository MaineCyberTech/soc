# MCT Security Stack - Secret Handling

Applies to all repos: `MaineCyberTech/soc` (this repo) and the local deployment clone of
`wazuh/wazuh-docker` at `/opt/wazuh-docker`.

## Core rules

1. **Never commit** secrets: API keys, tokens, webhooks, enrollment passwords, private keys,
   or live credential values. All reports and docs cite file paths and **variable names** only.
2. **Never print** secret values in logs, tool output, or reports. If a tool echoes a value,
   redact it (e.g. `<REDACTED>` / `<value-hidden>`).
3. Credentials live in **local-only, mode-600 files** that are gitignored:
   - `/opt/wazuh-docker/multi-node/ops/creds.env` (admin/API/SSH/PVE/DO/registration secrets)
   - `/opt/mct-security-stack/.env` and `compose/*.env` equivalents
4. Scripts source `creds.env` and must **fail fast** if a required variable is missing:
   `: "${VAR:?VAR not set in creds.env}"`. Do NOT use hardcoded default values.

## Credential inventory (variable names only)

| Variable | Purpose | Location |
|---|---|---|
| WAZUH_ADMIN_PASSWORD | indexer/admin basic auth | ops/creds.env |
| WAZUH_WUI_PASSWORD | Wazuh API (dashboard) user | ops/creds.env |
| SO_SSH_USERNAME / SO_SSH_PASSWORD | Security Onion host | ops/creds.env |
| PVE_HOST / PVE_USERNAME / PVE_PASSWORD | Proxmox | ops/creds.env |
| VIRUSTOTAL_API_KEY | VT integration | ops/creds.env (rotated; see below) |
| DO_SPACES_* | DR S3/DO Spaces | ops/creds.env |
| WAZUH_REGISTRATION_PASSWORD | agent enrollment | ops/creds.env |

## Wazuh-docker deployment (public-origin clone) - critical

`/opt/wazuh-docker` is a clone of the **public** `wazuh/wazuh-docker` repo. Local files carry
live credentials and must never be pushed:

- `config/wazuh_cluster/wazuh_manager.conf` - contains a live VirusTotal `api_key` as a local
  modification to a tracked file. **`git update-index --skip-worktree` is set** so local
  changes cannot be committed. The key should be **rotated** (Phase 22) and replaced with
  env-driven config.
- `docker-compose.yml` / `docker-compose.override.yml` - contain the indexer admin password as
  local modifications / an untracked override file. `skip-worktree` is set on
  `docker-compose.yml`; `docker-compose.override.yml` is in `.git/info/exclude`. Both must be
  templatized to `${VAR}` before any future hardening.

Verify protections:
```bash
cd /opt/wazuh-docker/multi-node
git ls-files -v config/wazuh_cluster/wazuh_manager.conf docker-compose.yml   # expect 'S'
git status --short                                                        # sensitive files hidden
```

## Rotation

- Any secret that appeared in plaintext on disk in a git-tracked file (e.g. the VirusTotal key,
  the indexer password in compose) should be rotated at next planned rotation window (see
  `ops/runbooks/phase9-p1-credential-rotation.md`). No secret was committed/pushed (verified),
  but rotation is recommended since values existed on disk in tracked working trees.

## Scanning

- `ops/scripts/secret-pattern-scan.sh` runs in local CI + GitHub CI (no values printed).
- `ops/scripts/scan-docs-for-secret-patterns.sh` for docs.
- Before any commit: `git diff --cached` review + secret scan; never `git add -A` without review.

## No secrets

This document contains variable names and paths only - no secret values.