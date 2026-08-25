# Phase 38 Recommendation History

**Report ID:** phase38-18-recommendation-history
**Phase:** 38
**Title:** Phase 38 Recommendation History — Traceability of Every Roadmap/Action Recommendation Across Phases
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T19:56:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/big-pickle
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-18-recommendation-history.md`
**Retention Class:** LONG

---

## 1. Method

Every forward-looking recommendation / roadmap item located in final operator reports, closeout reports, backlog files, and commit subjects is cataloged with its origin and traced forward. Outcome classes:

`COMPLETED` | `DEFERRED` | `BLOCKED` | `SUPERSEDED` | `CONTRADICTED` | `MISSING_EVIDENCE` | `OPEN_UNADDRESSED`.

Primary recommendation sources reviewed this session: `phase36-75-final-report.md` §Recommendations (5 items), `final-phase37-operator-report` §12 Phase 38 Roadmap (6 items), git commit "next:" pointers (e.g., `98d5baf`, `43c4bf1`), phase38-90-backlog.md existence, plus historical finals' closing sections.

---

## 2. Phase 37 → Phase 38 Roadmap (most recent authoritative set)

Origin: `final-phase37-operator-report-20260825-1943Z.md` §12.

| # | Recommendation | Trace result (as of phase38) | Outcome class |
|---|---|---|---|
| RM-1 | Harden Shuffle — TLS, firewall, restrict bind address | Hardening plan drafted in P37; compose still binds 0.0.0.0:3001 (verified line 21); no TLS artifacts found; phase38-73-shuffle-hardening report exists in generated set but no applied change recorded | **OPEN_UNADDRESSED (plan-only)** |
| RM-2 | Resolve field cardinality — increase to 1024 or minimize sources | Design exists (phase37 field-resolution design); config still =512 (verified); errors continue ~100/min | **OPEN — CONTRADICTED interim fix** (512 path failed) |
| RM-3 | Create packet workflow (isolated design) | Deferred by P37 itself into Phase 38; phase38-75/76 packet-workflow reports exist as design/proof documents; no workflow created on platform (796 executions remain healthchecks) | **DEFERRED → design progressed, implementation MISSING_EVIDENCE** |
| RM-4 | Integrate Wazuh→Shuffle webhook for alert routing | Still UI-gated (DF-35-01 chain); blocker report phase36-17 unchanged; no integration config evidence | **BLOCKED (operator UI action)** |
| RM-5 | Observe ISM wave — validate first deletion 08-29 | Event dated in future relative to snapshot; monitoring stance documented (phase38-79-retention-verification exists) | **PENDING (scheduled observation)** |
| RM-6 | Validate /tmp cron first execution | This session could not locate the entry in host crontab; container probe inconclusive; phase38-81-tmp-validation report exists | **MISSING_EVIDENCE (control unproven)** |

---

## 3. Phase 36 Final Recommendations (5 items)

Origin: `phase36-75-final-report.md` §Recommendations.

| # | Recommendation | Trace result | Outcome class |
|---|---|---|---|
| RC-1 | Operator: change Shuffle password after first login | Admin-side rotation done P37 (`phase37-03`); operator-side rotation still pending per same report | **PARTIAL → OPEN (operator step)** |
| RC-2 | Operator: configure Wazuh→Shuffle webhook via UI | Same as RM-4 | **BLOCKED/OPEN** |
| RC-3 | Monitor disk daily until wave executes (2026-08-29) | Monitoring institutionalized (daily audits phase36-70; phase38 preflight re-affirms watermark) | **COMPLETED-as-process (continues)** |
| RC-4 | Monitor agents 013/015 for reconnection | Monitored; both still disconnected at P37/live | **COMPLETED-as-process; underlying issue OPEN** |
| RC-5 | Verify "Too many fields" errors stop next analysisd cycle | Verification executed in P37 — errors did NOT stop (~100/min) | **EXECUTED → CONTRADICTED the P36 success claim** |

---

## 4. Historical Roadmap Pointers from Commit Subjects ("next:" chains)

Git subjects encode explicit successor commitments. Traced:

| Commit pointer | Commitment | Later fulfillment |
|---|---|---|
| `98d5baf` (P31 SPAN) | "next: Wazuh ingest + broader ruleset" | Fulfilled: `91f6789` EVE ingest; ET ruleset sid 2027967 fired offline P32 (`49dfdda`) | COMPLETED |
| `43c4bf1` (P31) | health model + status page + alerts designed; P0-P3 backlog | Health model/alerts landed P32-P33 (7 checks HEALTHY `79f6cbe`) | COMPLETED |
| `49dfdda` (P32) | detection gate closed → observe-only; alerts designed | Observe windows ran P33/P34 | COMPLETED |
| `79f6cbe` (P33) | canary routing gated pending forwarding | Forwarding applied `dca1691`; E2E proven P35 | COMPLETED |
| `3d4d072` (P34) | retention wave staged (~08-29); endpoint/shuffle carry | Wave staged confirmed P35/P36; shuffle carried forward (still open) | PARTIAL (retention on track; shuffle open) |
| `cbcca53` (P35) | Shuffle routing deferred (UI-gated) | Carried to P37/P38 unchanged | DEFERRED (standing) |
| `b529e3b` (P36) | field fix, endpoint recovery, /tmp cleanup, audits | Field fix contradicted later; endpoints recovered partially (2 remain down); /tmp cron unproven | MIXED (see §2/§3 rows) |
| `7bd3b82` (P37) | hardening plan, field resolution design | Both exist as plans only | DEFERRED into phase38 |

Historical completion rate of explicit "next:" commitments through P35: high (all traced); degradation begins with P36's impact-prediction-style closure (RC-5 failure).

---

## 5. Older Standing Recommendations Sampled (pre-P30)

| Origin | Recommendation | Fate |
|---|---|---|
| P17.11/P18.13 ILM action plan | address archives >> alerts growth | Evolved into RET-25-01 alignment + P36 ISM attach → **in-flight (wave 08-29)** |
| P17.12/P18.14 Shuffle/IRIS routing map | enable after noise validation | Zeek Class A enabled P25; full alert routing still gated (**OPEN**, oldest continuously-open routing rec) |
| P18.15 macOS flood fix doc | apply agent-local fix | Applied era P17 root-fix; steady-state verified → **COMPLETED** |
| P24 sysmon README/tuning suite | fleet-wide RMM rollout | Scripts shipped; per-endpoint application evidence partial (013/014 touched) → **PARTIAL / MISSING_EVIDENCE for full fleet** |
| P28 DR architecture | achieve full-cluster restore capability | Still NO-GO → **OPEN (longest-standing structural gap)** |
| P29 release discipline | cut releases on cadence | v1.3.0 released 08-24; 13 commits accrued since without tag → **SLIPPING (cadence breach emerging)** |

---

## 6. Outcome-Class Totals (this catalog)

| Outcome class | Count |
|---|---|
| COMPLETED (incl. completed-as-process) | 7 |
| DEFERRED (standing deferral active) | 3 |
| BLOCKED | 1 (webhook/UI gate) |
| SUPERSEDED | 1 (interim fixes replaced by newer designs) |
| CONTRADICTED | 1 (decoder fix effectiveness) |
| MISSING_EVIDENCE | 2 (/tmp cron proof; sysmon fleet-wide application) |
| OPEN_UNADDRESSED | 1 (Shuffle hardening beyond plan) |
| PENDING scheduled event | 1 (ISM wave 08-29) |

---

## 7. Pattern Analysis

1. **Plan-to-execution drop-off concentrates at operator-gated steps.** Every BLOCKED/open item requires either Shuffle UI access or physical endpoint possession — never engineering-only work.
2. **Impact-prediction closures are unreliable.** The single CONTRADICTED outcome (RC-5/R-02) originated from recording predicted impact (−15,189 errors) as if achieved. Post-P36 reports corrected it within one cycle.
3. **Deferrals survive indefinitely without forcing events.** DF-35-01 (routing) has been re-deferred across P35→P36→P37→P38. Contrast with retention, where a dated wave forces resolution.
4. **Process recommendations complete reliably** (monitoring cadences, audits) — they convert into standing scripts/crons rather than one-shot actions.
5. **Roadmap continuity is good**: every P37 roadmap item maps to a phase38 generated report stub (73/75/76/79/81), so nothing was dropped administratively; the gap is execution evidence, not tracking.

---

## 8. The P32→P35 Carry-Forward Chain (measured from final reports)

Roadmap sections were extracted directly from four consecutive finals. Their overlapping items reveal which recommendations persist unchanged across phases:

**P32 final → "Recommended Phase 33 roadmap" (6 items):**
alert wiring live cron + dashboards; 24h observe + production SID routing; endpoint markers (013/014 RMM) → cert PASS → retire throttles → W1/W2 dashboards; disk wave confirm (~08-29) + /tmp monitor; adequate isolated target → fresh-target proof → deployability PASS + full-cluster drill; Shuffle UI implementation + replay/failure proof.

**P33 final → "Recommended Phase 34 roadmap" (7 items):** adds drops/memcap + resource + ruleset-age wiring detail, canary volume gate, retention plateau measurement, and begins "credential/owner closure: VT, PVE, indexer, NetFlow scope, Redis, Greenbone".

**P34 final → "Recommended Phase 35 roadmap" (8 items):** adds agent 016 forwarding decision (eve.json localfile vs on-demand eve-alert.json), production routing decision after volume PASS.

Trace of the four multi-phase carries:

| Carry item | Phases carried | Resolution evidence | Outcome class |
|---|---|---|---|
| Endpoint markers → cert PASS → throttle retirement → W1/W2 dashboards | P32, P33, P34 (originating P30 series files: phase30-22…27, ps4104 cycle) | Markers/certs exist as phase30 reports; PS4104 decision recorded; windows dashboard report exists; 013 reconnected P24 then lost again | **MOSTLY COMPLETED historically; reopened by fleet loss** |
| Adequate isolated target → fresh-target runtime proof → deployability PASS + full-cluster drill | P32, P33, P34 (originating P28 NO-GO + phase30-39…53 build-out) | Build-out series ends full-cluster-cleanup with NO-GO standing; every later final repeats PARTIAL/NO-GO | **BLOCKED — 5-phase carry, unresolved** |
| Shuffle UI implementation + replay/failure proof | P30 (attempted: phase30-32…38 UI window/dedup/counter/malformed/replay/failure/cron-failover), P32, P33, P34 | Early attempts produced failure/cron-failover reports; P35 formally deferred (UI-gated); P36 resolved auth only; P37 audited | **DEFERRED after failed attempt cycle — longest-running routing rec (since P17/P18 mapping)** |
| Credential/owner closure: VT, PVE, indexer, NetFlow, Redis, Greenbone | P33, P34 | PVE blocked SO postmortem (`0c24353`); NetFlow scope declared OOS (P18); Redis noise closed via 120537 demotion (P18); indexer rotation rolled back cleanly (P29) — closure list never fully discharged | **PARTIAL / MISSING_EVIDENCE (per-credential status not centrally tracked)** |

Chain-integrity observation: items 3–6 of the P32 roadmap survive verbatim into the P34 roadmap — the roadmap is acting as a persistent queue rather than a plan-of-record per phase. This is honest but hides aging; no carry item carries an age stamp. Recommend age-stamping carried items going forward (RH-06).

---

## 9. Recommendations Issued by This Report

| ID | Recommendation | Rationale |
|---|---|---|
| RH-01 | Attach due dates ONLY when an origin document states them; use forcing events otherwise (08-29 pattern) | Prevents silent deferral drift (finding §7.3) |
| RH-02 | Require post-change metric verification before any impact claim enters a final report | Directly addresses the sole CONTRADICTED case |
| RH-03 | Convert operator-gated blockers into scheduled operator sessions with named owners | Breaks the UI-gate deadlock (RM-4, RC-1) |
| RH-04 | Cut v1.3.1 (or v1.4.0) to absorb the 13 unreleased commits | Restores release-cadence discipline (§5 last row) |
| RH-05 | Produce runtime proof for /tmp cron (crontab inside manager container or host) within next ops window | Closes MISSING_EVIDENCE RM-6 |
| RH-06 | Age-stamp carried roadmap items (first-proposed phase + carry count) | Exposes multi-phase aging found in §8 (e.g., isolated-target item carried ≥5 phases) |
| RH-07 | Central credential/owner closure ledger with one row per named credential (VT, PVE, indexer, NetFlow, Redis, Greenbone) and last-verified date | Replaces the recurring prose closure list that never fully discharges (§8 row 4) |

---

## No secrets
