# Phase 38 Phase Chronology

**Report ID:** phase38-12-phase-chronology
**Phase:** 38
**Title:** Phase 38 Chronology — Date-Anchored Phase Timeline from Git History and File Metadata
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T19:56:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/big-pickle
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-12-phase-chronology.md`
**Retention Class:** LONG
**Evidence Basis:** `git log --oneline --date=short --pretty=format:"%h %ad %s"` (115 commits, run in /opt/mct-security-stack) + report file mtimes + final-report filenames

---

## 1. Method

Only two date sources were used, per prompt constraints:

1. **Git commit dates** — actual `%ad` (author date, short) from the repository at HEAD `7bd3b82`.
2. **Filesystem metadata** — mtime of reports/backups and timestamped filenames (`*-YYYYMMDD-hhmmss.md`).

No dates were inferred from narrative content alone. Where a phase lacks a direct git anchor (pre-git era), it is dated by file evidence only and marked as such.

---

## 2. Repository Facts (measured)

| Fact | Value |
|---|---|
| Total commits | 115 |
| First commit | `f14ba1b` 2026-08-16 — "Initial commit: MCT Security Stack portable repo" |
| HEAD | `7bd3b82` 2026-08-25 — "Phase 37: 82 reports, workflow exports, Shuffle hardening plan…" |
| Tag state | `v1.3.0` tag exists; `git describe` = `v1.3.0-13-g7bd3b82` (HEAD is 13 commits past tag) |
| Working tree | clean except untracked `ops/reports/generated/` |

---

## 3. Master Chronology

### Era 0 — Pre-git operations (2026-08-07 → 2026-08-15)

No git history exists before 2026-08-16. Dating below is **file-evidence only**.

| Window | File evidence | Inferred activity |
|---|---|---|
| 08-07 | `/opt/wazuh-docker/multi-node/ops/backups/compose-20260807-044826/`; `pw-rotation-20260807-154039/`, `pw-rotation-20260807-154045/` | initial compose deployment + password rotation |
| 08-10 | `01-preflight-20260810-060311.md`; `15-vm103-provisioning-20260810-0650.md`; `15-misp-greenbone-deployment-20260810-0825.md`; `phase2-config-*.tar.gz` (6 archives); docker-compose/local_rules/wazuh_manager.conf backups (06:37–17:57) | Phase 1 preflight; vm103 provisioning; MISP+Greenbone deploy; Phase 2 config work |
| 08-11 | 167 files incl. `15-alert-routing-complete-20260810-2117.md`, `15-round3-complete-20260810-2155.md`, alert-volume-by-rule series, backup-dr-audit series | alert routing/Shuffle-IRIS wiring rounds; backup/DR audits |
| 08-12 | 30 files | follow-up audits/ops |
| 08-13/08-14 | zero files | gap (no recorded activity) |
| 08-15 | 81 files | stack maturation, pre-repo consolidation |

Caveat: top-level filenames like `15-alert-routing-complete-*` use *prompt* numbering of early phases, not phase numbers; they are listed as evidence, not as Phase 15 events. Phases 1–12 have no per-phase git anchors.

### Era 1 — Repo creation + Phases 13–18 (2026-08-16 → 2026-08-17)

All dates from measured git log:

| Date | Commit | Event |
|---|---|---|
| 2026-08-16 | `f14ba1b` | Initial commit (portable repo) |
| 2026-08-16 | `0f22899`,`eb00166` | CI workspace fix; GitHub publish + CI PASS |
| 2026-08-16 | `d4a20be`,`e3b88bf`,`ba1f9c7` | Level.io variable fix; **Phase 13 final**; client outreach/FP suppression/dashboards/canarytoken |
| 2026-08-16 | `f67e759`,`504c6fe` | Client 013 Sysmon channel deployed; P13 report update |
| 2026-08-16 | `cc4e389`,`639cfcb` | v1.0.0 release notes; **v1.0.0 GitHub release report** |
| 2026-08-16 | `fddb6bd`,`762fadf`,`f18f103`,`4ef7f56` | FP suppression fix (worker node root cause); **Phase 14 final** |
| 2026-08-16 | `ea36c7e`,`bdf721e` | **Phase 15**: full-stack audit, whitelabel layer, client ops, ES retention; final |
| 2026-08-16 | `de06b28`,`ecee1fb`,`9a77bc5`,`106d6de` | ES snapshot cleanup 43→14 (−4.3G); digest pinning (6 images); wheelhouse; **Phase 16 final** |
| 2026-08-16 | `dbe4089`,`a201b6d`,`707ea58`,`cf72256`,`deb353e` | macOS pkg fix; Level.io exec-mode fix; 3rd endpoint Julians-Air live; P16 update |
| 2026-08-16 | `7daa759`,`2668c96`,`b6d6f63`,`14d723c`,`b2422e8`,`3598ee9`,`f5444c3`,`5237db6`,`b3990ef`,`fe1bf08`,`b321215`,`6bf9a4f` | macOS queue-full fix; NetFlow deep dive; SO deep dive; syslog allowlist gap; archives 9.3GB>>alerts 2GB; UniFi allow; agent pkgs cached; white-label wiring; DR S3/canarytoken/monthly ops; **Phase 17 final** |
| 2026-08-17 | `bfdf95f`,`37096f4`,`a050f80`,`8ce663e`,`f9d1e08`,`0c9ff5e`,`3cc2f90`,`5e96d3e`,`c0e203d`,`ffa371d`,`2a5aa4c`,`46a9120`,`c20f06c`,`eba217b` | zeek-forward logrotate; zeek decoder ext; rule pack v1; Suricata eve path fixed; agent 008 runbook; syslog allowlist +client subnet (approved); netflow scope; Redis rule 120537 5→3; index noise review; macOS CRITICAL flood doc; zeek 122006 tightened; monthly ops; **Phase 18 final** |

### Era 2 — Phases 19–25 (2026-08-18 → 2026-08-22)

| Date | Commit(s) | Event |
|---|---|---|
| 2026-08-18 | 25 files (mtime only; no phase commits) | interim ops |
| 2026-08-19 | `eba217b`→`171d837` cluster: `5d23813`,`ebd9463`,`75984aa`,`fa3249c`,`1d29232`,`85cba85`,`4a9eb02`,`171d837` | P19-P21 deliverables (packet/flow/macos/syslog docs, zeek rules v2.2, retention runbook, billing readiness); credential cleanup w/ fail-fast guards; CI false-pass fix; windows014 sysmon tuning; repo hygiene; **v1.1.0 published** |
| 2026-08-22 | `fd1cb3e` | **P22**: endpoint remediation prep, credential env-abstraction, image pinning+policy, retention ISM fix, source-of-truth cleanup |
| 2026-08-22 | `52c3e91`,`62d7457`,`637fca0`,`21ef572`,`54e32fd`,`6f146de`,`1c575e6`,`f773d36`,`63c5ed7` | **P24 close**: fleet restored (013 reconnected), evidence archive 22/22; sysmon automation; **v1.2.0 released+published**; RMM-safe tuning scripts |
| 2026-08-22 | `baf8b95` | **P23 close**: endpoint remediation (015 reconnect validated), disk relief 85→83%, swap root-cause, doc governance |
| 2026-08-22 | `0ac55d8`,`431d0d5`,`2a0e3d6`,`143e81d` | P23: deep-dive audit, action-item verification ledger, opencanary digest pin |
| 2026-08-22 | `96970c4`,`f1fa2fd`,`508b793` | **P25**: Zeek Class A routing ENABLED (operator-approved; Wazuh 122001-122003 → Shuffle webhook → IRIS; synthetic tests FINISHED); DR S3 restore drill PASSED; retention aligned archives=14d; v1.2.0 verified |

### Era 3 — Phases 26–30 (2026-08-23 → 2026-08-24)

| Date | Commit | Event |
|---|---|---|
| 2026-08-23 | `cb8ca76` | **P26**: snapshot restore drill PASSED; Zeek hard guardrails (rate-limit + kill switch tested); retention deletes observed (**disk 79.5%**); 015 closed out |
| 2026-08-24 | `9f09dda` | **P27**: multi-index restore drill PASSED; Shuffle backup + guardrail failover tested; endpoint cert PARTIAL; retention plateau (**81%**) |
| 2026-08-24 | `21ba3d1` | **P28**: consolidation audit stack; guardrail exec-bit incident closed (cron down ~40h); **DR architecture + full-cluster NO-GO**; fresh-target dry-run PASS; pycache cleanup |
| 2026-08-24 | `bbe14c8`,`c726182`,`8e37ae9` | **P29**: image pin set (8 refs→digests) prepared then **APPLIED**; v1.3.0 bundle sha256 da72bde4; guardrail failover re-proven; SO VM down + swap pressure recorded; **indexer rotation attempted + rolled back cleanly**; **v1.3.0 released** (tag, release 375979989, asset da72bde4); deployability PARTIAL (target NO-GO) |
| 2026-08-24 | `0c24353` | **P30**: memory stabilization (**swappiness 60→10 applied**); SO postmortem (PVE creds blocked); full 24-category audit; finals list begins (`final-phase30-operator-report-20260824-220404.md`) |

### Era 4 — Phases 31–37 (2026-08-24 → 2026-08-25)

| Date | Commit / Final-file | Event |
|---|---|---|
| 2026-08-24 | `43c4bf1` | **P31**: **SO packet scanning RETIRED** (healthcheck 0 FAIL, forward disabled); Suricata-minimal benchmarked+selected (31MB/0 drops < 2GiB ceiling); CI SHA-pinned gates |
| 2026-08-24 | `98d5baf` | P31 SPAN: production benchmark PASSED on real mirrored traffic (Suricata 32MB, 0.79% CPU, 0 drops over 16.5K pkts, 0 FPs) |
| 2026-08-24 | `91f6789` | **P31v2**: SPAN-live pipeline proven (32MB/0 drops + agent 016 EVE ingest); /tmp 100% incident fixed via docker exec; detection gate open → Phase 32; `final-phase31-operator-report-20260824-230411.md`, `…31v2…235617.md` |
| 2026-08-25 | `49dfdda` | **P32**: detection value gate CLOSED (ET sid 2027967 fired offline; Wazuh suricata decode proven via logtest); observe-only live; /tmp safe hardening (6%); `final-phase32-operator-report-20260825-002710.md` |
| 2026-08-25 | `79f6cbe` | **P33**: live alert wiring operational (sensor timer + core cron, 7 checks HEALTHY); observe-only (sid 2027967 evidence); canary routing gated; /tmp scheduled control (6%); `final-phase33-operator-report-20260825-011817.md` |
| 2026-08-25 | `3d4d072` | **P34**: observe window finalized (**17h / 8.3M pkts / 0 drops / 0 alerts / 529 rules / 74MB**); zero-alert integrity proven; **canary SID 2027967 approved+designed** (E2E deferred — agent 016 forwarding gap); retention wave staged (08-15 present ⇒ ~08-29 deletion); `final-phase34-operator-report-20260825-174138.md` |
| 2026-08-25 | `dca1691` | P34 update: **agent 016 eve.json forwarding applied**; canary E2E PARTIAL (detection proven locally; live pipeline blocked by read-only SPAN) |
| 2026-08-25 | `cbcca53` | **P35**: canary E2E proven (synthetic + real SPAN alert through OpenSearch); **Shuffle routing deferred (UI-gated)**; retention wave staged ~08-29; deployability PARTIAL; `final-phase35-operator-report-20260825-1841Z.md` |
| 2026-08-25 | `b529e3b` | **P36**: ISM policy attachment to all 11 archive indices (first deletion expected **2026-08-29**, relief ~7.9GB); Shuffle investigation (auth resolved, frontend exposed 0.0.0.0:3001); field cardinality fix design+apply (decoder_order_size=512); endpoint recovery; **/tmp cleanup cron added**; 76 files |
| 2026-08-25 | `b7c2f18` | P36 update: Shuffle auth resolved; frontend exposed; decoder fix applied; fleet state current |
| 2026-08-25 | `7bd3b82` | **P37**: 82 reports; **workflow exports created** (ops/evidence/p37-workflow-export/); Shuffle hardening plan; field-resolution design; `final-phase37-operator-report-20260825-1943Z.md` (Phase Status IN PROGRESS) |

### Era 5 — Phase 38 (2026-08-25, current)

| Item | Value |
|---|---|
| Reports generated | 55 in ops/reports/generated/ (phase38-00 … phase38-96) |
| Git anchor | none yet for phase38 outputs (generated/ untracked) |
| Live anchors | HEAD 7bd3b82; disk LOW WATERMARK 84%; decoder errors ~100/min; first archive deletion pending 2026-08-29 |

---

## 4. Release Timeline (from git, exact)

| Release | Date | Anchor commit | Evidence |
|---|---|---|---|
| v1.0.0 | 2026-08-16 | `639cfcb` | P14.02 release report |
| v1.1.0 | 2026-08-19 | `171d837` | release object + asset uploaded |
| v1.2.0 | 2026-08-22 | `637fca0` | release executed + published |
| v1.3.0 | 2026-08-24 | `8e37ae9` | tag, release id 375979989, asset sha256 da72bde4… |

Cadence: releases every ~3 days (08-16, 08-19, 08-22, 08-24). No release since 08-24 despite 13 commits on the branch (describe = v1.3.0-13-g7bd3b82).

---

## 5. Cross-Source Consistency Checks

| Check | Result |
|---|---|
| Final-report filename timestamps vs git dates | CONSISTENT for P30–P35 (same-day, ordered hours) |
| P36/P37 | P36 has no single "final" file; covered by `phase36-75-final-report.md` + 2 commits same day — CONSISTENT |
| File-mtime histogram vs git dates | 08-24 spike (467) matches P27-P31 burst; 08-25 spike (520) matches P32-P38 — CONSISTENT |
| Pre-git file names vs phase numbering | AMBIGUOUS (prompt-numbered names); flagged, not resolved |
| 08-13/08-14 absence | consistent across both sources — real operational gap |

---

## 6. Findings

1. The authoritative machine-readable chronology is now this table pair (§3 eras 1–5); every row is backed by a specific commit hash or timestamped filename.
2. Phases 1–12 cannot be individually dated from available evidence — only bounded (2026-08-07 → 2026-08-15).
3. Phase 37 closed with "IN PROGRESS" status in its final report while its commit message reads as complete; treat P37 as partially closed (routing + hardening outstanding).
4. Retention wave (~08-29) is the only future-dated event in the corpus and should anchor the next observation checkpoint.
5. Untracked `generated/` means phase38 chronology is not yet preserved by git — commit or ignore decision required (ACT-38-010).

---

## 7. Per-Day Activity Intensity (measured mtime histogram × git commits)

| Date | Corpus files touched | Commits that day | Phase activity | Intensity read |
|---|---|---|---|---|
| 08-07 | (pre-repo backups only) | 0 | deploy/rotation | bootstrap |
| 08-10 | 13 | 0 | P1-P2 era | low-file/high-mutation |
| 08-11 | 167 | 0 | routing/wiring rounds | heavy audit day |
| 08-12 | 30 | 0 | follow-ups | moderate |
| 08-13/14 | 0 | 0 | — | idle gap |
| 08-15 | 81 | 0 | consolidation prep | heavy |
| 08-16 | 225 | ~45 | P13-P17 closed; v1.0.0 | **peak burst #1** |
| 08-17 | 29 | 14 | P18 close | steady |
| 08-18 | 25 | 0 | interim ops | quiet |
| 08-19 | 73 | 9 | P19-P21; v1.1.0 | steady |
| 08-22 | 208 | 17 | P22-P25; v1.2.0 | **peak burst #2** |
| 08-23 | 50 | 1 | P26 | steady |
| 08-24 | 467 | 8 | P27-P31v2; v1.3.0 | **peak burst #3** |
| 08-25 | 520 | 7 (+38 generated) | P32-P37, P38 start | **peak burst #4** |

Cadence law observed: work compresses into multi-phase release bursts every ~3 days (08-16, 08-22, 08-24-25), each terminating in either a version tag or a phase-final report cluster.

## 8. Anchor Index (machine-usable)

Phase → strongest single anchor:

```text
P01-P02 : file: 01-preflight-20260810-060311.md ; artifact: phase2-config-20260810-*.tar.gz
P03-P12 : file-evidence window 2026-08-10..15 (no per-phase anchors)
P13     : git e3b88bf (final) / f67e759 / ba1f9c7            2026-08-16
P14     : git 4ef7f56 (final) / fddb6bd / 762fadf            2026-08-16
P15     : git bdf721e (final) / ea36c7e                      2026-08-16
P16     : git 106d6de (final) / cf72256 / dbe4089            2026-08-16
P17     : git 6bf9a4f (final) / 7daa759 / 3598ee9            2026-08-16
P18     : git eba217b (final) / 3ededdb / c20f06c            2026-08-17
P19-P21 : git 75984aa / fa3249c / 171d837 (v1.1.0)           2026-08-19
P22     : git fd1cb3e                                        2026-08-22
P23     : git baf8b95 / 0ac55d8 / 431d0d5                    2026-08-22
P24     : git 62d7457 / 637fca0 (v1.2.0)                     2026-08-22
P25     : git 508b793 / 96970c4                              2026-08-22
P26     : git cb8ca76                                        2026-08-23
P27     : git 9f09dda                                        2026-08-24
P28     : git 21ba3d1                                        2026-08-24
P29     : git bbe14c8 / c726182 / 8e37ae9 (v1.3.0)           2026-08-24
P30     : git 0c24353 ; final-phase30-operator-report-20260824-220404
P31/v2  : git 43c4bf1 / 98d5baf / 91f6789 ; finals …230411 / …235617
P32     : git 49dfdda ; final-phase32-operator-report-20260825-002710
P33     : git 79f6cbe ; final-phase33-operator-report-20260825-011817
P34     : git 3d4d072 / dca1691 ; final-phase34-operator-report-20260825-174138
P35     : git cbcca53 ; final-phase35-operator-report-20260825-1841Z
P36     : git b529e3b / b7c2f18 ; phase36-75-final-report.md
P37     : git 7bd3b82 ; final-phase37-operator-report-20260825-1943Z
P38     : generated/ tree (55 files, untracked); live-state snapshot 19:56Z
```

---
