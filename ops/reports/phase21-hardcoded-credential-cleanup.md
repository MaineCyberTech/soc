# Phase 21 Hardcoded Credential Cleanup

Date: 2026-08-19

## Findings remediated

### mct-security-stack repo (will be committed)

| File | Before | After |
|---|---|---|
| ops/scripts/endpoint-count-report.sh | `wazuh-wui:${WAZUH_WUI_PASSWORD:-<REDACTED>}` (hardcoded default) | fail-fast `: "${WAZUH_WUI_PASSWORD:?}"` + `${WAZUH_WUI_PASSWORD}` |
| ops/scripts/client013-baseline-report.sh | same hardcoded default | fail-fast + env var |
| ops/scripts/capacity-threshold-check.sh | `${PVE_PASSWORD:-<REDACTED>}` (x2) | fail-fast `: "${PVE_PASSWORD:?}"` + `${PVE_PASSWORD}` |
| ops/runbooks/phase9-p1-credential-rotation.md | literal admin password | variable-name reference `${INDEXER_PASSWORD}/WAZUH_ADMIN_PASSWORD` |

- Added `WAZUH_WUI_PASSWORD` to `ops/creds.env` (local, mode 600) so the fixed scripts keep working.
- Verified: no credential literals remain in any `.sh/.py/.yml/.xml/.conf/.md` source file;
  all fixed scripts pass `bash -n`; endpoint-count-report still runs.

### wazuh-docker repo (public-origin clone - NOT pushed, protected)

| File | Risk | Action |
|---|---|---|
| config/wazuh_cluster/wazuh_manager.conf | live VirusTotal api_key in tracked file (local mod) | `git update-index --skip-worktree`; committed version verified clean; **rotate key** (P22) |
| docker-compose.yml | indexer password literal (local mod) | `git update-index --skip-worktree`; committed version verified clean |
| docker-compose.override.yml | indexer password literals (untracked) | added to `.git/info/exclude` |

## VirusTotal key assessment

- Key exists only in the local working tree (never committed/pushed - verified via
  `git show HEAD:...` clean). Exposure risk = on-disk plaintext in a tracked file's working
  tree. Recommended: **rotate** at the next planned rotation window; file is now
  skip-worktree-protected.

## Remaining (documented, not blocking commit)

- `docker-compose.misp.yml`, `integrations/wazuh/custom-filebeat-archives-plan.md`,
  `integrations/levelio/phase8-device-group-results.md` show `<value-hidden>` pattern hits
  (scanner-redacted variable references, not live values). Reviewed as acceptable.

## Result

Hardcoded credential defaults removed; fail-fast behavior in place; live secrets confined to
mode-600 local files; public-origin wazuh-docker clone protected against accidental push.
Secret scan re-run = PASS (RC 0, no values printed).

## No secrets