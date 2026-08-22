# Wazuh Docker Secret Abstraction

Applies to `/opt/wazuh-docker/multi-node` (clone of the public `wazuh/wazuh-docker` repo).
Goal: reduce reliance on `git update-index --skip-worktree` as the primary control and move
to protected environment files, preserving upstream compatibility.

## Current state (Phase 22)

- Compose literals templated to `${VAR}` refs: INDEXER_PASSWORD, API_PASSWORD,
  DASHBOARD_PASSWORD, EF_OUTPUT_OPENSEARCH_PASSWORD, ES_PASS.
- Values live in `/opt/wazuh-docker/multi-node/.env` (mode 600, user-owned, gitignored by
  upstream `.gitignore`).
- `config/wazuh_cluster/wazuh_manager.conf` (VirusTotal key): still skip-worktree-protected;
  `ops/scripts/render-virustotal-integration.sh` provides an env-sourced render path.
- `docker-compose.override.yml`: in `.git/info/exclude` (untracked local file).

## Safeguards (layered)

1. Values never in tracked files (only `${VAR}` refs / placeholders).
2. Protected stores: `ops/creds.env`, wazuh-docker `.env`, `.env.cloudflare` - all mode 600,
   gitignored.
3. skip-worktree / .git/info/exclude as belt-and-braces against accidental staging.
4. `docker compose config` validation step before any deployment.

## Deployment / validation steps

```bash
cd /opt/wazuh-docker/multi-node
# validate env resolution before any recreate:
docker compose config > /dev/null && echo "config resolves"
# after changing .env values, recreate only affected services:
docker compose up -d --force-recreate wazuh1.indexer wazuh2.indexer wazuh3.indexer wazuh.dashboard
# then elastiflow + flow-relay (override services)
docker compose up -d --force-recreate elastiflow flow-relay
# verify: cluster health green; elastiflow/flow-relay index growth fresh
```

## Migration plan (upstream compatibility)

- Templating uses upstream-style `${VAR}` interpolation; a stock upstream `docker-compose.yml`
  would also resolve these vars if provided via .env - no schema changes.
- If upstream merges change the compose files, re-run the templating step (backups retained),
  re-verify `docker compose config`.
- VT integration: keep `<api_key>` placeholder in tracked config; render real value via
  `render-virustotal-integration.sh` (never commit the rendered file).

## Rotation (see ops/checklists/phase22-secret-rotation-checklist.md)

- Update stores (.env / creds.env / wazuh.yml), targeted recreate, verify, rollback path.

## No secrets