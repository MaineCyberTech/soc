# Phase 22 Wazuh Compose Secret Templating

Date: 2026-08-22

## What changed

| File | Before | After |
|---|---|---|
| docker-compose.yml | literals: INDEXER_PASSWORD, API_PASSWORD, DASHBOARD_PASSWORD | `${INDEXER_PASSWORD}`, `${API_PASSWORD}`, `${DASHBOARD_PASSWORD}` |
| docker-compose.override.yml | literals: EF_OUTPUT_OPENSEARCH_PASSWORD, ES_PASS | `${EF_OUTPUT_OPENSEARCH_PASSWORD}`, `${ES_PASS}` |
| .env (new) | - | mode 600, user-owned, gitignored; holds the 5 values |

## Verification

- `docker compose config`: RC=0, 560 lines, all refs substituted, services intact.
- No container recreation; runtime unchanged.
- Backups: `docker-compose.yml.bak-phase22`, `docker-compose.override.yml.bak-phase22`.
- skip-worktree protections on tracked files retained (defense in depth).

## Rotation implication

- Rotating = update .env + creds.env + dashboard wazuh.yml, then targeted recreate (approval-gated,
  see phase22-indexer-password-rotation.md).

## No secrets