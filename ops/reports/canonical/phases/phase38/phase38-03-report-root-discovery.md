# Phase 38 Report Root Discovery

**Report ID:** phase38-03-report-root-discovery  
**Phase:** 38  
**Title:** Phase 38 Report Root Discovery — Canonical and Approved Paths  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T19:56:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-03-report-root-discovery.md`
**Retention Class:** LONG
**Author:** opencode/big-pickle  

---

## 1. Purpose

Identify all locations where reports, finals, audits, evidence summaries, status files, scorecards, runbooks with results, manifests, and phase records exist. Establish canonical vs. non-canonical paths.

---

## 2. Discovered Report Roots

### 2.1 Primary Report Root: `/opt/mct-security-stack/ops/reports/`

| Metric | Value |
|---|---|
| Total files | 1,856 |
| .md files | 1,831 |
| .log files | 16 |
| .txt files | 8 |
| .json files | 1 |
| Non-empty .md | 1,823 |
| Empty .md (0 bytes) | 8 |
| Total size (.md) | 12.77 MB |
| Average .md size | 7.1 KB |
| Largest file | `ingest-pipeline-inventory-20260816-081826.md` (5.7 MB) |
| Subdirectories | 3: `root/`, `current/`, `generated/` |

**Classification:** CANONICAL — All phase reports, operator finals, audits, scorecards, and evidence summaries are written here.

#### Subdirectory: `current/`
- **Contents:** Empty
- **Purpose:** Intended for working/current-phase reports
- **Status:** UNUSED

#### Subdirectory: `generated/`
- **Contents:** Empty (pre-Phase 38)
- **Purpose:** Designated output for programmatic report generation
- **Status:** Phase 38 reports will be the first entries

### 2.2 Wazuh Ops: `/opt/wazuh-docker/multi-node/ops/`

| Component | Count | Files |
|---|---|---|
| Reports | 7 | `01-preflight-20260807-044511.md`, `02-session-20260808.md`, `03-flow-audit-20260809.md`, `cert-status.md`, `final-operator-report.md`, `final-validation.md`, `firewall-model.md` |
| Runbooks | 11 | `agent-rollout-linux-direct.md`, `agent-rollout-windows-direct.md`, `agent-rollout-cloudflared-tcp.md`, `agent-rollout-warp-private-network.md`, `cloudflare-access.md`, `enrollment-window.md`, `password-rotation.md`, `restore-checklist.md`, `rollback.md`, `security-onion.md`, `threat-hunting.md`, `unifi-syslog.md` |
| Scripts | 12 | `backup-wazuh-config.sh`, `dr-s3-bundle.sh`, `elastic-snapshot.sh`, `elastic-snapshot-s3.sh`, `health-check.sh`, `osquery.conf`, `rebuild-known-devices.sh`, `validate-decoders.sh`, `wazuh-custom-slack.sh` |
| Dashboards | 2 | `wazuh-dashboards-backup.json`, `restore-dashboards.sh` |
| Backups | 5+ | `pw-rotation-20260807-154045/`, `compose-20260807-044826/`, and 4 .bak files |
| Overview | 1 | `STACK-OVERVIEW.md` (25 KB) |
| Credentials | 1 | `creds.env` (restricted, 708 bytes) |

**Classification:** SEMI-CANONICAL — Operational artifacts. `STACK-OVERVIEW.md` and runbooks are authoritative for Wazuh ops. Reports are phase-specific.

### 2.3 Evidence Root: `/opt/mct-security-stack/ops/evidence/`

| Metric | Value |
|---|---|
| Total files | 2 |
| Directory | `p37-workflow-export/` |
| Files | `wazuh-high-severity-to-iris.json`, `wazuh-flow-classb-to-iris.json` |

**Classification:** IMMUTABLE — Evidence files must never be mutated.

---

## 3. File Classification by Artifact Type

### 3.1 Final Operator Reports (36 files)

Pattern: `final-phase{N}-operator-report-{YYYYMMDD-HHMMSS}.md`

Phases represented: 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 31v2, 32, 33, 34, 35, 37

**Missing:** final-phase1, final-phase36

### 3.2 Phase Reports (1,650 files)

Pattern: `phase{N}-{seq}-{description}.md`

Phase distribution:
- Phases 2–14: 248 files (early phases, lower volume)
- Phases 15–19: 140 files (mid phases, moderate volume)
- Phases 20–27: 330 files (growth phases)
- Phases 28–37: 932 files (maturity phases, highest volume)

### 3.3 Full-Stack Health/Audit Reports (20+ files)

Pattern: `full-stack-health-{YYYYMMDD-HHMMSS}.md`, `full-stack-audit-*.md`

Timestamps: 20260811, 20260812, 20260815 (×3), 20260816 (×3), 20260817, 20260818, 20260822 (×3), 20260824 (×3)

### 3.4 Docker Image Check Reports (8 files)

Pattern: `check-unpinned-docker-images-{YYYYMMDD-HHMMSS}.md`

Timestamps: 20260816, 20260819 (×3), 20260822 (×4), 20260824 (×2), 20260825

### 3.5 Alert Volume Reports (7 files)

Pattern: `alert-volume-by-rule-{YYYYMMDD-HHMMSS}.md`

### 3.6 Backup/DR Audit Reports (15+ files)

Pattern: `backup-dr-audit-{YYYYMMDD-HHMMSS}.md`

### 3.7 Validation/Smoke Test Reports

- `soc-smoke-test-*.md` (9 files)
- `shuffle-webhook-smoke-test-*.md` (2 files)
- `shuffle-healthcheck-*.md` (3 files)

### 3.8 Canary/Detection Validation Reports

- `canarytokens-*.md` (4 files)
- `d2-misp-ioc-validation.md`, `d3-flow-unusual-port-validation.md`, `d4-unknown-exporter-validation.md`, `d5-greenbone-critical-*.md`, `d6-active-response-audit-validation.md`, `d7-velociraptor-*.md`, `d8-security-onion-bridge-validation.md`

### 3.9 Log Files (16 files)

Non-report operational logs: `audit-cron.log`, `backup-cron.log`, `backup-log.txt`, `backup-prune-cron.log`, `healthcheck-weekly.log`, `iris-db-cron.log`, `misp-cdb-cron.log`, `p33-alert-events.log`, `p33-core-alert.log`, `shuffle-boot-repair.log`, `shuffle-export-cron.log`, `shuffle-periodic-repair.log`, `vm103-greenbone-cron.log`, `vm103-misp-cron.log`, `zeek-classa-guardrail-state.log`, `zeek-classa-guardrail.log`

### 3.10 Text/JSON Artifacts (9 files)

- `.txt`: `p28-consolidation-candidates-*.txt`, `p28-deployability-inventory-*.txt`, `p28-portability-scan-*.txt`, `p30-infrastructure-audit-*.txt`, `p30-runtime-drift-*.txt`, `phase4-ports-*.txt`, `phase5-current-port-state.txt`
- `.json`: `p35-canary-alert-raw.json`

---

## 4. Excluded Paths

| Path | Reason |
|---|---|
| `/opt/mct-security-stack/.git/` | Git internals, not report content |
| `/opt/mct-security-stack/ops/reports/current/` | Empty, no reports |
| `/opt/wazuh-docker/multi-node/ops/backups/` | Backup configs, not reports |
| `/opt/wazuh-docker/multi-node/ops/dashboards/` | Dashboard exports, not reports |
| `/opt/wazuh-docker/multi-node/ops/creds.env` | Credentials, not reports |
| `/opt/mct-security-stack/ops/reports/generated/` | Output directory for Phase 38+ reports |

---

## 5. Canonical Status

| Path | Canonical? | Reason |
|---|---|---|
| `/opt/mct-security-stack/ops/reports/` | YES | Primary report root, 1,856 files |
| `/opt/mct-security-stack/ops/evidence/` | YES | Evidence root, immutable |
| `/opt/wazuh-docker/multi-node/ops/reports/` | SEMI | Wazuh-specific operational reports |
| `/opt/wazuh-docker/multi-node/ops/runbooks/` | YES | Operational runbooks |
| `/opt/wazuh-docker/multi-node/ops/STACK-OVERVIEW.md` | YES | Authoritative stack documentation |
| `/opt/mct-security-stack/ops/reports/generated/` | YES | Phase 38+ programmatic output |

---

## 6. Total Canonical Report Count

| Source | Files |
|---|---|
| Primary report root (all files) | 1,856 |
| Wazuh ops reports | 7 |
| Wazuh ops runbooks | 11 |
| Wazuh STACK-OVERVIEW.md | 1 |
| Evidence | 2 |
| **Total** | **1,877** |

Excluding logs, .txt, .json (non-report artifacts): **1,840 report-class files**.
