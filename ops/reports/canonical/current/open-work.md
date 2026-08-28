# Open Work Register OPENWORK-42-01

**Report ID:** phase42-84-open-work-refresh
**Phase:** 42
**Title:** Open-Work Refresh OPENWORK-42-01 — Post-Phase-42 Consolidated Register (Five Closures Moved to Resolved Log: Churn, Nosniff, VT-Container, Custody-v1.3.1, EID-Root-Cause+v2; Owner Batch and ISM Wave Lead the Open Set)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T10:04:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `ops/reports/generated/phase42-84-current-state-refresh.md`
**Canonical Copy:** `canonical/current/open-work.md` (rewritten this phase; supersedes OPENWORK-41-01 content for tracking)

---

## 1. Register Rules

This file is THE open-work register going forward. It supersedes, for tracking purposes,
OPENWORK-41-01 (phase41-81) and through it OPENWORK-40-01 and earlier registers.
Prior IDs remain sticky for backlinks. Closed items move to §3 Resolved Log with closure
evidence; they are not deleted. One row per unique work item.

## 2. Open Work Master Table

| ID | Pri | Title | Status-today | Owner | Deps | Evidence ref | Rollback note |
|---|---|---|---|---|---|---|---|
| OW-40-01 (=BCK-38-011) | P2 | Recover agent 013 SAMSUNG | STILL-OPEN — offline >26h; owner device-side action required | Endpoint ops | user-held hardware | phase40-14…17; phase41-22; phase42-33…36 | N/A client-side; fallback formal retirement w/ approval |
| OW-40-02 (=BCK-38-012) | P2 | Agent 015 flap remediation | STILL-OPEN — owner device-side flap persists | Endpoint ops + Wazuh config owner | owner cooperation on device | phase40-18…24; phase42-37…39 | chmod/chown one-liner documented phase39-76 |
| OW-40-03 (=BCK-38-010) | P2 | Observe ISM first deletion wave | STILL-OPEN — window opens **2026-08-29T21:00:44Z**; policy attached/enabled on archives; watch arc complete through certification | Infrastructure owner | calendar | phase42-60…67; _ism/explain live [phase42-84] | N/A observation-only |
| OW-40-04 (=BCK-38-007) | P1 | Packet workflow import + routing proofs | DEFERRED BY CHOICE — capability research DEFINITIVE-negative (T1–T5); lane test-only/disabled with exact blockers; remediation B(platform upgrade)>A(UI rebuild)>C | SOAR ops + Detection | owner remediation-path choice | phase42-15…32; ROUT chain [phase42-84 §8] | Lane disabled test-only; artifacts sha-pinned |
| OW-40-05 (=BCK-38-015) | P1 | RTO/RPO sign-off | AWAITING-SIGNATURE — sole red gate G6 of the go/no-go matrix | Platform + SOC lead | owner decision | phase40-72; phase42-83 gate matrix | Documents only |
| OW-40-06 | P1 | Restore rehearsal on approved external target | NO-GO — red gates = exactly {G6 signature, G7 target approval}; spot-streak ×4 does not substitute | Infra + SOC lead | OW-40-05 outcome; approved target | phase42-81 scoreboard; phase42-82 V9 stage; phase42-83 matrix | Rehearsal env disposable |
| OW-40-11 | P2 | Commit/push Phase-42 changeset | STILL-OPEN — operator sign-off gate; tree dirty incl. AGENTS.md CHG-42-AGENTS-01 + canonical refresh + catalog appends | ops-reports-owner | operator review | git status live [phase42-87] | Git-native revert paths per changeset |
| OW-40-12 | P3 | Physical duplicate-path retirement in catalogs | STILL-OPEN — alias rows applied non-destructively; path retirement approval-gated | Governance | operator sign-off | phase40-79/-80; source-map-aliases.json valid live | Delete JSON rows; files never moved |
| OW-41-03 | P3 | Dashboard visual-render verification | LOGIN-GATED — browser session operator-held; data layer fully validated incl. v2 artifact | ops-reports-owner + operator | browser credentials | phase41-63/-64; phase42-68/-73 | N/A verification-only |
| **OW-42-01** | P1 | **Indexer disk-threshold policy decision (R-DISKBYPASS)** | NEW-P42 — watermark enforcement confirmed disabled cluster-wide; owner must enable thresholds or formally accept advisory posture; host at 84% meanwhile | Wazuh/indexer config owner + Infrastructure owner | sudo/config window | config line 44 wazuh1.indexer.yml; _nodes/settings live [phase42-89] | One-line yml revert; rolling restart of indexers |
| **OW-42-02** | P2 | v1.3.1 release-page publication | TOKEN-BLOCKED — tag+on-box custody proven; GitHub publication awaits owner token (exact call sequence ready) | MCT SOC (token holder) | GITHUB_TOKEN | phase42-79 §6; phase42-80 assurance | Delete remote tag + on-box dir per phase42-80 §3 |
| **OW-42-03** | P2 | Dashboard W2 v2 artifact swap + sign-off | STAGED — v2 (.keyword) imported with 4/4 parity in validation set; originals retained; global-tenant swap needs owner sign-off + browser session | Dashboard owner + Detection | OW-41-03 session | evidence/p42-dashboard-v2/ + SHA256SUMS; phase42-69/-73 | Re-import retained originals; rollback IDs recorded |

