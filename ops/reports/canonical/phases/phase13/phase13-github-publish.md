# Phase 13 GitHub Publish

Date: 2026-08-16

## Status: PUSHED TO GITHUB (successful)

## What was done (operator-approved push path)

| Step | Result |
|---|---|
| Git identity | set (local): Maine Cyber Tech SOC / soc@mainecybertech.com |
| Branch | main created |
| Initial commit | f14ba1b "Initial commit: MCT Security Stack portable repo" - 987 files, 40,935 insertions |
| Secret verification | git ls-files CLEAN (no creds/env/keys/pems/dumps/archives) |
| SSH key | generated ~/.ssh/github (ed25519), added to GitHub as deploy key |
| Remote | origin = git@github.com:MaineCyberTech/soc.git (repo moved from mainecybertech/soc) |
| Push | SUCCESS - f14ba1b -> main |
| CI fix commit | 0f22899 "CI: set MCT_STACK_ROOT to runner workspace" (fixed layout check) |
| CI result | PASS on 0f22899 |

## Repository

- URL: https://github.com/MaineCyberTech/soc (branch main, f14ba1b/0f22899)

## Notes

- Repo originally created under `mainecybertech/soc`; GitHub redirects to
  `MaineCyberTech/soc` (org casing). Remote updated accordingly.
- Initial CI failure (f14ba1b) was the repo-only checks defaulting ROOT to
  /opt/mct-security-stack (not present on runner). Fixed by exporting
  MCT_STACK_ROOT=$PWD in verify.yml.

## No secrets

No secret values printed.
