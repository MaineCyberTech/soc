# Open Work Register OPENWORK-40-01

**Report ID:** phase40-75-open-work-refresh
**Phase:** 40
**Title:** Open-Work Refresh OPENWORK-40-01 — Post-Phase-40 Consolidated Register (Closed Items Moved to Resolved Log; Live Items With Owners)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `ops/reports/generated/phase40-75-report-current-state-refresh.md`
**Canonical Copy:** `canonical/current/open-work.md` (rewritten this phase; supersedes OPENWORK-39-02 content for tracking)

---

## 1. Register Rules

This file is THE open-work register going forward. It supersedes, for tracking purposes,
OPENWORK-39-02 (phase39-88) and through it the phase38-47/-90 registers. Prior IDs remain
sticky for backlinks. Closed items move to §3 Resolved Log with closure evidence; they are
not deleted. One row per unique work item.

## 2. Open Work Master Table

| ID | Pri | Title | Status-today | Owner | Deps | Evidence ref | Rollback note |
|---|---|---|---|---|---|---|---|
| OW-40-01 (=BCK-38-011) | P2 | Recover agent 013 SAMSUNG | STILL-OPEN — owner device-side action required | Endpoint ops | user-held hardware | phase40-14…17 baseline/recovery/postcheck/certification | N/A client-side; fallback formal retirement w/ approval |
| OW-40-02 (=BCK-38-012) | P2 | Agent 015 flap remediation | PARTIAL-CLOSED — manager merged.mg defect FIXED (83,736 lifetime errors ended); flap remediation owner device-side remains | Endpoint ops + Wazuh config owner | owner cooperation on device | phase40-18…24 chain; ossec.log frozen-count check live this phase | chmod/chown one-liner documented phase39-76 |
| OW-40-03 (=BCK-38-010) | P2 | Observe ISM first deletion wave | STILL-OPEN — window opens 2026-08-29 | Infrastructure owner | calendar | phase40-54…58 prewave/diff/relief; policy corrected to archives-14d (verified live) | N/A observation-only |
| OW-40-04 (=BCK-38-007) | P1 | Packet workflow import + routing proofs | DEFERRED BY CHOICE — path proven open (POST 200); import held until refinement set lands; ROUT-PKT-40-01 deferred-not-rejected | SOAR ops + Detection | refinement specs 44–47 applied to artifact | phase40-41/-48/-49/-53; stray probe cleaned (workflows API live: 2 remain) | None taken; artifact untouched sha256-pinned |
| OW-40-05 (=BCK-38-015) | P1 | RTO/RPO sign-off | STILL-OPEN — evidence inventory complete+fresh; owner decision worksheet issued awaiting return | Platform + SOC lead | owner decision; rehearsal target | phase40-70/-71/-72 | Documents only |
| OW-40-06 | P1 | Restore rehearsal on approved external target | NO-GO — no adequate target approved yet | Infra + SOC lead | OW-40-05 outcome; target env | phase40-70 §156 (seven unmeasured steps enumerated) | Rehearsal env disposable |
| OW-40-07 (=OW-39-02) | P2 | Retrieve/pin published-original v1.3.0 asset | STILL-OPEN — rebuilt-from-tag copy on-box, honestly labeled | Release owner | network/GitHub access | phase39-68…70 lineage; MANIFEST.md disclosure | Additive pinning only |
| OW-40-08 | P3 | Duplicate XFO/nosniff header cleanup at TLS proxy | STILL-OPEN — double-set headers verified live (DENY vs SAMEORIGIN collision) | SOAR ops | proxy config edit window | live curl -I this phase; phase40-31 risk note | nginx conf backup before edit |
| OW-40-09 | P3 | windows-clients agent.conf.bak root-owned hygiene | STILL-OPEN — remoted Permission-denied + invalid-shared-file noise persists | Wazuh config owner | none | phase40-20 log capture; live error lines | Move .bak out of shared dir or align perms |
| OW-40-10 (=R-2) | P3 | Paired pre-change ossec.conf backups (worker gap) | STILL-OPEN as standing rule — worker pre-change copy not retained during webhook apply | Wazuh config owner | next config change | phase40-40 certification table row 7 | Rule adoption; no retro action possible |
| OW-40-11 | P2 | Commit/push Phase-40 changeset | STILL-OPEN — operator sign-off gate (G40-12); tree dirty incl. AGENTS.md refresh CHG-40-AGENTS-01 | ops-reports-owner | operator review | git status live; phase40-02 register G40-12/G40-13 | Git-native revert paths per changeset |
| OW-40-12 | P3 | Physical duplicate-path retirement in catalogs | STILL-OPEN — alias rows APPLIED non-destructively (DUP-APP-40-01); path retirement separately approval-gated | Governance | operator sign-off | phase40-79/-80; source-map-aliases.json | Delete JSON rows; files never moved |

## 3. Resolved Log (closed this phase; retained for backlink integrity)

| Prior ID | Item | Closure | Evidence |
|---|---|---|---|
| BCK-38-003 | Field-limit fix verification | CLOSED 2026-08-26 VERIFIED — limit 2000 live, zero field-limit errors trailing 24h vs 8,107 lifetime; representative ingest clean | phase40-13; live indexer-log greps |
| OW-39-01 / part of BCK-38-004 | Shuffle TLS | CLOSED-via-implementation — nginx :3443 HSTS up; plaintext LAN closed (loopback :3001 only) | phase40-25…32; live ss/openssl |
| BCK-38-006 | Wire automated Wazuh→Shuffle trigger | CLOSED WIRED+PROVEN — E2E-007 full-chain marked proof → IRIS alert 42 (~2 s); dual-node integratord; group-filter semantics discovered and documented | phase40-33…40 |
| part of BCK-38-012 | Agent-015 merged.mg manager defect | CLOSED FIXED — 83,736 lifetime permission errors ended; config delivery certified | phase40-18…24 |
| BCK-38-014 | Build/import W1/W2 dashboards | CLOSED IMPORTED 8/8 objects into global tenant; data validation + usability done | phase40-61…64 |
| OW-39-03 | Schedule delivery-failure alerting monitor | CLOSED SCHEDULED */15 + flock hardening; two real runs observed | phase40-65…68 |
| ISM-40-01 | ISM 08.26 attachment anomaly | CLOSED CORRECTED — index attached to wazuh-archives-14d (explain verified live) | phase40-56; live explain |
| IMP-39-mystery | Packet workflow API 401 mystery | CLOSED SOLVED — trailing-newline token artifact reproduces historical 401s; POST works; stray probe created then cleaned via datastore+backend-restart | phase40-41; live workflows listing |
| R-IMP-40-A | Stray probe workflow cleanup | CLOSED CLEANED — platform shows exactly 2 workflows | live API listing this phase |

## 4. Standing Rule

Future reports reference ONLY these OW-40 IDs for tracked work. Canonical copies:
this file + `canonical/current/current-state-20260826.md`. AGENTS.md Known Blockers
section mirrors the open set pointer-wise (refreshed under CHG-40-AGENTS-01).
