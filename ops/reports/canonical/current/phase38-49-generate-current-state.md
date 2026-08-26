# Phase 38 Canonical Current-State Document

**Report ID:** phase38-49-generate-current-state
**Phase:** 38
**Title:** THE Canonical Current State — Verified 2026-08-25, Single Source of Truth
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-49-generate-current-state.md`
**Retention Class:** LONG
**Supersedes:** all prior current-state summaries, including `generated/phase38-00-master.md` §3 and every per-phase "status-live" report, for factual content. Prior summaries retained as history only.
**Owners:** ["ops-reports-owner"]

---

## 0. Verification Convention

Every statement carries a flag and evidence reference:

| Flag | Meaning |
|---|---|
| **VERIFIED** | Checked against live system or byte-level artifact on 2026-08-25 (~20:00–20:50Z) |
| PARTIAL | True in part; stated remainder is open |
| UNVERIFIED | No evidence either way |

Point-in-time warning: disk/memory/rates age immediately; re-verify before operational use (cadence per phase38-71).

---

## 1. Release & Provenance

| Statement | Flag | Evidence |
|---|---|---|
| Current release **v1.3.0**, tag `790968b8`; Git HEAD `7bd3b82` ("Phase 37: 82 reports…"), clean tree | VERIFIED | git log/tag at audit time; phase38-21 |
| Release asset sha256 begins `da72bde4…`; matched **byte-exact** during in-session fetch | VERIFIED | in-session hash match; git 8e37ae9 (release id 375979989) |
| Asset binary NOT archived on-box under evidence/; `gh` CLI absent | VERIFIED | filesystem sweep; MIS-38-04 |
| Image digest pinning applied to 8 previously-mutable refs (P29) | VERIFIED | git c726182; compose inspection P29 era |

## 2. Host Health

| Metric | Value | Flag / Evidence |
|---|---|---|
| Disk | **84% used (118G/148G, 24G avail)** — above internal low-watermark comfort | VERIFIED — phase38-22 |
| Memory | **75% (11,750/15,553 MB)** | VERIFIED — phase38-22 |
| Swap | **64% used** | VERIFIED — phase38-22 |
| PSI cpu | avg10 ≈2.6, avg60 ≈2.8 (no saturation) | VERIFIED — phase38-22 |
| swappiness | 60→10 applied (P30) | VERIFIED — git 0c24353 |

## 3. OpenSearch Cluster

| Statement | Flag / Evidence |
|---|---|
| Status **GREEN**, 3 nodes, **274 shards (145 primary)** | VERIFIED — `_cluster/health`; phase38-22 |
| Auth `admin:<password>` via `https://127.0.0.1:9200 -k` functional | VERIFIED — live queries this session (credential value intentionally not restated here; see redaction note §12) |
| One transient `Unauthorized` observed this session despite unchanged creds → tracked risk **R-18** | VERIFIED — session log; phase38-30 |
| Indices: **22 × wazuh-alerts-4.x** spanning 08-07→08-25 | VERIFIED — `_cat/indices` |
| Indices: **11 × wazuh-archives-4.x** spanning 08-15→08-25, total **~7.5GB** (sizes: 932mb, 650mb, 1.2gb, 1gb, 1.9gb, 622mb, 627mb, 357mb, 49mb, 70mb, 285mb) | VERIFIED — `_cat/indices` |

## 4. Retention / ISM

| Statement | Flag / Evidence |
|---|---|
| 4 ISM policies exist | VERIFIED — `_plugins/_ism` listing |
| `wazuh-archives-14d` attached to archives; `wazuh-retention` attached to alerts | VERIFIED — policy attachment output (P36) |
| **ZERO policy-driven deletions to date**; first expiry ≈ **2026-08-29** | VERIFIED — counts + policy state; phase38-79 |
| ISM explain endpoint returned empty once during verification (execution mechanics partially opaque) | PARTIAL — phase38-79 |
| Computable first-wave relief ≈ **3.76GB**; absolute archive ceiling ≈7.5GB. The legacy "~7.9GB" forecast is contradicted and impossible | CORRECTED — CON-38-06; arithmetic from §3 index sizes |
| **No snapshot repository registered** (`repository_missing_exception`) despite nightly snapshot cron | VERIFIED — phase38-26:18,78-80 |

## 5. Field Errors (CORRECTED mechanism)

| Statement | Flag / Evidence |
|---|---|
| Error signature: **"Limit of total fields [1000] has been exceeded"** | VERIFIED — container logs; phase38-25 |
| Origin: **indexer-side mapping limit** on `wazuh-archives-*` written by Filebeat | VERIFIED — log source analysis; phase38-25 |
| Volume: **8,746 lifetime**, currently **~150/min** | VERIFIED — scoped greps with time windows; phase38-25 |
| `decoder_order_size=512` staged exactly as reported but **IRRELEVANT** to these errors; P36 resolution claims misattributed | VERIFIED — config grep + signature mismatch; CON-38-01/02 |
| Correct fix: index-template `total_fields.limit` increase and/or source-field reduction | CANONICAL — ACT-38-002 |

## 6. Shuffle SOAR

