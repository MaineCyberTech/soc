# Phase 25 VirusTotal Key Rotation

Date: 2026-08-22
Status: **BLOCKED - REPLACEMENT KEY REQUIRED** (unchanged).

## State + procedure

- VT api_key in wazuh_manager.conf (skip-worktree; env-render path ready).
- On replacement: render via ops/scripts/render-virustotal-integration.sh -> restart analysisd
  -> verify integration on test hash -> revoke old key after 24h.

## Blocker

- Replacement key (VirusTotal account). No value printed.

## No secrets