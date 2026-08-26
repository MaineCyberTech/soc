# Phase 38 Stale Claims Register

**Report ID:** phase38-45-generate-stale
**Phase:** 38
**Title:** Stale / Superseded Claim Registry — Historical Statement → Canonical Replacement, with Chronology
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-45-generate-stale.md`
**Retention Class:** LONG
**Supersedes:** prior draft of this report ID and `phase38-32-stale-claim-scan.md` candidate set
**Owners:** ["ops-reports-owner"]

---

## 1. Method and Rules

A claim is STALE when it was accurate when written (or was a defensible snapshot) but has been overtaken by verified live state; it is CONTRADICTED when two live claims conflict (see phase38-44). Each record preserves chronology: first-seen reference → intermediate evolution → last-asserted reference → canonical replacement. Historical reports are **never edited in place**; staleness is resolved by this registry plus supersession markers applied during migration (phase38-59/-69).

---

## 2. Registry

### STL-38-01 — decoder_order_size chain: default → 512 → IRRELEVANT

| Stage | Statement | Reference | Date |
|---|---|---|---|
| First seen | Suricata stats fields (522) exceed `decoder_order_size` default; errors attributed to analysisd buffer | `phase36-29/30-field-cardinality-*`; `phase37-35-field-baseline.md` | 2026-08-25 AM |
| Evolution | Fix designed + applied: `analysisg.decoder_order_size=512` staged in `local_internal_options.conf`, analysisd restarted, declared "APPLIED AND ACTIVE" | `phase36-31/32-field-cardinality-fix-*`; `phase36-75-final-report.md:24-30` | 2026-08-25 |
| Persistence | Post-change "resolution" asserted via zero-match grep on wrong string ("Too many fields") | `phase37-43-field-resolution.md:21` | 2026-08-25 PM |
| Superseded | Live grep: signature is "Limit of total fields [1000]" (8,746 lifetime, ~150/min); "Too many fields" matches **0** container-log lines; knob is indexer-side irrelevant. P36 resolution claims misattributed | `phase38-25-field-claim-verification.md` | 2026-08-25 |
| **Canonical** | Errors are an **indexer mapping limit** on `wazuh-archives-*` from Filebeat; fix = index-template field-limit increase or source reduction. decoder_order_size=512 remains staged but has no bearing | phase38-49 §5; ACT-38-002 | |

Why superseded: verification anchored to an inherited error string instead of the live log signature; mechanism never validated end-to-end.

### STL-38-02 — Shuffle frontend binding chain: loopback assumption → exposed reality

| Stage | Statement | Reference | Date |
|---|---|---|---|
| First seen | "Shuffle frontend: UP on 127.0.0.1:3001" | `phase36-17-shuffle-wazuh-integration-blocker.md` | 2026-08-25 AM |
| Evolution | "(was 127.0.0.1:3001)" implies deliberate exposure change with no change record; listener audit shows 0.0.0.0:3001, no TLS, no firewall | `phase36-75-final-report.md:21`; `phase37-04-shuffle-listener.md:11,22,52`; `phase37-07-shuffle-exposure-apply.md` | 2026-08-25 |
| **Canonical** | Frontend bound **0.0.0.0:3001, NO TLS, NO firewall** — treated as exposed-since-deployment pending contrary evidence; backend safe at 127.0.0.1:5001 | phase38-49 §6; ACT-38-001 | |

### STL-38-03 — Field-error signature: "Too many fields" → "Limit of total fields [1000]"

| Stage | Statement | Reference |
|---|---|---|
| First seen | All counting/grep used substring "Too many fields"; lifetime figures 15,189 then 18,849 circulated | `phase36-75-final-report.md:29`; `phase37-81-final.md:44-52` |
| Superseded | Actual signature "Limit of total fields [1000]"; "Too many fields" = 0 matches; scoped recount gives **8,746 lifetime**, **~150/min current** (earlier ~100/min figure understated rate) | `phase38-25-field-claim-verification.md` |
| **Canonical** | Use exact live signature + scoped counts with measurement window; never inherit strings across incidents | |

### STL-38-04 — Agent fleet lists evolving

| Stage | Statement | Reference | Date |
|---|---|---|---|
| Historical A | Fleet with 015 disconnected / closed-out; "Active agents: 7" | `phase33-*`, `phase35-35-agent015-connectivity.md`; `generated/phase38-00-master.md:116` | 2026-08-25 early |
| Historical B | 014 throttle → retire sequence; 008 retired earlier | `phase37-49/50-agent014-*`; git cbcca53 era notes | 2026-08-24→25 |
| **Canonical** | **8 ACTIVE**: 000, 006, 007, 011, 012, 014, 015 (Julians-Air reconnected today), 016 (v4.14.7, 433 Suricata alerts). **013 SAMSUNG disconnected** (not retired). **008 retired** | phase38-27-endpoint-claim-verification; phase38-49 §7 | 2026-08-25 |

Why superseded: fleet changed twice within 24h (015 reconnect, 014 retirement completed); snapshots must carry capture timestamps.

### STL-38-05 — Disk usage snapshot aging

| Stage | Value | Reference |
|---|---|---|
| P26/P27 era | 79.5% → plateau 81% | git cb8ca76, 9f09dda |
| P23 era | 85% → 83% relief | git baf8b95 |
| P36 era | incident + cleanup; LOW watermark language | `phase36-03-disk-incident.md` |
| **Canonical** | **84% (118G/148G, 24G avail)** as of 2026-08-25 ~20:00Z — still above low-watermark posture; forecast-based numbers (76%) invalid until wave observed | phase38-22-health-ci-verification; phase38-49 §3 |

### STL-38-06 — Memory/swap snapshot aging

| Stage | Value | Reference |
|---|---|---|
| P30 era | swap pressure diagnosis; swappiness 60→10 applied | git 0c24353 |
| **Canonical** | Mem 75% (11,750/15,553 MB); Swap 64%; PSI cpu avg10 ≈2.6 (avg60 ≈2.8) as of 2026-08-25 | phase38-22; phase38-49 §4 |

### STL-38-07 — Execution characterization: "all healthchecks" → mixed real activity

| Stage | Statement | Reference |
|---|---|---|
| First seen | "796 executions, all FINISHED healthchecks"; "Real routing: None" repeated through summaries | `generated/phase38-00-master.md:62,128`; `phase37-13-execution-inventory.md` |
| Superseded | API enumeration: `wazuh-high-severity-to-iris` has **68 FINISHED real-payload executions** (OpenCanary L12 hits, newest today); flow-classb still draft | `phase38-23-shuffle-claim-verification.md` |
| **Canonical** | "~796 total; ≥68 genuine alert-driven runs of high-severity workflow; production routing formally deferred" | phase38-49 §6 |

### STL-38-08 — Corpus count chain: 1831 → 1833 → 1877 → 1888

| Stage | Value | Scope actually counted |
|---|---|---|
| First | 1,831 | `.md`, primary root, first pass (`phase38-04`) |
| Recount | 1,833 | `.md`, primary root, post-late-writes (`phase38-31`) |
| Broad | 1,877 | all files, 3 roots (`phase38-03`) |
| **Canonical** | **1,888 .md** = 1,833 original + 55 phase38-generated (pre-write census); 1,900 after batch 43–54 | This audit; always state class+scope |

### STL-38-09 — Retention status chain: "deletes observed/rolling" → armed, zero deletions

| Stage | Statement | Reference |
|---|---|---|
| First seen | "retention deletes observed (disk 79.5%)" / "retention rolling (plateau 81%)" — described pre-ISM script-era cleanups | git cb8ca76 (P26), 9f09dda (P27) |
| Evolution | ISM policies created/attached (archives-14d → archives; retention → alerts); relief forecast ~7.9GB quoted forward | `b529e3b`; `phase36-75-final-report.md:15` |
| Superseded | ZERO policy-driven deletions; explain endpoint empty; no snapshot repository registered (`repository_missing_exception`); computable first-wave relief ≈3.76GB vs archive ceiling ~7.5GB | `generated/phase38-26-retention-claim-verification.md`; `generated/phase38-79-retention-verification.md` |
| **Canonical** | "ISM armed; zero deletions; first expiry ≈2026-08-29; no snapshot repo" | phase38-49 §8; BCK-38-105 |

### STL-38-10 — Deployability narrative: RTO/RPO silence

| Stage | Statement | Reference |
|---|---|---|
| Standing | "Deployability PARTIAL; full-cluster restore NO-GO" carried unchanged since P28–P30 era | `phase37-78-deployability.md`; git 21ba3d1, 0c24353 |
| Gap found | No RTO/RPO targets anywhere in phases 37–78 corpus scan → recovery objectives UNVERIFIABLE | `phase38-33-unverified-claim-scan.md`; `phase38-29-deployability-claim-verification.md` |
| **Canonical** | Status stays PARTIAL/NO-GO **and** explicitly "RTO/RPO undefined" until targets are authored | REM-38-11 |

### STL-38-11 — Release provenance phrasing

| Stage | Statement | Reference |
|---|---|---|
| First seen | "v1.3.0 released (tag, release 375979989, asset da72bde4)" presented as fully verified end-to-end | git 8e37ae9; later summaries |
| Superseded | Hash integrity VERIFIED byte-exact in-session; asset **not persisted on-box**; `gh` absent so release-object re-check limited | `phase38-21-release-claim-verification.md`; `phase38-34-missing-artifact-scan.md` |
| **Canonical** | "v1.3.0 (tag 790968b8, HEAD 7bd3b82); asset sha256 da72bde4… byte-exact VERIFIED; on-box archival MISSING" | phase38-49 §2 |

### STL-38-12 — OpenSearch credential stability

| Stage | Statement | Reference |
|---|---|---|
| Standing | admin credentials assumed stable; all queries scripted with them | corpus-wide |
| Event | One transient `Unauthorized` response this session despite unchanged credentials (risk R-18); retry succeeded | session log, phase38-30-credential-owner-verification note |
| **Canonical** | Credentials functional; treat single-failure anomaly as open risk R-18; monitor for recurrence | phase38-49 §11 |

---

## 3. Application of Markers

During migration apply (BCK-38-106), each superseded source file listed above receives frontmatter `superseded_by: phase38-45#STL-38-NN` (or pointer to phase38-49 section). No historical text is altered. Chronology in this registry is authoritative when read order matters.

## 4. Review Cadence

Re-validate every entry at: ISM first wave (2026-08-29), Shuffle hardening completion, field-limit fix application, and any agent-fleet change event.
