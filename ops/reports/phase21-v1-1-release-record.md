# Phase 21 v1.1.0 Release Record

Date: 2026-08-19
Status: **TAG + BUNDLE PUBLISHED - GITHUB RELEASE OBJECT PENDING OPERATOR PAT** (same as v1.0.0 process).

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

## Pending (single step - operator PAT, in-memory)

Create the GitHub release object + attach the asset (mirrors P14 which used an operator-provided
PAT in-memory, never persisted):

```bash
export GITHUB_TOKEN='<operator PAT>'
gh release create v1.1.0 /home/user/mct-security-releases/mct-security-stack-release-20260819-072400.tar.gz \
  --repo MaineCyberTech/soc --title "MCT Security Stack v1.1.0" --notes-file /tmp/release-body-v110.md
# or via API: curl -X POST -H "Authorization: token $GITHUB_TOKEN" ... (see checklist)
```

## Post-release

- Update README deployment date / CI badge if desired (optional).
- v1.0.0 remains the latest published release object until the PAT step completes.

## No secrets