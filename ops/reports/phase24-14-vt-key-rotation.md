# Phase 24 VirusTotal Key Rotation

Date: 2026-08-22
Status: **BLOCKED - REPLACEMENT KEY REQUIRED** (C4).

## 1. State

- Live VT api_key in wazuh_manager.conf (skip-worktree; env-render path ready via
  render-virustotal-integration.sh).

## 2. Procedure (when key provided)

1. Set VIRUSTOTAL_API_KEY in ops/creds.env (600).
2. `bash ops/scripts/render-virustotal-integration.sh` (idempotent; backup; no value output).
3. Restart analysisd; verify integration init (no VT errors in logs).
4. Trigger on test hash; confirm alert without printing key.
5. Revoke old key after 24h clean.

## 3. Blocker

- Replacement key (VirusTotal account). No value printed.

## No secrets