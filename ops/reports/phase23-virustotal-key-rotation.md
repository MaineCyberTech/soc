# Phase 23 VirusTotal Key Rotation

Date: 2026-08-22
Status: **BLOCKED - REPLACEMENT KEY REQUIRED** (approval + new key unavailable this phase).

## 1. State

- Live VT api_key in wazuh_manager.conf (skip-worktree protected; env-render path ready via
  `ops/scripts/render-virustotal-integration.sh`).

## 2. Rotation procedure (when key provided)

1. Set new key: ops/creds.env `VIRUSTOTAL_API_KEY=<value>` (600).
2. `bash ops/scripts/render-virustotal-integration.sh` -> idempotent api_key update (backup +
  no value output).
3. Restart wazuh-analysisd (minimal); verify integration initializes (no VT errors in logs).
4. Trigger VT integration on a known test hash; confirm alert without printing key.
5. After 24h clean: revoke old key in VirusTotal console.

## 3. Blocker

- Replacement key from VirusTotal account (owner: SOC operator). No value printed anywhere.

## No secrets