# Phase 21 v1.1.0 Release Record

Date: 2026-08-19
Status: **COMPLETE - v1.1.0 PUBLISHED** (release object + asset created 2026-08-19 07:27 UTC via operator PAT, in-memory).

## Done

| Item | Detail |
|---|---|
| Final gates | Local CI PASS; secret scan PASS; credential cleanup done; wazuh-docker protected; no secrets pushed |
| Tag created + pushed | `v1.1.0` -> 85cba85, pushed to origin (visible via public API refs/tags/v1.1.0) |
| Portable bundle built | `/home/user/mct-security-releases/mct-security-stack-release-20260819-072400.tar.gz` (3,746,989 bytes) |
| Bundle clean | sensitive-file count 0; sha256 `25d35eb6c4df2e310ecf95f38849b14fa188f60a621a37af7b1b82371c089625` |
| Manifest | `release-manifest-20260819-072400.json` + copied to `repo-artifact-cache-manifest.json` pattern |
| Bundle mirrored | `/opt/mct-security-stack-backups/releases/` (P14 pattern) |
| Release notes | RELEASE-NOTES.md updated (v1.1.0 section); release body prepared at /tmp/release-body-v110.md |

## Pending

- None - release complete. (PAT was used in-memory only; never persisted or committed.)

## Published release (verified)

- URL: https://github.com/MaineCyberTech/soc/releases/tag/v1.1.0
- Release object: id 372865326, published 2026-08-19T07:27:33Z.
- Asset: `mct-security-stack-release-20260819-072400.tar.gz` (3,746,989 bytes, state uploaded).

## Post-release

- Update README deployment date / CI badge if desired (optional).
- v1.0.0 remains the latest published release object until the PAT step completes.

## No secrets