# Phase 22 Wazuh Live Secret Rotation Plan

Date: 2026-08-22
Variable names only - no values.

## 1. Live secret inventory

| Secret (variable) | Location (protected) | Used by | Rotation risk |
|---|---|---|---|
| WAZUH_ADMIN_PASSWORD | ops/creds.env (600) + wazuh-docker .env (600) | indexer basic auth, scripts, elastiflow (EF_OUTPUT_OPENSEARCH_PASSWORD), flow-relay (ES_PASS) | indexer users must rotate in-cluster first |
| WAZUH_WUI_PASSWORD | ops/creds.env + dashboard wazuh.yml | Wazuh API (wazuh-wui) | API user rotation |
| INDEXER_PASSWORD / API_PASSWORD / DASHBOARD_PASSWORD | wazuh-docker .env (templated P22) | compose env for indexer/dashboard/API | in-cluster user rotation + compose recreate |
| VIRUSTOTAL_API_KEY | wazuh_manager.conf (skip-worktree, P21) | VT integration | needs replacement key (blocked) |
| TUNNEL_TOKEN | .env.cloudflare (600) | Cloudflare tunnel | cloudflare rotation |
| SO_SSH_PASSWORD / PVE_PASSWORD | ops/creds.env (600) | automation SSH | host-side |
| WAZUH_REGISTRATION_PASSWORD | ops/creds.env (600) | agent enrollment | only for new agents |
| DO_SPACES_ACCESS_KEY / SECRET_KEY | ops/creds.env (600) | DR S3 | DO Spaces console |

## 2. Owners / dependencies / sequence

1. **Indexer admin (WAZUH_ADMIN_PASSWORD family)** - rotates cluster-wide; sequence:
   a. set new password in indexer (internal_users.yml / API) -> b. update ops/creds.env +
   wazuh-docker .env + dashboard wazuh.yml (WUI) -> c. restart indexers + dashboard ->
   d. verify cluster health + dashboard login + scripts -> rollback: restore old values + restart.
2. **VirusTotal** - needs new key from VirusTotal account; then render into manager conf +
   restart analysisd; verify integration fires on a test hash.
3. **Others** - isolated (tunnel/SSH/DO/registration), rotate per-owner.

## 3. Validation & rollback

- Validation: cluster health green, dashboard/API auth OK, elastiflow/flow-relay indices fresh,
  VT integration event on demand, scripts RC 0.
- Rollback: restore prior value in the single store (creds.env/.env), restart affected service.
- Every rotation is approval-gated and recorded (checklist).

## 4. Current state (P22)

- Compose literals -> `${VAR}` refs via wazuh-docker .env (done, verified `docker compose config`
  RC=0; no container recreation). Runtime values unchanged.
- VT key: still in skip-worktree-protected file; rotation blocked on replacement key (22.14).

## Files

- `ops/reports/phase22-wazuh-secret-rotation-plan.md` (this)
- `ops/checklists/phase22-secret-rotation-checklist.md`

## No secrets