# Phase 39 AGENTS Command Validation — Every Planned Path/Command Tested Live

**Report ID:** phase39-58-agents-command-validation
**Phase:** 39
**Title:** Live Validation of Every Command and Path Slated for AGENTS.md — All PASS; Credential Values Never Written to File Content
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:12:59Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-58-agents-command-validation.md`

---

## 1. Method

Every command/path planned for inclusion in `/opt/mct-security-stack/AGENTS.md` was executed
or stat-tested immediately before authoring the proposal (phase39-61). Secret values were
used at runtime only, sourced from `/opt/wazuh-docker/multi-node/ops/creds.env`; no value is
reproduced here or in AGENTS.md.

## 2. Validation Table

| Command / path | Expected | Result |
|---|---|---|
| `test -x ops/scripts/p38-report-ci.sh` | executable | **PASS** |
| `ls compose/docker-compose.shuffle.yml` | exists | **PASS** |
| `git rev-parse --show-toplevel` | `/opt/mct-security-stack` | **PASS** |
| `git rev-parse HEAD` | `04e689d…` (+ P39 changes pending) | **PASS** (`04e689dba76d7044041a736233d9b248d0ef618c`) |
| `docker ps -f name=shuffle-backend --format '{{.Names}}'` | returns value | **PASS** → `shuffle-backend` |
| Indexer health via auth pattern `-u "admin:${WAZUH_ADMIN_PASSWORD}"` (sourced from `/opt/wazuh-docker/multi-node/ops/creds.env`, mode 600) against `https://127.0.0.1:9200/_cluster/health` | HTTP 200 JSON | **PASS** → `wazuh-cluster green 3` |
| `_snapshot` API query | repos listed | **PASS** → `wazuh-backup`, `do-spaces` |
| `_index_template/wazuh-archives-fieldlimit` | template exists | **PASS** → limit 2000, pattern `wazuh-archives-4.x-*` |
| `stat -c '%a' config/shuffle-api-key` | 600 + gitignored | **PASS** (600; `git check-ignore` confirms) |
| `stat -c '%a' /opt/wazuh-docker/multi-node/ops/creds.env` | 600 | **PASS** |
| `git check-ignore compose/.env` | ignored via `.env` rule | **PASS** |
| Existence sweep: `p29-image-ci-gate.sh`, `p30-audit-gate.sh`, `secret-pattern-scan.sh`, `shuffle-repair-network.sh`, `docs/SECRET-HANDLING.md`, `REPO-MAP.md`, `SECURITY.md`, `README.md`, `RELEASE-NOTES.md`, `release-manifest.json`, canonical docs (38-49/47/90), `ops/backups/agents` | all exist | **PASS** (15/15 OK) |

## 3. Auth-Pattern Note

The indexer rejects the legacy literal password guess used in some older reports; scripts of
record authenticate with `admin:${WAZUH_ADMIN_PASSWORD}` loaded from the creds.env path.
AGENTS.md therefore references **the path and variable name only** — never a value — which is
both rotation-safe and secret-safe.

## Verdict

Validation COMPLETE: 100% of planned references resolve live today.
