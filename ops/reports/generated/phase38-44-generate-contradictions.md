# Phase 38 Contradictions Register (Canonical)

**Report ID:** phase38-44-generate-contradictions
**Phase:** 38
**Title:** Contradictions Register — One Record Per Conflict, Adjudicated Against 2026-08-25 Live State
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-44-generate-contradictions.md`
**Retention Class:** LONG
**Supersedes:** prior draft of this report ID and `phase38-31-contradiction-scan.md` candidate set (both retained as history)
**Owners:** ["opencode/ox-alpha", "ops-reports-owner"]

---

## 1. Method

One record per contradiction. Each record carries: Claim A and Claim B with `file:line` sources, the verified live truth (2026-08-25), severity, resolution status, owner, and corrective action. Resolution statuses used:

- **RESOLVED-CORRECTED** — canonical truth established and propagated to phase38-49/-50.
- **OPEN** — truth known but system state not yet changed; tracked in phase38-47.

Live-verification anchors: phase38-21 through phase38-30.

---

## 2. Records

### CON-38-01 — Field-error signature and mechanism misattributed

| Field | Content |
|---|---|
| Claim A | Problem is Suricata stats field count (522) vs `decoder_order_size`; fix = raise decoder_order_size to 512; will "eliminate 15,189 'Too many fields' errors"; status "APPLIED AND ACTIVE". Sources: `phase36-75-final-report.md:24-30`; `phase36-31-field-cardinality-fix-design.md`; `phase36-32-field-cardinality-fix-applied.md` |
| Claim B | Errors continue post-change at high rate; "NOT resolved". Sources: `phase37-38-field-postlogs.md:11-19`; `phase37-81-final.md:44-52` |
| Live truth | Signature is **"Limit of total fields [1000] has been exceeded"** — an **indexer-side mapping limit** on `wazuh-archives-*` written by Filebeat. 8,746 lifetime occurrences; **~150/min currently**. `decoder_order_size=512` is staged exactly as claimed but is **IRRELEVANT** to this error class. Fix requires an index-template `index.mapping.total_fields.limit` increase and/or source reduction. Evidence: `phase38-25-field-claim-verification.md` (container grep: "Too many fields"=0 lines, "Limit of total fields"=8746) |
| Severity | HIGH |
| Status | RESOLVED-CORRECTED (narrative). OPEN (system): errors still flowing |
| Owner | Wazuh/indexer config owner |
| Corrective action | ACT-38-002: apply index template field-limit increase or reduce archive source fields; retract all decoder-based resolution claims |

### CON-38-02 — "ELIMINATED" vs live ongoing errors (false-negative verification)

| Field | Content |
|---|---|
| Claim A | "'Too many fields' errors: ELIMINATED"; "Zero 'Too many fields' errors sustained for 30+ minutes post-change". Sources: `phase36-34-field-cardinality-post-fix-validation.md:12`; `phase37-43-field-resolution.md:21` |
| Claim B | Errors active and accumulating (~100/min then, ~150/min now). Sources: `phase37-38-field-postlogs.md`; live verification 2026-08-25 |
| Live truth | Both can be literally true and still wrong: grepping container logs for `"Too many fields"` returns **0 lines because the actual signature differs** ("Limit of total fields"). The ELIMINATED verdict was an artifact of searching the wrong string. |
| Severity | HIGH |
| Status | RESOLVED-CORRECTED |
| Owner | opencode/ox-alpha (verification discipline) |
| Corrective action | Verification greps must anchor on live signatures captured at runtime, not inherited strings; codified in phase38-71 CI gate design |

### CON-38-03 — Shuffle frontend binding: loopback vs 0.0.0.0 exposed

| Field | Content |
|---|---|
| Claim A | "Shuffle frontend: UP on 127.0.0.1:3001" (protected). Source: `phase36-17-shuffle-wazuh-integration-blocker.md` §Current state |
| Claim B | "EXPOSED on 0.0.0.0:3001 … externally reachable"; "(was 127.0.0.1:3001)". Sources: `phase36-75-final-report.md:21`; `phase37-04-shuffle-listener.md:11,22,52` |
| Live truth | `ss -tlnp`: LISTEN `0.0.0.0:3001`, no TLS, no firewall rules on 3001 (`phase37-07-shuffle-exposure-apply.md`: "Firewall rules on 3001: None"). Backend correctly `127.0.0.1:5001`. No change record exists for any binding change; best-evidence reading: frontend was bound all-interfaces since deployment and Claim A asserted an assumed value |
| Severity | HIGH |
| Status | OPEN (exposure persists; hardening deferred) |
| Owner | SOAR ops owner |
| Corrective action | ACT-38-001: bind loopback or front with TLS-authenticating reverse proxy + firewall allowlist |

### CON-38-04 — Workflow-count phrasing: "no workflows" vs "2 workflows"

| Field | Content |
|---|---|
| Claim A | "Workflow backup: N/A — No workflows to back up". Source: `final-phase35-operator-report-20260825-1841Z.md:54` |
| Claim B | "2 workflows already exist (wazuh-high-severity-to-iris, wazuh-flow-classb-to-iris)". Sources: `phase36-75-final-report.md:19`; exports on disk `ops/backups/shuffle-workflows/shuffle-workflows-20260823-054501.json` (+4 older) |
| Live truth | Exactly 2 workflows exist; backups exist since 2026-08-11. Claim A false at authoring time |
| Severity | MEDIUM |
| Status | RESOLVED-CORRECTED |
| Owner | ops-reports-owner |
| Corrective action | Canonical phrasing locked in phase38-49 §6: 2 workflows (1 with real activity, 1 draft); backup JSONs present |

### CON-38-05 — Execution characterization: "all healthchecks / zero real routing" vs 68 real-payload executions

| Field | Content |
|---|---|
| Claim A | "Executions: 796 total, all healthchecks"; "Real routing: None"; "796 executions, 0 real routing". Sources: `generated/phase38-00-master.md:62,128`; `phase37-13-execution-inventory.md` |
| Claim B | Workflow `wazuh-high-severity-to-iris` shows **68 FINISHED executions with real payloads** — OpenCanary L12 hits, most recent **today (2026-08-25)**. Source: live Shuffle API enumeration, phase38-23-shuffle-claim-verification |
| Live truth | ~796 total executions; ≥68 are genuine alert-driven runs of the high-severity workflow; `wazuh-flow-classb-to-iris` remains draft. "No production routing" remains true in the formal sense (routing never enabled via approved pipeline), but "zero real security value delivered" is FALSE |
| Severity | HIGH (misstated security value in both directions) |
| Status | RESOLVED-CORRECTED (narrative). OPEN (formalize integration, BCK-38-102) |
| Owner | SOAR ops owner |
| Corrective action | Rewrite summaries to: "~796 executions incl. 68 real FINISHED runs of wazuh-high-severity-to-iris (OpenCanary L12); production routing still formally deferred" |

### CON-38-06 — Retention relief forecast ~7.9GB vs computable ~3.76GB (and impossible ceiling)

| Field | Content |
|---|---|
| Claim A | "Expected relief: ~7.9GB"; "Post-wave disk estimate: 76% (below low watermark)". Sources: `phase36-75-final-report.md:15-16`; repeated in later summaries as quasi-realized |
| Claim B | Realized relief = 0 bytes; indices deleted = 0. Sources: `phase37-46-retention-relief.md:7-15`; `generated/phase38-79-retention-verification.md` |
| Live truth | Zero deletions under current ISM policies; first expiry ≈ **2026-08-29**. Recomputation from current per-index sizes yields ≈**3.76GB** realistic near-first-wave relief. Additionally, the entire 11-index archive set totals only **~7.5GB** (932mb/650mb/1.2gb/1gb/1.9gb/622mb/627mb/357mb/49mb/70mb/285mb) — the ~7.9GB forecast exceeds the maximum physically deletable volume and was never achievable |
| Severity | MEDIUM-HIGH (capacity planning based on impossible number) |
| Status | RESOLVED-CORRECTED (forecast language). OPEN (wave observation pending 08-29, BCK-38-105) |
| Owner | Infrastructure owner |
| Corrective action | All summaries must say: "≈3.76GB computable first-wave relief; ~7.5GB absolute archive ceiling; realized 0 to date" |

### CON-38-07 — Report corpus count variance: 1831 vs 1833 vs 1877

| Field | Content |
|---|---|
| Claim A | 1,831 .md files. Source: `phase38-04-report-inventory.md` |
| Claim B | 1,833 .md files (scan-time recount); 1,877 files across 3 roots. Sources: `phase38-31-contradiction-scan.md` header; `phase38-03-report-root-discovery.md` |
| Live truth | Counts differ by scope (.md-only vs all-files; early vs late census). Current canonical: **1,888 .md** (1,833 original + 55 phase38-generated at census cutoff; 1,900 after this batch). No data loss detected |
| Severity | LOW-MEDIUM (undermined reader trust; unreconciled in summaries) |
| Status | RESOLVED-CORRECTED |
| Owner | ops-reports-owner |
| Corrective action | Count statements must carry class+scope; canonical counter script proposed in REM-38-10 |

### CON-38-08 — Agent fleet snapshots drifting between reports

| Field | Content |
|---|---|
| Claim A | "Active agents: 7" with varying retired lists. Sources: `generated/phase38-00-master.md:116-117`; multiple phase36 endpoint reports |
| Claim B | Fleet enumerations elsewhere include 015 as connected/disconnected/closed-out inconsistently (e.g., `phase33-34`/`phase35-35` era vs P36 recovery reports) |
| Live truth | **8 ACTIVE**: 000, 006, 007, 011, 012, 014, 015 (Julians-Air, reconnected 2026-08-25), 016 (v4.14.7; 433 Suricata alerts indexed from `/var/log/suricata/eve*.json`). **013 SAMSUNG disconnected** (not retired). **008 retired** |
| Severity | MEDIUM |
| Status | RESOLVED-CORRECTED (canonical list in phase38-49 §7). OPEN (013 recovery, BCK-38-104) |
| Owner | Endpoint ops owner |
| Corrective action | Endpoint statements must cite agent-control API snapshot timestamp |

### CON-38-09 — Release provenance "fully verified" vs artifact availability

| Field | Content |
|---|---|
| Claim A | Release provenance complete: v1.3.0 tag 790968b8, release id 375979989, asset sha256 da72bde4 byte-exact. Sources: git commit 8e37ae9 (P29 approvals); `phase38-21-release-claim-verification.md` |
| Claim B | The release asset binary is not persisted on-box; nothing under `ops/evidence/` archives it; re-download requires network/GitHub access (and `gh` CLI is absent). Source: `phase38-34-missing-artifact-scan.md`; this session's filesystem sweep |
| Live truth | Hash verification succeeded in-session (asset fetched and matched `da72bde4…`), so integrity is VERIFIED while on-box availability is UNVERIFIED/PARTIAL. Summaries asserting end-to-end provenance overstate the evidence |
| Severity | MEDIUM |
| Status | OPEN |
| Owner | Release owner |
| Corrective action | Archive the v1.3.0 asset under `ops/evidence/releases/v1.3.0/` with recorded sha256 (REM-38-07) |

### CON-38-10 — "Retention deletes observed" (old mechanism) vs ZERO deletions under current ISM policies

| Field | Content |
|---|---|
| Claim A | "Retention deletes observed (disk 79.5%)"; "retention rolling (plateau 81%)". Sources: git commits cb8ca76 (P26), 9f09dda (P27); contemporaneous reports |
| Claim B | Current ISM policies (`wazuh-archives-14d` on archives, `wazuh-retention` on alerts) have executed **zero deletions**; explain endpoint returned empty during verification. Sources: `generated/phase38-79-retention-verification.md`; `generated/phase38-26-retention-claim-verification.md:101` |
| Live truth | Both describe different mechanisms/generations: pre-P36 cleanup scripts did delete; the **current** attached ISM policies have not yet reached any expiry (first ≈2026-08-29). Conflation makes retention look further along than it is |
| Severity | MEDIUM |
| Status | OPEN (observe wave 08-29) |
| Owner | Infrastructure owner |
| Corrective action | BCK-38-105: capture first-wave evidence on 2026-08-29; until then canonical phrasing "armed, zero deletions, first expiry ≈08-29" |

---

## 3. Summary Statistics

| Status | Count |
|---|---|
| RESOLVED-CORRECTED | 6 (CON-01, 02, 04, 05-narrative, 07, 08-list) |
| OPEN (system change pending) | 5 instances across CON-01(system), 03, 05(integration), 06(wave), 09, 10 |
| HIGH severity | 4 (CON-01, 02, 03, 05) |

All resolutions feed the canonical current-state doc (phase38-49) and claim ledger (phase38-50). System-side opens are consolidated in the open-work register (phase38-47) and remediation plan (phase38-54).

## 4. Ownership and Review

- Register owner: ops-reports-owner. Adjudication evidence: phase38-21..30.
- Re-adjudication triggers: any new claim contradicting phase38-49; ISM wave result 2026-08-29; Shuffle hardening completion.