## 3. Resolved Log (closed through Phase 42; retained for backlink integrity)

| Prior ID | Item | Closure | Evidence |
|---|---|---|---|
| OW-41-05 / R-CHURN | Frontend restart churn (~92/day × 15d = 1,381 restarts) | **ELIMINATED + CERTIFIED** — repair script gated on actual reconnect; healthy no-op ×3 + forced-failure controlled recovery both PROVEN; CHURN-CERT-42-01 PASS; ≈92 avoidable restarts/day removed going forward | phase42-43…48 chain |
| OW-41-01 / R-XCTO | Duplicate nosniff header at :3443 | **DONE** — single `X-Content-Type-Options: nosniff` (and single XFO) verified live via curl -I | phase42-49/-50 |
| NEW-42 (partial) | VT integration conf exposure | **CONTAINER HALF CLOSED** — master ossec.conf hardened 644→640 root:root inside volume, 15/15 daemons running post-change; HOST-side chmod remains owner item under R-VTOSSEC | phase42-51…54 |
| OW-41-04 successor | v1.3.1 cut | **CUT + TAG PUSHED + ON-BOX ASSURED** — annotated tag 71701dfd→6579919 on origin; asset sha256 4e6c3712… re-verified; REL-ASR-42-01 ASSURED-ONBOX-PUBLICATION-PENDING; publication token-blocked split to OW-42-02 | phase42-77…80 |
| OW-41-02 (EID half) | Dashboard EID-mapping question | **ROOT-CAUSED + v2 STAGED** — signal is data.win.system.eventID (10,975 all-history); event.code NEVER populated (0 ever); v2 artifact with .keyword field 4/4 parity; originals retained; swap tracked as OW-42-03 | phase42-69/-70; evidence/p42-dashboard-v2 |
| (carried from OPENWORK-41-01 §3) | All eleven prior closures | Remain closed — churn/nosniff/EID/custody rows above supersede their open-row presence; field containment now adjudicator-armed (§6 canonical snapshot) | OPENWORK-41-01 sticky |
| OW-65-01 | Wazuh→IRIS delivery leg repair | **CLOSED + PERSISTENT** — root causes corrected: (1) network isolation fixed (manager added to mct-security network, compose-persistent + applied at runtime); (2) api_key placeholder replaced with real Shuffle key in host bind-mount (persistent). webhook_e3fec000 WAS already linked to c6b3fcd8 (trigger e3fec000-555f-4e81-9497-77b7c91c5b98); the earlier "0 executions" was a limited-RBAC listing artifact. Genuine end-to-end PROVEN: real Wazuh alert → integratord → Shuffle webhook → wazuh-high-severity-to-iris → IRIS POST SUCCESS/Routed 200 (status New), verified post-recreate. | phase65-wazuh-canary-alert.json; phase65-integratord-delivery.log; current-state-20260828-p66.md |
| OW-66-01 | IRIS read-back + genuine-event delivery | **CLOSED** — the MOUNTED Shuffle secret (/run/secrets/iris-shuffle.env, prefix c21731) was already the correct IRIS key and the workflow POSTs to the reachable URL https://iriswebapp_nginx:8443/alerts/add. Delivery VERIFIED: IRIS contains live objects 140-149 with source=wazuh, tags source:wazuh,class:A. Independent read-back VERIFIED (GET /alerts/149 -> 200 live Critical/New) after recovering the correct key from the IRIS DB and writing it to creds.env (the prior ops-vault key 31475ce6… was the only stale one). The earlier "delivery broken / 401" finding was INCORRECT — it tested the WRONG standalone iris-shuffle.env files, not the mounted secret used by the workflow. | p66-correlation.json; iris_db alerts 140-149; current-state-20260828-p66.md |

## 4. Standing Rule

Future reports reference ONLY these OW IDs for tracked work. Canonical copies:
this file + `canonical/current/current-state-20260826-p42.md`. AGENTS.md Known
Blockers mirrors the open set pointer-wise (refreshed under CHG-42-AGENTS-01).
