# Phase 38-82: Code Audit Report

**Report ID:** phase38-82-code-audit
**Phase:** 38
**Title:** Phase 38-82: Code Audit Report
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-82-code-audit.md`

| Field | Value |
|-------|-------|
| **Report ID** | phase38-82 |
| **Generated** | 2026-08-25 21:17 UTC |
| **Classification** | Internal / Operational |
| **Owner** | MCT SOC |
| **Status** | PARTIAL |

**Status:** PARTIAL
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-82-code-audit.md`
**Retention Class:** LONG

---

## 1. Executive Summary

The ops script estate is **86 shell scripts** (plus Python helpers) under `/opt/mct-security-stack/ops/scripts/`, all carrying the executable bit (0 violations). 46 files contain the strings `password|token|secret` (mostly as env-var lookups — acceptable; no hardcoded secrets found in scripts themselves). However, **plaintext credentials persist in 5 generated reports**, including the three previously identified locations, and **28 scripts are unreferenced** by any generated report (dead-code candidates).

## 2. Script Inventory

```
$ ls -la /opt/mct-security-stack/ops/scripts/*.sh | wc -l   → 86
$ ls /opt/mct-security-stack/ops/scripts/ | wc -l           → 104 entries
    (86 *.sh + *.py helpers + __pycache__ + example files)
```

Series coverage: phase2/5/6 legacy ops, p28–p35 audit series, backup/DR (`vm103-*`, `prune-*`, `es-snapshot-*`), Shuffle (`shuffle-healthcheck`, `shuffle-repair-network`, `shuffle-workflow-export`, `shuffle-webhook-smoke-test`), MISP/Greenbone feed scripts, guardrails (`zeek-classa-guardrail`, `p33-core-alert`), secret scanners (`secret-pattern-scan.sh`, `scan-docs-for-secret-patterns.sh`).

### Executable-bit audit

```
$ find /opt/mct-security-stack/ops/scripts -maxdepth 1 ! -perm -111 -name "*.sh" | wc -l
0
```
PASS — every `.sh` is executable.

### Secret-pattern exposure count

```
$ grep -ilE "password|token|secret" /opt/mct-security-stack/ops/scripts/*.sh *.py | wc -l
46
```
Manual spot-check of the matches shows they reference env vars / config paths (e.g., `${WAZUH_WUI_PASSWORD}`, "never printed" comments) rather than literal credentials. No live secret literals found in scripts. COUNT ONLY recorded per policy.

## 3. Compose Files Inventory

17 compose YAMLs across the stack:

- Stack services: `compose/docker-compose.{dfir-iris,greenbone,misp,opencanary,phase2,shuffle,velociraptor}.yml` (7)
- IRIS upstream: `data/dfir-iris/iris-web/docker-compose{,.base,.dev}.yml` (3)
- Wazuh platform: `/opt/wazuh-docker/multi-node/docker-compose{,.override,.cloudflare}.yml`, `single-node/docker-compose.yml`, `wazuh-agent/docker-compose.yml` (5)
- Rollback snapshots: `ops/backups/p29-image-pin-rollback/*.yml` (2)

## 4. Dead-Code Candidates

Scripts referenced by ZERO files in `generated/` (28):

`common.sh, p28-consolidation-candidates.sh, p30-{audit-gate,codebase-audit,infrastructure-audit,memory-audit,runtime-drift-audit}.sh, p31-ci-summary.sh, p31-sensor-benchmark.sh, p31-suricata-config-gate.sh, p31v2-packet-evidence.sh, p32-rule-inventory.sh, p32-wazuh-suricata-logtest.sh, p33-alert-runner.sh, p33-observe-snapshot.sh, p33-release-provenance.sh, p34-alert-selftest.sh, p34-canary-evidence.sh, p34-zero-alert-integrity.sh, p35-agent016-config-audit.sh, p35-canary-manifest.sh, phase2-integration-smoke-test.sh, phase2-port-audit.sh, phase5-credential-postcheck.sh, phase6-resource-validation.sh, post-ram-health-validation.sh, resource-post-change-validation.sh, zeek-classa-guardrail.sh`

Caveats before deletion: several ARE wired in crontab (`p33-core-alert` runs */15; note `zeek-classa-guardrail` also cron-wired despite zero report references — reports reference it by log path, not script name). Grep was against `generated/` only; historical corpus may cite others. Disposition: mark DO-NOT-DELETE until crontab cross-reference pass completes.

### p33–p38 series review

17 scripts (`p33-*`: 7, `p34-*`: 6, `p35-*`: 5; nothing prefixed p36/p37/p38 — later phases used inline commands). Quality is consistent: `set -euo pipefail`, secret-safe patterns ("Never prints secrets"), idempotent check/apply modes. Two dead in-series candidates: `p33-alert-runner.sh`, `p34-alert-selftest.sh` (superseded by `p33-core-alert.sh` cron loop).

## 5. Secrets-in-Code Findings — REDACT REQUIRED (P0)

Three known plaintext credential locations in the generated report corpus were confirmed present at exactly the cited positions:

| Location | Content observed | Severity |
|----------|------------------|----------|
| `phase38-00-master.md:63` | Operator auth line: `soc@*** / P******@ [REDACTED]` | P0 |
| `phase38-01-preflight.md:131` | Bearer token literal for Shuffle API (bearer literal [REDACTED]) alongside account name | P0 |
| `phase38-73-shuffle-hardening.md` §Step 1 (~line 31) | Shuffle migration command embedding two credential-looking arguments ([REDACTED args]) | P0 |

Corpus-wide sweep: **5 generated files** match cred patterns `[REDACTED pattern list — see scanner config]`:
`phase38-00-master.md, phase38-02-change-register.md, phase38-13-current-state-claims.md, phase38-50-generate-verification-ledger.md, phase38-90-backlog.md`.

This directly contradicts the stack's own no-secret-in-reports attestation (release manifest records `sensitive_files: 0`). Required remediation: redact all five files, rotate the exposed Shuffle bearer token and dashboard password (rotation already deferred in phase38-73 §Step 1 — approval still outstanding), then re-run `scan-docs-for-secret-patterns.sh`.

## 6. Disposition

| Item | Status | Action |
|------|--------|--------|
| Exec bits | PASS | none |
| Script secret hygiene | PASS | keep pattern-scan in CI |
| Creds in generated reports | FAIL | P0 redaction + rotation |
| Dead code | REVIEW | crontab cross-ref gate before removal |

---
*No secrets printed beyond referencing existing flagged lines by file:line.*
