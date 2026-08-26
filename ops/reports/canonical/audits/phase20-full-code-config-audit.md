# Phase 20 Full Code / Config Audit

Date: 2026-08-19
Method: syntax checks (bash -n, python py_compile), XML validation, YAML validation, repo-vs-running drift comparison. Research only.

## 1. Shell scripts - PASS

- 65 scripts checked (`ops/scripts` 47 + `scripts` 18); all pass `bash -n`.
- Wazuh-host scripts (10) also pass.

## 2. Python tools - PASS

- 9 MCT-owned .py compile clean (py_compile).
- No hardcoded secrets in Python (env/file-based credential use).
- Duplication: `generate-alert-quality-report.py` and `generate-monthly-scorecard.py` are
  byte-identical in `ops/scripts/` and `reporting/generators/` (maintenance smell).

## 3. PowerShell - PASS (presence + no secret literals)

- 4 .ps1 under `scripts/endpoint-deploy/` exist and are referenced; CI only checks presence (documented limitation).

## 4. Wazuh rules / decoders

- All custom rule XMLs well-formed except `integrations/opencanary/wazuh-decoder-plan.xml`
  (multi-root planning doc - convert to .md).
- No rule ID conflicts between custom rules and stock ruleset; overwrite=yes overrides intentional.
- Zeek rules deployed byte-identical to repo (v2.2).

## 5. Docker compose

- MCT compose (7) + wazuh-docker compose valid (override `!override` tag is a compose extension; `docker compose config` RC=0).
- **Unpinned images**: 40 refs across 11 files (many `:latest`/tag-only) - see CI audit.

## 6. CI workflows

- `verify.yml` valid; all referenced scripts exist.

## 7. Config drift (repo vs running)

- ossec.conf remote block: NO DRIFT (9 allowed-ips match).
- Rule 120537: NO LEVEL DRIFT (both level 3; description suffix differs - cosmetic).
- Zeek rules: NO DRIFT (byte-identical v2.2).

## 8. Docs

- REPO-MAP.md, ARCHITECTURE.md current-ish (2026-08-16); STACK-OVERVIEW.md header stale (2026-08-10); README deployment date stale (2026-08-10).

## Key issues (detailed in phase20-code-quality-backlog.md + phase20-config-drift-audit.md)

1. Hardcoded default creds in `endpoint-count-report.sh`, `client013-baseline-report.sh` (WAZUH_WUI_PASSWORD), `capacity-threshold-check.sh` (PVE_PASSWORD).
2. Hardcoded creds in `docker-compose.override.yml` (elastiflow/flow-relay) and VirusTotal API key in `wazuh_manager.conf`.
3. Zeek rule file header labels v2.1 but contains v2.2 guard.
4. Uncommitted Phase 19/20 state (77 files).

## Verdict

All executable code passes syntax/compile. No config drift between deployed and repo rules.
Actionable items are credential-hygiene and repo-hygiene.

## No secrets