| Statement | Flag / Evidence |
|---|---|
| Frontend bound **0.0.0.0:3001 — NO TLS, NO firewall rules** (exposed); backend **127.0.0.1:5001** (safe) | VERIFIED — `ss -tlnp`, probe, phase37-04/-07 |
| Bearer token `[REDACTED-TOKEN]` disclosed in generated report → treat as compromised; rotation pending | VERIFIED — leak location preflight.md:131; ACT-38-003 |
| Exactly **2 workflows**: `wazuh-high-severity-to-iris`, `wazuh-flow-classb-to-iris` (draft) | VERIFIED — API enumeration |
| `wazuh-high-severity-to-iris`: **68 FINISHED executions with real payloads** — OpenCanary L12 hits, most recent **today** | VERIFIED — API execution enumeration; phase38-23 |
| Total executions ≈ **796** | VERIFIED — API count |
| Production routing formally **deferred/gated** since P33 chain; integration informal despite real traffic | VERIFIED — decision trail; BCK-38-102 |
| Workflow exports on disk contain trailing HTML comment (invalid strict JSON) + no sha256 sidecars | VERIFIED — file tails inspected; MIS-38-06 |

## 7. Packet Pipeline & Endpoint Fleet

| Statement | Flag / Evidence |
|---|---|
| SO packet scanning retired (P31); Suricata-minimal is the packet engine, SPAN-gated | VERIFIED — git 43c4bf1, 98d5baf |
| Agent **016 v4.14.7 active**; **433 Suricata alerts indexed** sourced from `/var/log/suricata/eve*.json` | VERIFIED — agent status + index query; phase38-24 |
| Fleet: **8 ACTIVE** = 000, 006, 007, 011, 012, 014, 015 (**Julians-Air, reconnected today**), 016 | VERIFIED — agent-control snapshot; phase38-27 |
| **013 SAMSUNG disconnected** (not retired); **008 retired** (014 retirement completed P37) | VERIFIED — phase38-27 |
| Canary SID 2027967 approved (P34); E2E proven P35 (synthetic + real SPAN alert) | VERIFIED — phase34-08; cbcca53 |

## 8. `/tmp`

| Statement | Flag / Evidence |
|---|---|
| Usage **1.6GB / 7.6GB (21%)** | VERIFIED — df; phase38-28 |
| Cleanup cron line present **verbatim** and functional path restored since P31v2 incident | VERIFIED — crontab inspection; phase38-81 |

## 9. Deployability / DR

| Statement | Flag / Evidence |
|---|---|
| Overall deployability **PARTIAL** | VERIFIED — carried status; phase37-78 |
| Full-cluster restore **NO-GO** | VERIFIED — P28 architecture verdict; reinforced by missing snapshot repo (§4) |
| RTO/RPO targets **absent** from phases 37–78 → recovery objectives UNVERIFIED | VERIFIED (absence) — corpus scan; MIS-38-08 |
| Multi-index restore drill PASSED (P27); snapshot restore drill PASSED (P26) | VERIFIED historically — scoped to drills, not full-cluster |

## 10. Report Corpus

| Statement | Flag / Evidence |
|---|---|
| **1,888 `.md` files** at census cutoff (1,833 original + 55 phase38-generated); 1,900 after batch 43–54 | VERIFIED — census; phase38-43 |
| 26 unique sha256 duplicate groups; ~4% near-dup rate; 8 zero-byte stubs | VERIFIED — hash pass; phase38-43/-05/-06 |
| No final operator reports for Phases 1 and 36 | VERIFIED — filename sweep; phase38-43 §4.2 |
| Plaintext credentials in 3 generated reports: master.md:63, preflight.md:131, 38-73 §Step1 code block | VERIFIED — content inspection; REM-38-02 |

## 11. Owners & Risk Register (top)

| Area | Owner |
|---|---|
| Reports/corpus governance | ops-reports-owner |
| Shuffle/SOAR | SOAR ops owner |
| Wazuh manager/indexer config | Wazuh/indexer config owner |
| Infra (disk, snapshots, ISM) | Infrastructure owner |
| Endpoints | Endpoint ops owner |

| Risk | Severity | Note |
|---|---|---|
| Shuffle exposed (no TLS/firewall) | P0 | ACT-38-001 |
| Disclosed bearer token | P0 | ACT-38-003 |
| Ongoing field errors ~150/min | P0 | ACT-38-002 |
| Disk 84% + relief unproven until 08-29 wave | HIGH | BCK-38-105 |
| No snapshot repo → restore narrative weak | HIGH | BCK-38-103 |
| R-18 transient auth anomaly | MEDIUM | monitor |
| Plaintext creds in own reports | HIGH | REM-38-01/02 |

## 12. Redaction Note

This document deliberately does not restate secret values that prior generated reports leaked (master.md:63, preflight.md:131, 38-73 §Step1). Values are referenced by location only. Redaction + rotation tracked as REM-38-01/REM-38-02 and ACT-38-003.

## 13. Supersession Statement

For any conflict between this document and any earlier summary (including phase38-00-master §3), **this document wins**. Conflicts discovered later must be raised against this doc's claim IDs in phase38-50.
