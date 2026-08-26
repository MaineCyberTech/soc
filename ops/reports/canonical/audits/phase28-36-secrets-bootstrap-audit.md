# Phase 28 Secrets Bootstrap Audit

Date: 2026-08-24

## Required secrets map

| Secret | Creation/rotation source | Storage (perms) | Bootstrap | Unavailable behavior | Post-install validation |
|---|---|---|---|---|---|
| WAZUH_ADMIN_PASSWORD | compose initializer / rotation | wazuh-docker .env (0600) | compose env | indexer fails -> abort | curl admin auth |
| WAZUH_WUI_PASSWORD | dashboard config | wazuh.yml (skip-worktree) | wazuh-docker | dashboard 401 | API authenticate |
| INDEXER_PASSWORD | rotation (approval C9) | .env (0600) | compose | dependent services fail -> rollback | cluster health |
| SHUFFLE_API_KEY/ORG | Shuffle console | ops/.env (0600) | manual from console | workflow read-only | API call |
| DO_ACCESS/SECRET | DO console | creds.env (0600) | manual | S3 DR unavailable | s3cmd ls |
| GH_PAT | GitHub console | ops/.env (0600) | memory-only | release blocked | gh api |
| PVE_TOKEN | PVE console | creds.env (0600) | manual | PVE222 401 (current FAIL) | pve api |
| VT_API_KEY | VT console | ops/.env (0600) | manual | enrichment blocked | vt api |
| Endpoint Sysmon backups | endpoint filesystem | local | RMM | n/a | check script |

## Findings

- All secret stores are 0600/gitignored; **no committed secrets** (secret scan PASS).
- **2 scripts embed a fallback literal password** (client013-baseline-report.sh,
  endpoint-count-report.sh: (placeholder)) - must fail-closed (P1 remediation, 48).
- Velociraptor `server.config.yaml` holds RSA private keys - gitignored/local-only; **must
  be excluded from any release bundle** (bundle gate covers data/).
- First-install bootstrap: compose env files generated from profile templates + operator
  supplies real values; validation = the checks above.

## No secrets