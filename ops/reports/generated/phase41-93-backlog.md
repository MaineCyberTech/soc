# Phase 41 Consolidated Backlog (P0–P3)

**Report ID:** phase41-93-backlog
**Phase:** 41
**Title:** BCK-41-001…010 — Consolidated Phase 42 Backlog: Owner-Batch Bundle (One Session, Four Items), Field-Flip Adjudication Tomorrow AM, ISM Wave Watch Aug-29, Packet Remediation Decision, v1.3.1 Cut Execution, Plus Quick-Wins (XCTO Dedup ⚡, R-CHURN Cron Audit ⚡, VT Key Value-Blind Verify ⚡)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T07:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-93-backlog.md`

---

## 1. Purpose and Method

This register merges every still-open item from the Phase 41 arcs with new findings surfaced by
this phase's audits and drift sweep (phase41-92). Canonical IDs here are `BCK-41-0xx`; every item
crosswalks to its OW/BCK lineage and same-day phase41 evidence. Items closed this phase are
dispositioned in §4, not silently dropped. Sorted by priority, then effort (XS < S < M < L).
Quick-wins flagged ⚡.

### Priority distribution

| Priority | Count | Canonical IDs |
|----------|-------|---------------|
| P0 | 4 | BCK-41-001 … 004 |
| P1 | 1 | BCK-41-005 |
| P2 | 4 | BCK-41-006 … 009 |
| P3 | 1 | BCK-41-010 |

### Owner-batch note (one session, four items)

A single owner session covers the four human-latency items at once:
**BCK-41-001a** (power on agent 013), **BCK-41-001b** (caffeinate/power-settings on agent 015),
**BCK-41-001c** (sign DEC-40-01 RTO/RPO sheet), **BCK-41-001d** (approve the rehearsal target).
Batch them — dispatching them one-by-one is how they aged through P38→P41.

---

## 2. Crosswalk — Canonical → Lineage

| Canonical | Lineage | Origin plane |
|-----------|---------|--------------|
| BCK-41-001 | OW-40-01/-02 + OW-40-05/-06 carryover (all inputs READY) | Endpoints + DR/business |
| BCK-41-002 | G41-14 ARMED successor (phase41-18 flip condition) | Detection pipeline / capacity |
| BCK-41-003 | OW-40-03 carryover (window dated) | Capacity / retention |
| BCK-41-004 | OW-40-04 + ROUT-PKT-41 remediation fork | SOAR / detection |
| BCK-41-005 | OW-41-04 (DECISION-V131-41-01; RELPLAN-41-01 staged) | Release |
| BCK-41-006 | OW-41-01 carryover (XCTO half) | Security hygiene |
| BCK-41-007 | NEW this phase (OW-41-05 / R-CHURN, phase41-92 D-41-07) | SOAR ops / config hygiene |
| BCK-41-008 | NEW this phase (D-41-14 / R-VTOSSEC, phase41-87 masked probe) | Wazuh config security |
| BCK-41-009 | OW-41-03 carryover (login-gated) | Visibility |
| BCK-41-010 | OW-41-02 carryover (owner query raised) | Detection / dashboards |

---

## 3. Backlog Detail

### BCK-41-001 (P0, effort M — human-latency, OWNER-BATCH, ONE SESSION) — Four-item owner bundle: 013 power · 015 caffeinate · sign DEC-40-01 · approve rehearsal target

| Field | Value |
|---|---|
| Description | All four inputs have been READY for multiple phases; only human action is missing. (a) Agent 013 SAMSUNG power-on (runbook + cert template ready; sustained-proof + final-cert chain phase41-19…22). (b) Agent 015 Julians-Air caffeinate/power-settings during working hours (manager-side merged.mg defect long FIXED; final state phase41-23…26). (c) Signature on DEC-40-01 RTO/RPO adoption sheet (proposal RTODRF-40-01 values; decision sheet re-presented phase41-27/-28). (d) Approval/naming of the adequate EXTERNAL restore-rehearsal target (candidates assessed phase41-29/-30/-31; restore plan consumes it). |
| Owner | Endpoint ops + device owners (a,b); SOC lead/business (c,d) |
| Dependencies | None technical. Items (c)+(d) pair naturally — the signature provides the drill's pass/fail criterion. |
| Acceptance criteria | (a) 013 ACTIVE, keepalive >24 h, certification completed from template; (b) zero sleep-correlated disconnect windows across 48 h agreed-active-hours; (c) DEC-40-01 AWAITING-OWNER→ADOPTED with signature reference in change register; (d) target named/approved per criteria; go/no-go leaves NO-GO after Stage0 approvals. |
| Rollback | (a,b) revert power settings; (c,d) document decisions only. |
| Evidence links | phase41-19…22, -23…26, -27/-28, -29…31 |
| P42 effect | Fleet numerator 7→8–9/10; objectives bind; rehearsal unblocks; DR AMBER cell clears its gates. |

### BCK-41-002 (P0, effort S, dated TOMORROW MORNING 2026-08-27) — Field-flip adjudication: run the CONTAINED-PENDING → VERIFIED check on the 08.27 index

| Field | Value |
|---|---|
| Description | The quarter's top technical risk enters final adjudication. Certification is CONTAINED-PENDING-FULL-CYCLE (phase41-18); flip conditions are fully specified and the addendum template PRE-DRAFTED (phase41-18 §8). The guardrail runs on its existing schedule against `wazuh-archives-4.x-2026.08.27`; owner checks the result before 09:00 UTC. |
| Owner | Platform / detection engineering |
| Dependencies | Calendar only (index births ~00:00Z); adjudication script staged. |
| Acceptance criteria | Five conditions per phase41-18 §4: (1) first-run leaf_fields (raw basis) ≤1400; (2) mid-day second run still ≤1400; (3) zero docs with `data.stats.exists`; (4) compact lane fresh (~1/min stats_compact docs); (5) win-family unique ≤150. ALL met → ADDENDUM A flips certification to **VERIFIED**, closing the P38→P41 field arc. Any failure → stay-pending with attribution rerun using the phase41 method set. |
| Rollback | None for adjudication itself; failure branch uses the documented un-wire sequence (phase41-15 §7). |
| Evidence links | phase41-15/-16/-17/-18; G41-14 register row (phase41-02) |
| P42 effect | Converts containment into closure; retires the dominant capacity risk permanently. |

### BCK-41-003 (P0, effort S + watch, dated 2026-08-29T21:00Z) — Observe first policy-driven ISM deletion wave

| Field | Value |
|---|---|
| Description | Window opens 2026-08-29T21:00Z (~1.8 GB expected relief). Policy `wazuh-archives-14d` verified attached, hot, evaluating transitions (live `_ism/explain`, phase41-53/-54). Forced deletion remains prohibited per AGENTS.md. |
| Owner | Platform / infrastructure |
| Dependencies | Calendar checkpoint Aug-30 morning. |
| Acceptance criteria | Post-wave deleted-index count matches ISM math on archives-14d indices; disk% drop captured in trend log; one expired index sampled restorable from snapshot; observation appended to the retention chain. Non-firing wave → ISM diagnostics escalation, never force-delete. |
| Rollback | N/A (observation task). |
| Evidence links | phase41-53…60; phase40-54…58/-60 lineage |
| P42 effect | Converts the staged forecast into realized relief; input to the standing 82–84% capacity program. |

### BCK-41-004 (P0, effort S decision + M execution) — Packet-lane remediation path choice: UI rebuild on native nodes (RECOMMENDED) vs platform upgrade

| Field | Value |
|---|---|
| Description | ROUT-PKT-41 deferred production routing with a precisely documented platform blocker (R-PKT-PLATFORM): `execute_python` exposes NO incoming-data variable (`data_in`/`input`/`execution_input`/`execution_data`/`data` all UNDEF, probe-verified) and `$param` refs arrive as literals — normalize/validate/isolation/dedup semantics cannot be certified on this build. Two paths staged (phase41-52 §3). **Recommendation: R-a** — owner UI session rebuilds the gating chain on natively reference-consuming nodes (`filter_list`, `if_else_routing`, `set_datastore_value`, which DO resolve refs per Class-A precedent); cheaper than an upgrade window; python nodes demoted to non-gating enrichment. R-b (Shuffle upgrade) fixes the root cause for all lanes but needs an approved upgrade window + full regression re-run of the entire proof arc. |
| Owner | SOAR-ops + detection engineering; owner ratifies path choice |
| Dependencies | Decision first; either path then re-runs the blocked proofs (dedup, counter, malformed, datastore/downstream failure) before any gate claim revives. Workflow stays disabled/test-only until then. |
| Acceptance criteria | Path ratified in register; remediated chain passes ALL-NODES-CLEAN executions plus the withheld behavioral proofs with synthetic-marked events only; SID 2027967 shortlist activates; ROUT-PKT-41 upgraded from DEFERRED. |
| Rollback | Delete/re-disable workflow object; Class-A certified lane untouched; zero production contamination maintained. |
| Evidence links | phase41-41…52 arc; phase41-52 §2–3 |
| P42 effect | Closes the last detection-plane lane gap honestly or documents why not; retires a billing disclosure either way. |

### BCK-41-005 (P1, effort M — execution session, checklist pre-drafted) — v1.3.1 cut at Phase-42 open per RELPLAN-41-01

| Field | Value |
|---|---|
| Description | DECISION-V131-41-01 fixed the cut at Phase-42 open; RELPLAN-41-01 stages it (freeze → docs sweep → tag → build/publish → API hash verify → on-box custody repeat → MANIFEST v1.3.1 → closeout). The D-register is FINALIZED this cycle (D-1…D-12, phase41-98 §3). Contingency: if packet-lane work slips, cut with D-1…D-12 only and move packet-lane to the v1.3.2 register (phase41-79 §5). |
| Owner | Release engineering + operator sign-off for tag |
| Dependencies | Phase-41 commit lands first (G41-13 / phase41-99); packet decision BCK-41-004 desirable but not gating under contingency. |
| Acceptance criteria | All six acceptance criteria of RELPLAN-41-01 §4, incl. byte-exact published↔on-box sha256 and same-session MANIFEST row. |
| Rollback | Per-stage rollback table in RELPLAN-41-01 §3 (pre-tag unfreeze; post-tag delete-before-publish; post-publish yank + corrective tag). |
| Evidence links | phase41-77/-78/-79; phase41-98 §3 |
| P42 effect | First tag to ship with custody-closed day-one posture; folds twelve labeled deltas into the release of record. |

### BCK-41-006 (P2, effort XS ⚡quick-win, minutes) — Duplicate X-Content-Type-Options header cleanup at :3443

| Field | Value |
|---|---|
| Description | XFO half of the old duplicate-header finding is CLOSED (exactly one `X-Frame-Options: DENY` live, phase41-66); the sibling remains: `X-Content-Type-Options: nosniff` still emitted 2× (app + proxy), count=2 live. Cosmetic-to-compat; flagged by header scanners; HSTS intact and must stay. |
| Owner | SOAR-ops / infrastructure |
| Dependencies | Proxy config edit window (nginx conf backup first). |
| Acceptance criteria | Single XCTO header through :3443; HSTS + nosniff retained exactly once each; authorized 200-class test re-run; delta folded into v1.3.1 manifest (D-10 extension). |
| Rollback | Revert nginx conf line; reload proxy. |
| Evidence links | phase41-65/-66; phase41-87/-92 (D-41-08) |
| P42 effect | Retires the last header-hygiene residual; R-XCTO closes. |

### BCK-41-007 (P2, effort S ⚡quick-win-leaning audit) — shuffle-repair-network cron churn: gate the frontend restart on detected DNS failure (R-CHURN)

| Field | Value |
|---|---|
| Description | NEW THIS PHASE. `shuffle-repair-network.sh --apply` restarts shuffle-frontend UNCONDITIONALLY every */15 tick — ~96 restarts/day with no failure present (RestartCount=0, fresh StartedAt; docker events kill/start observed 06:30:02–03Z). Almost certainly unnecessary churn: masks real availability signals, adds log noise, wastes cycles. Likely disposition is disable-or-condition; recommend gating the restart branch on an actual DNS-failure probe result so the repair keeps working when needed. |
| Owner | SOAR-ops |
| Dependencies | None (script edit + unchanged cron). |
| Acceptance criteria | Restart fires ONLY on detected DNS failure (forced-failure test proves it once); steady-state shows zero restarts across a full day; churn metric re-baselined in drift register; change folded into v1.3.1 docs sweep. |
| Rollback | Revert one hunk (script lines ~59–61); behavior returns to prior unconditional state if ever desired. |
| Evidence links | phase41-92 D-41-07; OW-41-05 |
| P42 effect | Removes a daily ~96× confounder from frontend availability evidence. |

### BCK-41-008 (P2, effort S ⚡value-blind verify) — virustotal api_key in master ossec.conf: placeholder-vs-real verification, then migrate to creds-reference

| Field | Value |
|---|---|
| Description | NEW THIS PHASE. Master ossec.conf carries an inline virustotal integration `api_key` whose VALUE was never printed (masked awk probe, phase41-87): it is either a real key or a long placeholder — indistinguishable value-blind today; the Shuffle-side key is a literal placeholder on both nodes ✓. Standing rule holds: no secret values anywhere. Verify value-blind (length/entropy/behavioral test without printing), then migrate to the creds-reference pattern used by other integrations at the next config window. |
| Owner | Wazuh config owner |
| Dependencies | Next config window touching master ossec.conf; paired pre-change backups both nodes (R-2 rule). |
| Acceptance criteria | Value-blind classification recorded (real vs placeholder) WITHOUT any value or truncation entering reports; if real → migrated to env/creds reference with rotation scheduled per standing cadence; if placeholder → removed or labeled; post-change integration still functions. |
| Rollback | Restore paired backup; revert one config block. |
| Evidence links | phase41-87 (R-VTOSSEC); phase41-92 D-41-14 |
| P42 effect | Closes the last inline-key flag; aligns master config with the secret-templating pattern (phase22 lineage). |

### BCK-41-009 (P2, effort S — operator login session) — Dashboard visual-render verification (pixels, not just data)

| Field | Value |
|---|---|
| Description | W1/W2 dashboards are DATA-VALIDATED against live queries (agents 6-active widget read, panel queries return rows); the visual layer awaits an operator browser login (credentials operator-held). One honest discrepancy is already FLAGGED and tracked separately (BCK-41-010): event.code carries 0 hits while the EID signal lives in rule.groups. |
| Owner | Detection engineering / operator |
| Dependencies | Browser session against the dashboards endpoint. |
| Acceptance criteria | Each W1/W2 panel renders with live data; screenshot evidence archived; usability/accessibility notes appended to phase41-63/-64 chain. |
| Rollback | Delete saved objects (rollback IDs recorded phase40-62); text-table runbooks remain fallback. |
| Evidence links | phase41-61…64 |
| P42 effect | Converts "data-live" into "operationally rendered" for the visibility domain. |

### BCK-41-010 (P3, effort XS — owner ruling) — event.code ↔ rule.groups EID-mapping answer

| Field | Value |
|---|---|
| Description | Inside the FP-baseline dataset: `event.code` has ZERO hits while the sysmon EID signal lives in `rule.groups` (`sysmon_eid1`=576). Dashboards query one, detections emit the other; both counts zero in today's live indices (Windows clients idle since sample window). Owner question raised this phase and NOT papered over — needs a ruling on which field is canonical for EID display vs detection logic. Sibling note: agent-active widget showed 6 vs agent_control 7 (same zero-today caveat). |
| Owner | Detection + dashboard owner (owner query) |
| Dependencies | None. |
| Acceptance criteria | Written ruling (map event.code at ingest, or retarget dashboard queries to rule.groups); implemented or explicitly declined with rationale; widget 6-vs-7 explained in the same pass. |
| Rollback | Query/doc change only. |
| Evidence links | phase41-62/-71/-74; OW-41-02 |
| P42 effect | Aligns dashboard semantics with detection reality before client-facing dashboard use widens. |

---

## 4. Dispositioned / Closed This Phase (no longer backlog)

| Lineage | Disposition |
|---|---|
| R-FG field-growth containment (BCK-40-001 successor) | **ACHIEVED — CONTAINED-PENDING-FULL-CYCLE.** Source stats eliminated from eve.json on sensor mct-soc-scan; compact emitter chain LIVE end-to-end (suricatasc dump-counters → 16-field flat JSON → systemd timer 60s → agent localfile → indexed+searchable `data.event_type:stats_compact`); −425 mapped leaves steady-state; plateau decomposed 1706→1766 (+34 compact-by-design, +16 win trickle); limit UNCHANGED at 2000 per policy; flips tomorrow (BCK-41-002). phase41-10…18 |
| Dual-suricata defect (NEW-41) | **FOUND+FIXED.** Production PID (init-parented, `-i ens19`) coexisted with a misconfigured systemd-spawned duplicate polluting eve.json; unit MASKED; production restarted exact-args via setsid; single instance verified. phase41-15; AGENTS scripting note added |
| OW-40-07 release custody | **CLOSED byte-exact.** Published v1.3.0 asset located via GitHub REST API (no gh), downloaded, sha256 = exact match to published identity; on-box beside rebuilt-provenance variant; MANIFEST updated. phase41-75/-76 |
| Monitor maturity (OW-39-03 successor) | **MATURED WITH PROOF.** Overnight 14 cycles zero silent gaps INCLUDING one real fail-closed ERROR caught at the 04:15Z slot; watchdog implemented (self-masking bug found+fixed pre-install); delivered count climbed 40→46 on real OpenCanary flow. phase41-35/-39/-40/-43 |
| Packet import mechanics | **IMPORTED+REBUILT (test-only lane).** API creation solved (curated-body POST after trailing-newline root cause); hook registration pattern extended (workflows field must target self; backend caches → flush); hallucinated artifact functions replaced with real inventory; ALL-NODES-CLEAN executions + IRIS test-route HTTP 200. Routing itself DEFERRED → BCK-41-004. phase41-41…52 |
| XFO dedup (OW-40-08) | **CLOSED** for XFO — single header now, HSTS+nosniff intact; XCTO sibling split out as BCK-41-006. phase41-65/-66 |
| windows/mac .bak ownership sweep (OW-40-09) | **CLOSED CLEAN** — zero root-owned; remoted noise gone (~3 h 50 m silent since fix window). phase41-67/-68 |
| SecurityOnion resurrection risk (R-SO) | **VALIDATION PASS** — exited, restart=no, volumes intact, reactivation documented; retired-stopped state confirmed durable. phase41-80 |
| Restore safety (spot-check series) | **STREAK ×3** — spot-check #3 PASS (170521=170521 parity), third consecutive bounded restore across phases. phase41-57 |
| FP baseline (NEW-41) | **ESTABLISHED honestly** — universe 12 alerts/7d (8 canary-marked + 4 natural incl sids 2260001/2210038/2100366×2); ZERO false positives in natural population; qualitative-only regime until ≥50 natural alerts. phase41-69…74 |

---

## 5. Sequencing View for Phase 42

```
Morning Aug-27:
  BCK-41-002 field-flip adjudication on 08.27 index (script staged)

Owner batch — ONE session:
  BCK-41-001a (013 power) · BCK-41-001b (015 caffeinate)
  BCK-41-001c (sign DEC-40-01) ──► BCK-41-001d (approve target)

P0 decision:
  BCK-41-004 packet remediation path (recommend UI rebuild on native nodes)

Scheduled:
  BCK-41-003 ISM wave observe 2026-08-29T21:00Z (+Aug-30 checkpoint)

Phase-42 open:
  BCK-41-005 v1.3.1 cut execution (RELPLAN-41-01 checklist ready)

Anytime (XS quick-wins):
  BCK-41-006 XCTO dedup ⚡ · BCK-41-007 R-CHURN cron gating ⚡
  BCK-41-008 VT key value-blind verify ⚡ · BCK-41-009 dashboard render login
  BCK-41-010 EID mapping answer
```

## 6. Standing Rule

Unchanged from phase40-91 §6 as restated in prior registers: new findings enter with fresh
canonical IDs and a crosswalk row; reports cite IDs but never mint private variants.

<!-- END phase41-93 -->
