# Phase 24 Canonical Sanitized Manager Config

Date: 2026-08-22
Status: **CREATED** - repo-safe canonical reference established.

## 1. Artifact

- `config/wazuh_cluster/wazuh_manager.conf.canonical` (repo, commit-able):
  - Current **9 allowed-ips** (matches running; closes the P22 "7 vs 9" drift gap).
  - `api_key` replaced with `<REPLACE_VIA_RENDER_VIRUSTOTAL_SCRIPT>` placeholder.
  - Header documents deploy + render steps. No secrets.

## 2. Deploy guidance (in header)

1. Copy to `/opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf`.
2. Run `ops/scripts/render-virustotal-integration.sh` (injects live key from creds.env).
3. Restart analysisd on change; keep skip-worktree protection on the deployed file.

## 3. Drift control

- Future drift checks compare running ossec.conf against this canonical (Phase 24.19).

## No secrets