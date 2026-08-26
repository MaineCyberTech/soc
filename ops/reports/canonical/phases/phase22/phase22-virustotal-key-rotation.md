# Phase 22 VirusTotal Key Rotation

Date: 2026-08-22
Status: **BLOCKED - REPLACEMENT KEY REQUIRED** (approval + new key from VirusTotal account not available this phase).

## 1. Current state

- Live VT api_key lives in `config/wazuh_cluster/wazuh_manager.conf` (mounted as ossec.conf).
- Protected by `git update-index --skip-worktree` (P21) - local mod cannot be committed/pushed.
- No replacement key available -> rotation cannot be executed.

## 2. What was prepared (so rotation is one step when key arrives)

- Render approach: `ops/scripts/render-virustotal-integration.sh` reads `VIRUSTOTAL_API_KEY`
  from ops/creds.env and writes the `<integration>` block into the manager conf at deploy time
  (idempotent; tracked config holds `<api_key><REDACTED></api_key>` placeholder only).
- (Script created as part of env abstraction - Phase 22.16.)

## 3. Rotation steps (when key provided)

1. Set new key in ops/creds.env (VIRUSTOTAL_API_KEY, 600).
2. Run render script -> updates wazuh_manager.conf api_key (file stays skip-worktree).
3. Restart wazuh-analysisd (minimal) -> verify integration initializes.
4. Trigger VT integration on a known hash; confirm alert/response without printing the key.
5. After 24h clean, revoke old key in VirusTotal console.

## 4. Blocker

- **Replacement key required from VirusTotal account** (owner: SOC operator). Documented;
  no key values printed.

## No secrets