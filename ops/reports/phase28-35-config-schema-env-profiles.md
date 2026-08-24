# Phase 28 Config Schema and Environment Profiles

Date: 2026-08-24
Status: **ADDED** (config/schema.json + config/profiles/*.env.example).

## What was created

- `config/schema.json`: machine-readable config schema (4 profiles, no-secrets rule,
  defaults policy, per-profile required vars, 26 component fields per consolidation schema).
- `config/profiles/{lab,production,client,scratch}.env.example`: profile templates with
  **placeholders only** (${VAR} references), verified secret-clean.

## Design

| Profile | Purpose | Required vars (refs) |
|---|---|---|
| lab | isolated/test | WAZUH_*, SHUFFLE_* |
| production | live stack | WAZUH_*, SHUFFLE_*, DO_*, GH_PAT, PVE_*, VT_* |
| client | per-client | CLIENT_ID/NAME, SCAN_SCOPE, SCAN_AUTH_FILE |
| scratch | DR drill | SCRATCH_ADMIN_PASSWORD, SCRATCH_REPO_LOCATION, SCRATCH_PORTS, SCRATCH_INDEX_PREFIX |

## Rules

- No secrets in source; values resolved at runtime from 0600 env files.
- Defaults: secure/fail-closed (missing required var -> install aborts).
- Validation: `p28-fresh-target-gate.sh` requires the target profile to exist.

## Note

- Existing runtime env files (wazuh-docker `.env` 0600, ops/creds.env 0600) already follow
  the ${VAR} pattern; profiles codify the contract for clean installs.

## No secrets