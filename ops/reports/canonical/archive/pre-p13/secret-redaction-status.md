# Secret Redaction Status - Phase 3

Date: 2026-08-11
Scope: `/opt/mct-security-stack` docs and scripts; Wazuh ops directory referenced by path only.

## What was done

1. **Redaction standard updated** - `/opt/mct-security-stack/ops/runbooks/redaction-standard.md`
   - Added safe command wrapper rule (never echo sourced env variables).
   - Added public-safe redacted operations document template (status-only credential inventory).
2. **Rotation tracker created** - `/opt/mct-security-stack/ops/runbooks/phase3-credential-rotation-tracker.md`
   - 14 credential entries, status-only, no values.
3. **Secret scan script created** - `/opt/mct-security-stack/ops/scripts/scan-docs-for-secret-patterns.sh`
   - Categories: password assignment, api key/token assignment, private key blocks, cloud access keys, credentials in URLs.
   - Prints file:line and pattern category only - never values. Excludes ops/backups and ops/cdb.
4. **Scan executed** against `/opt/mct-security-stack`:
   - ~105 suspicious lines; the large majority are vendored application code (IRIS source in `data/dfir-iris/`) where `password=`/`api_key=` are code identifiers, not credentials.
   - Doc hits reviewed: only path references and status notes (e.g., `credential-rotation-checklist.md:41` references `ops/backups/iris-api-key.txt` with a rotation command example using `secrets.token_urlsafe(48)` - a code expression, not a value).
   - No real secret values found in Markdown docs under `/opt/mct-security-stack`.

## Known exposure status

- `ops/backups/iris-admin-pw.txt`, `iris-api-key.txt`, `misp-api-key.txt` exist as 0600 key files (part of backup bundle). They are **not** redacted docs; they are the private secret store and must never be included in shared bundles. Backup tar should not leave the host unencrypted.
- `/opt/wazuh-docker/multi-node/ops/creds.env` and `/opt/mct-security-stack/.env` remain the private source of truth (0600). No values printed in any Phase 3 report.

## Open follow-ups

- [ ] Decide if ops/backups secret txt files should be moved into an encrypted store (e.g., sops/gpg) and removed from plain backup bundle.
- [ ] Rotation of WAZUH_ADMIN_PASSWORD, Cloudflare tunnel token, IRIS admin pw/API key, MISP admin pw/API key (see rotation tracker) - needs operator approval and scheduled maintenance window.
- [ ] Run `scan-docs-for-secret-patterns.sh` as a pre-commit/pre-share gate for all future docs.

## Acceptance criteria

- Redacted document standard exists: YES (updated)
- Rotation tracker exists: YES
- Scan script exists and runs: YES
- No real secret values appear in newly generated reports: VERIFIED for this report set
