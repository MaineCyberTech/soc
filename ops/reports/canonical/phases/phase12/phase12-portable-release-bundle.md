# Phase 12 Portable Release Bundle Report

Date: 2026-08-16

## Status: BUNDLE BUILT (approved apply - local artifact, not pushed)

## Artifacts

| Item | Value |
|---|---|
| Archive | /home/user/mct-security-releases/mct-security-stack-release-20260816-014828.tar.gz |
| Size | 536K |
| Files | 1015 |
| Sensitive files | 0 (gate verified) |
| sha256 | 8d4dc40291a6d1906540bf774da4b44f8380a3050050273bda10a89c2b45ca7d |
| Manifest | release-manifest.json (repo root) + releases/release-manifest-20260816-014828.json |
| Release notes | RELEASE-NOTES.md |

## Build process

- Script: scripts/ci/build-release-bundle.sh (dry-run by default, --apply to build).
- Dry run reviewed includes/excludes, then --apply executed.
- Output dir: MCT_RELEASE_OUT (default /home/user/mct-security-releases; falls
  back to sudo mkdir if needed).
- Post-build gate: scans bundle listing for creds.env, client.config.yaml,
  .env (except examples), *.key/*.pem, *.sql.gz, *.pcap, *.evtx - fails build
  and lists leaked filenames.

## Issues found and fixed during build

1. INCLUDE had phantom path reporting/client-safety (does not exist) - tar
   failed; corrected to actual reporting/ subdirs.
2. Output dir /opt/mct-security-stack-backups not writable (root-owned, sudo
   password unavailable) - default switched to /home/user/mct-security-releases.
3. Gate initially flagged config/examples/secrets.example.env (intentional
   placeholder file) - gate now exempts *.example* / /examples/.

## Exclusions verified

.git, ops/backups, data, .env, creds.env, client.config.yaml, *.key, *.pem,
*.sql.gz, *.tar.gz, *.zip, *.pcap, *.evtx, shuffle-periodic-repair.log, *.pyc.

## Notes

- Bundle contains no live secrets; secrets.example.env is placeholders-only and
  intended for distribution.
- First external distribution requires operator review + approval.

## No secrets

No secret values printed.
