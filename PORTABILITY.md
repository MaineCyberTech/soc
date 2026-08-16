# MCT Security Stack - Portability

Date: 2026-08-16

## Purpose

This repo can be packaged for handoff to future operators or AI agents. The
portable bundle contains only current source/docs/templates - no secrets, no
operational data, no vendored code.

## What's in the portable bundle

```
README.md, REPO-MAP.md, ARCHITECTURE.md, PORTABILITY.md, SECURITY.md
.env.example, .gitignore.example
config/examples/
scripts/ (bootstrap/, verify/, endpoint-deploy/)
ops/ (runbooks/, scripts/, checklists/, reports/ CURRENT only)
integrations/
reporting/ (templates/, generators/, output/ structure)
client-onboarding/
service-packaging/
evidence/ (historical reports index + banners)
```

## What's excluded

| Item | Reason |
|---|---|
| .env, ops/creds.env, .env.cloudflare | secrets |
| ops/backups/ | operational data (2.6G dumps) |
| data/ | vendored third-party |
| historical reports (in ops/reports) | moved to evidence/ (copies) |

## How to package

```bash
bash scripts/verify/verify-portable-repo.sh   # check layout
bash scripts/bootstrap/check-prereqs.sh       # check tooling
# then create a tarball of the included paths only (see packaging script in P11.07)
```

## How to restore on a new host

1. Copy the portable bundle.
2. Create .env from .env.example (populate real values).
3. Run scripts/bootstrap/create-directories.sh.
4. Run scripts/verify/verify-current-architecture.sh.
5. Point ops scripts at the new roots (WAZUH_STACK_ROOT / MCT_STACK_ROOT).

## Environment variables

- MCT_STACK_ROOT=/opt/mct-security-stack
- WAZUH_STACK_ROOT=/opt/wazuh-docker/multi-node
- All secrets via creds.env / .env (never in repo).

## No secrets

No secret values printed.
