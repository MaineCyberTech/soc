# Phase 22 Wazuh Docker Environment Abstraction

Date: 2026-08-22
Status: **IMPLMENTED (templating + .env) - VT render path added - rotation still approval-gated.**

## 1. What was done

- Compose literals -> `${VAR}` refs (5 secrets) with values in wazuh-docker `.env` (600, gitignored).
- `docker compose config` verified (RC=0, refs substituted).
- `ops/scripts/render-virustotal-integration.sh` created for env-sourced VT key rendering.
- skip-worktree/exclude protections retained as defense-in-depth (not primary control).
- Documented in `docs/WAZUH-DOCKER-SECRET-ABSTRACTION.md` (deployment, validation, migration, rotation).

## 2. Residual reliance on skip-worktree

- Reduced for compose (env-based now). VT api_key still rendered into the tracked-but-skipworktree
  wazuh_manager.conf; migration to a generated-config model deferred (render script is the
  interim mechanism; a future config include/init-d container step can fully remove it).

## 3. Verification

- `docker compose config` resolves; containers untouched; backups retained.

## No secrets