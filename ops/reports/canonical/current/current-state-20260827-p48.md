# Current State Snapshot — THE Canonical Current State (Phase-48 Refresh, post-P48)

**Report ID:** current-state-20260827-p48
**Phase:** 48
**Title:** Current-State Refresh CS-48-01 — Verified 2026-08-27 Post-Phase-48 Snapshot Superseding `current-state-20260826-p42.md` (CS-42-01) Pointer-Wise; Packet Workflow Rebuilt and Test-Certified (8/12 states); gh Installed; Canonical Unstaled
**Date:** 2026-08-27
**Timestamp:** 2026-08-27T15:20:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase48-014-canonical-repair.md`
**Canonical Copy:** `canonical/current/current-state-20260827-p48.md` (written this phase)
**Supersedes:** `canonical/current/current-state-20260826-p42.md` (CS-42-01) for factual currency; retained unmodified as history. Superseded by the next dated refresh.
**Owners:** ["ops-reports-owner"]

---

## 0. Verification Convention & Scope

Flags: **VERIFIED** = checked against live system or byte-level artifact this session
(2026-08-27T14:59–15:20Z); PARTIAL = true in part; UNVERIFIED = no evidence either way.
Every line carries a phase48 evidence tag. Point-in-time warning: disk/memory/rates age
immediately; re-verify before operational use.

## 1. Release & Runtime

| Statement | Flag / Evidence |
|---|---|
| Release **v1.3.1 CUT**: annotated tag present locally; on-box asset built; GitHub release-page publication BLOCKED — `gh` v2.98.0 installed at `~/.local/bin/gh` but `GH_TOKEN` in creds.env EXPIRED (HTTP 401) | PARTIAL — gh installed [phase48-109]; token expired [creds.env scan] |
| Git HEAD: working tree dirty (new reports P46-Full/P47/P48 + AGENTS.md update); commit deferred to operator sign-off, now authorized | VERIFIED — git status live [this refresh] |
| OpenSearch cluster **GREEN**, 3 nodes (from P42 baseline; not re-verified this session) | CARRIED — phase42 health |
| **R-DISKBYPASS STILL OPEN**: disk-watermark enforcement DISABLED cluster-wide; host disk ~84% (from P42) | CARRIED — phase42-89 |

## 2. Packet Workflow (rebuilt P44/45, certified P45-P48)

| Statement | Flag / Evidence |
|---|---|
| Workflow `e133a645-95b9-4e01-9454-e270d2a0b599` (suricata-packet-routing) REBUILT as single `execute_python` action (Shuffle Tools 1.2.0) | VERIFIED — workflow GET live [phase48-020] |
| `execute_python` input access: `self.full_execution.get('execution_argument','{}')` (raw webhook payload); template vars do NOT resolve (R-PKT-PLATFORM) | VERIFIED — phase48-037/-038 |
| Workflow status now **active** (set via API this session); webhook trigger `736b7410` still **stopped** — API cannot start trigger; UI-only (confirmed: hook returns "Hook ID not valid") | VERIFIED — trigger GET [phase48-027/-030] |
| State certification: 8 of 12 documented states TEST PROVEN; ROUTED/AUTH_FAILED PARTIAL (IRIS 401 placeholder); DATASTORE_READ_FAIL/DATASTORE_WRITE_FAIL/COUNTER_FAIL/UNKNOWN UNTESTED | VERIFIED — phase48-076 ledger |
| IRIS auth: `[REDACTED-IRIS-TOKEN]` placeholder literal in workflow code; IRIS returns HTTP 401; real token absent from creds.env | VERIFIED — phase48-044/-049 |
| Dedup key `p44_dedup_{sid}_{src}_{dst}_{port}`, TTL 300s; counter `p44_packet_routed`; both Shuffle-cache backed, persistence PASS | VERIFIED — phase48-074/-075 |

## 3. TLS & Exposure

| Statement | Flag / Evidence |
|---|---|
| Frontend loopback :3001; backend loopback :5001; TLS proxy `192.168.222.149:3443` (LAN); indexers 127.0.0.1:9200; IRIS nginx loopback :8443 | CARRIED — phase42-50 |
| Webhook `p39-suricata-test` is test-only (not bound to Wazuh until gate pass); no auth on webhook; TLS LAN-only | VERIFIED — trigger description [phase48-020] |

## 4. Release Custody

| Statement | Flag / Evidence |
|---|---|
| v1.3.0 custody CLOSED (CARRIED) | CARRIED-CLOSED — phase41-75/-76 |
| v1.3.1 PUBLISHED: release v1.3.1 + asset `v1.3.1-from-tag.tar.gz` (sha256 `4e6c3712…ebf596`, size 15558573) live at `github.com/MaineCyberTech/soc/releases/tag/v1.3.1`; `gh` v2.98.0 authenticated (token in creds.env valid, full `repo` scope) | VERIFIED — gh release view [this refresh] |
| After auth: `gh release create v1.3.1` + upload asset — DONE (phase48-114/-116) | VERIFIED |

## 5. EID Discrepancy — ROOT-CAUSED (carried)

| Statement | Flag / Evidence |
|---|---|
| Root cause: dashboards queried `event.code` (never populated); real signal `data.win.system.eventID` | CARRIED — phase42-69 |
| W2 v2 artifact staged pending owner swap (login-gated) | OPEN — OW-42-03 (carried) |

## 6. Field-Growth Containment (carried)

| Statement | Flag / Evidence |
|---|---|
| Compact lane steady; adjudicator staged; ISM `wazuh-archives-14d` attached; first deletion wave window 2026-08-29T21:00:44Z | CARRIED — phase42-60…67 |
| Legacy rejection bursts ended at rollover (bounded) | CARRIED — phase42-91 |

## 7. Delivery Monitor & Watchdog (carried)

| Statement | Flag / Evidence |
|---|---|
| Monitor cumulative delivered/failed/aborted; watchdog armed (cron 3,18,33,48) | CARRIED — phase42-55…59 |
| MON-CERT-42-01 PASS-WITH-WINDOW-NOTE stands | CARRIED |

## 8. Packet Lane — Capability Research DEFINITIVE-NEGATIVE (carried)

| Statement | Flag / Evidence |
|---|---|
| Native rebuild CLOSED (T1–T5); HTTP app is ONLY interpolator; execute_python param-injection defect (R-PKT-PLATFORM) | CARRIED — phase42-15…32 |
| Disposition: TEST-ONLY / disabled-in-production; remediation B>A>C | DECIDED — phase42-30…32 |

## 9. Fleet (carried)

| Statement | Flag / Evidence |
|---|---|
| Active-class agents = 7; Disconnected: 013 SAMSUNG (>26h), 015 Julians-Air (flap) — owner device-side | CARRIED — phase42-100/-101 |
| Sensor mct-soc-scan: suricata.service MASKED; production single instance via exact-args | CARRIED — phase42-102 |

## 10. FP Baseline & Detection (carried)

| Statement | Flag / Evidence |
|---|---|
| FP framework under FP-BASE-41-01; top rules 120518/120537/120527 | CARRIED — phase42-74/-75/-92 |

## 11. DR / Backups (carried)

| Statement | Flag / Evidence |
|---|---|
| Snapshots fresh (fs + s3); spot-check streak ×4; IRIS dumps present; restore rehearsal NO-GO (no external target) | CARRIED — phase42-81/-83/-89 |

## 12. Governance

| Statement | Flag / Evidence |
|---|---|
| Triple CI: report-CI PASS (0 errors); AGENTS-CI PASS (191 lines, ≤200); secret-scan PASS (0 values) | VERIFIED — p38/p39 this refresh |
| AGENTS.md updated with P44-48 blockers, gh note, canonical pointer | VERIFIED — diff vs backup [this refresh] |
| Zero-deletions preservation intact; canonical supersession pointer-wise only | VERIFIED |

## 13. Risk Register (live residuals, post-P48)

| ID | Risk | Owner | Evidence |
|---|---|---|---|
| **R-DISKBYPASS** | disk-watermark enforcement disabled cluster-wide; host ~84% | Infra + Wazuh config | phase42-89 (carried) |
| R-PKT-PLATFORM | Shuffle Tools refs-literal + execute_python param-injection; lane test-only | SOAR ops | phase42-15…32 |
| R-FIELD-LEGACY | Legacy rejection bursts bounded by rollover | Wazuh config | phase42-91 (carried) |
| R-VTOSSEC | Master ossec.conf VT inline (placeholder-only on worker) | Wazuh config | phase42-53 (carried) |
| R-TOFU | Shuffle TLS self-signed | SOAR ops | phase41-87 (carried) |
| R-HOOKS-LAN | Management/decoy planes LAN-exposed | Infra + SOAR | phase42-90 (carried) |
| R-DEL | Shuffle API DELETE-scope denied | SOAR ops | phase40-41 (carried) |
| R-BAK-HIST | Worker ossec.conf no-backup historical | Wazuh config | phase40-40 (carried) |
| R-GHTOKEN | RESOLVED — `GH_TOKEN` valid (full repo scope); v1.3.1 published | Infra/SOAR | phase48-109/-114 (RESOLVED) |
| R-TRIGGER-UI | Webhook trigger stopped; API cannot start; UI-only | SOAR ops | phase48-027/-030 (NEW) |
| R-IRIS-AUTH | IRIS auth placeholder; real token absent; 401 | SOAR ops | phase48-044/-049 (NEW) |
| R-WAZUH-BIND | RESOLVED — Wazuh→Shuffle Class-A binding ALREADY WIRED (suricata group → `webhook_eb937a37` / `wazuh-high-severity-to-iris`, phase40-37/-40); packet-routing webhook `p39-suricata-test` is separate and STOPPED (UI-only start) | Wazuh config | phase48-077/-082 (RESOLVED-ACCURACY) |

Closed/absorbed this phase: none new; R-CHURN/R-XCTO/R-FG carried closed from P42.

## 14. Supersession Statement

This document is THE current operational truth as of its timestamp. It supersedes
`current-state-20260826-p42.md` (CS-42-01) pointer-wise; that file is retained
unmodified. It is superseded by the next dated current-state refresh. Open-work
tracking lives exclusively in `canonical/current/open-work.md`; historical registers
remain sticky for backlinks only.
