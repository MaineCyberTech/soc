# Secret Hygiene Runbook

Status: ACTIVE — applies to all MCT stack operations.

## Principles

1. Secrets live in exactly two places: `ops/creds.env` and `wazuh-local.env` (both root-owned, mode 600).
2. No secret value is ever printed, committed, screenshotted, pasted into chat, or written into a doc.
3. New stack files contain `<REDACTED_*>` placeholders or reference secret names only.
4. Anything that appeared in chat, docs, screenshots, or shared artifacts is treated as disclosed and scheduled for rotation.

## Secret inventory (names only)

| Name | Owned by | Location | Notes |
|---|---|---|---|
| WAZUH_ADMIN_PASSWORD | Wazuh indexer/dashboard admin | ops/creds.env | Also used for API basic auth |
| DO_SPACES_ACCESS_KEY | DigitalOcean Spaces | ops/creds.env | S3 snapshot/DR |
| DO_SPACES_SECRET_KEY | DigitalOcean Spaces | ops/creds.env | S3 snapshot/DR |
| DO_SPACES_BUCKET / BUCKET_NAME / ENDPOINT | DigitalOcean Spaces | ops/creds.env | Not secret, keep as config |
| PVE_USERNAME / PVE_PASSWORD | Proxmox | ops/creds.env | |
| SO_SSH_USERNAME / SO_SSH_PASSWORD | Security Onion | ops/creds.env | |
| VIRUSTOTAL_API_KEY | VirusTotal | ops/creds.env | |
| SUDO_PASSWORD | Local host | ops/creds.env | Reuse risk — rotate after any exposure |
| Indexer/dashboard service creds (INDEXER_PASSWORD etc.) | Wazuh | wazuh-local.env | Root-only, mode 600 |

## Handling rules

- `cat ops/creds.env` only in scripts that need runtime secrets; never echo values to terminal output that will be pasted.
- When generating a password use `openssl rand -base64 24`.
- Store generated passwords with `chmod 600` and ownership root or a dedicated ops user.
- Phase 2 `.env` files: never committed; `.gitignore` includes `.env`.
- Before any doc is shared externally, run the redaction check (see redaction-standard.md).

## Automation guard

`phase2-healthcheck.sh` and `phase2-port-audit.sh` must never print credential values. If a script needs an indexer password, source `creds.env` and pass the value via environment, not argv.

## On exposure

1. Assume the secret is compromised.
2. Rotate within 24 hours (see credential-rotation-checklist.md).
3. Note rotation in `ops/reports` with a timestamp; do not store the new value in the report.
