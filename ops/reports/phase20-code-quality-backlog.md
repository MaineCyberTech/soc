# Phase 20 Code Quality Backlog

Date: 2026-08-19

## HIGH

1. **Hardcoded default credential values in scripts**
   - `ops/scripts/endpoint-count-report.sh` (~line 18): `${WAZUH_WUI_PASSWORD:-<literal>}`
   - `ops/scripts/client013-baseline-report.sh` (~line 18): same pattern
   - `ops/scripts/capacity-threshold-check.sh` (~lines 31,34): `${PVE_PASSWORD:-<literal>}`
   - Fix: empty fallback + explicit error if unset (fail-closed), consistent with other scripts.
2. **Hardcoded credentials in compose/config**
   - `compose/docker-compose.override.yml`: `EF_OUTPUT_OPENSEARCH_PASSWORD`, `ES_PASS` inline.
   - `config/wazuh_cluster/wazuh_manager.conf`: VirusTotal API key inline (version-controlled).
   - Fix: move to env/secrets (${VAR} interpolation / secrets file), remove from git.

## MEDIUM

3. **Local CI false-PASS risk** - `scripts/ci/run-local-ci.sh` bash/python syntax loops use
   `|| echo "FAIL"` without setting a fail flag; local CI can report PASS with broken scripts.
4. **Unpinned-image coverage gap** - `check-unpinned-docker-images.sh` scans only
   `$ROOT/compose/*.yml`, not `/opt/wazuh-docker/multi-node` compose files.
5. **Uncommitted Phase 19/20 state** (77 files; HEAD = Phase 18).
6. **STACK-OVERVIEW.md stale header** (2026-08-10) + README deployment date stale.

## LOW

7. Zeek rule file header self-labels "DEPLOYED (v2.1)" while content is v2.2 - bump header / add v2.2 file.
8. Duplicate byte-identical Python generators (ops/scripts vs reporting/generators).
9. Committed `__pycache__`/`.pyc` under `ops/scripts` and `scripts/reporting`.
10. `integrations/opencanary/wazuh-decoder-plan.xml` not well-formed XML (plan doc) - convert to .md.
11. `full-stack-healthcheck.sh` transmits SO_SSH_PASSWORD via `echo | sudo -S` over ssh (remote cmdline exposure); several scripts hardcode `/opt/wazuh-docker/multi-node/ops/creds.env` instead of `$WAZUH`.

## No secrets