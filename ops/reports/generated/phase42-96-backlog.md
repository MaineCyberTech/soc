# Phase 42 Consolidated Backlog (P0–P3)

**Report ID:** phase42-96-backlog
**Phase:** 42
**Title:** BCK-42-001…012 — Consolidated Phase 43 Backlog: Owner-Batch Bundle EXPANDED TO EIGHT Items Grouped By Agenda Slot (013 Power · 015 Caffeinate · DEC-40-01 Signature · Target Approval · Host-Conf 640 chmod · GitHub Token For v1.3.1 Page · Dashboard v2-Swap Signoff · Disk-Threshold Policy), Field Adjudication Tomorrow AM, Monitor Full-Day Flip 01:45Z, ISM Wave Watch Aug-29, Packet Remediation Execution (B>A>C), Plus Self-Extinguishing Legacy-Burst Watch And Quick-Wins ⚡
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:55:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-96-backlog.md`

---

## 1. Purpose and Method

This register merges every still-open item from the Phase 42 arcs with the audit findings
surfaced this phase (disk-threshold discovery, legacy-index rejection bursts, packet
capability finality). Canonical IDs here are `BCK-42-0xx`; every item crosswalks to its
OW/BCK lineage and same-day phase42 evidence. Items closed this phase are dispositioned in
§5, not silently dropped. Quick-wins flagged ⚡ where automation could pre-stage more before
the human step lands.

### Priority distribution

| Priority | Count | Canonical IDs |
|----------|-------|---------------|
| P0 | 5 | BCK-42-001 … 005 |
| P1 | 3 | BCK-42-006 … 008 |
| P2 | 3 | BCK-42-009 … 011 |
| P3 | 1 | BCK-42-012 |

### Owner-batch note (ONE session, now EIGHT items)

The original four-item bundle (aging since P38) is joined by four new small items minted
this phase — all four are minutes-scale once the owner is present (a chmod, a token paste,
a signoff, a policy ruling). Batch all eight; dispatching them one-by-one is how the
original four aged through P38→P42.

---

## 2. Owner-Session Bundle — BCK-42-001, grouped by agenda slot

| Slot | Item | Ask | Pre-staged by automation |
|---|---|---|---|
| T+0 | **BCK-42-001a** | Power on agent 013 SAMSUNG (>26 h dark at last pull 08:49Z), join network | Server side verified good; sustained-proof + cert templates ready (phase42-34…36) |
| T+10 | **BCK-42-001b** | Agent 015 Julians-Air caffeinate plist install via screenshare | Package verbatim ready (`caffeinate -dis -t 28800`, launchd plist; phase42-37…39) |
| T+20 | **BCK-42-001c** | Sign DEC-40-01 RTO/RPO adoption sheet | Sheet populated, recommendations pre-filled ADOPT (phase42-40) |
| T+35 | **BCK-42-001d** | Approve/name restore-rehearsal target | Candidate matrix + memo staged; recommendation unchanged (phase42-41) |
| T+45 | **BCK-42-001e** | Host-side `sudo chmod 640` on `wazuh_manager.conf` (still 644 root:root; blocked-no-sudo for agents) | Exact command documented (phase42-53 §3); container twin already 640 root:root value-blind |
| T+47 | **BCK-42-001f** | Provide GitHub token scope `repo` (contents) for v1.3.1 release-page + asset upload | Tag already PUSHED to origin; three-call curl runbook ready verbatim (phase42-79 §6); verify published digest equals on-box sha256 afterwards |
| T+50 | **BCK-42-001g** | Sign off dashboard v2 swap (EID `.keyword` objects replace originals) | v2 artifact IMPORTED 4/4 with live-count parity proven; originals retained; swap = one signoff away (phase42-69 §7) |
| T+55 | **BCK-42-001h** | Disk-thresholds policy ruling: enable allocation thresholds vs formally accept ADVISORY-ONLY posture | Both options drafted with math (wave arrives long before fill; phase42-61 §5); watermarks stay DO-NOT-TOUCH either way |

---

## 3. Master Matrix (required columns)

| ID | Pri | Title | Owner | Deps | Acceptance | Rollback | Evidence | P43 effect |
|---|---|---|---|---|---|---|---|---|
| BCK-42-001 (a–h) | P0 | Owner batch — eight items, ONE session (§2) | MCT SOC + device owners | None technical; c+d pair naturally | Per-slot evidence filed (fleet poll, signed sheet, token-scoped upload digest match, swap receipt, ruling recorded) | Per-slot reversals documented in linked reports; unsigned/rulings simply persist as waiting | phase42-33…42, -53, -69, -79; this register §2 | Fleet numerator recovery; objectives bind; rehearsal unblocks; release page closes; visibility domain completes; capacity risk formally dispositioned |
| BCK-42-002 | P0 | Field-cycle adjudication C1–C5 on 08.27 index (dated TOMORROW AM 2026-08-27) | Platform/detection eng | Calendar (birth ~00:00:02Z); script staged | Five-condition band: C1 limit=2000 · C2 policy attached · C3 full-stats=0 · C4 rejections=0 on newborn · C5 required data flowing → ADDENDUM flips VERIFIED | None for adjudication itself; failure branch uses documented un-wire sequence | phase42-03…09/-13/-14; adjudicator `ops/scripts/p42-field-cycle-adjudicate.sh`; `_simulate_index` pre-proof (limit2000+ISM resolve) phase42-60 | Converts containment into closure of the quarter's dominant capacity arc |
| BCK-42-003 | P0 | Delivery-monitor strict-24h flip at 2026-08-27T01:45Z + logrotate install ⚡flip-check scriptable | SOAR ops | Calendar (cron armed ~01:45Z Aug-26) | 96/96 observable slots zero silent → drop WINDOW NOTE, upgrade MON-CERT to unqualified PASS; logrotate snippet installed before month-scale growth | Any missing slot defers flip with a new contiguous window required | phase42-55…59 (MON-CERT-42-01 §3 binding flip condition; owner items O1/O2) | Monitoring claim becomes unconditional; removes last caveat from routing line |
| BCK-42-004 | P0 | Observe first policy-driven ISM deletion wave (dated 2026-08-29T21:00:44Z ±ISM interval) + relief measurement day-1..7 | Infrastructure owner | Calendar checkpoint Aug-30 morning | F1–F5 per RET-CERT-42-02 (08.15 disappears in tolerance; 08.16 confirms cadence 08-30T00:00:01Z; relief ±20% of 13.6 GB projection; cluster green throughout; zero prohibition violations) | N/A observation task; non-firing → ISM diagnostics escalation, NEVER force-delete | phase42-60…67; baseline `p41-ism-baseline.json` | Flips retention certificate VERIFIED; converts forecast into realized disk relief |
| BCK-42-005 | P0 | Packet-lane remediation CHOICE + execution: rank B (platform upgrade) > A (UI-session rebuild falsification test) > C (external Wazuh-side filter) | SOAR ops + owner ratifies | Owner decision first; either path re-runs withheld proofs | Path ratified in register; remediated chain passes ALL-NODES-CLEAN + dedup/counter/malformed/datastore-downstream proofs with synthetic-marked events only; SID shortlist activates | Delete/re-disable workflow object; Class-A lane untouched; zero production contamination | phase42-15…32 (CERT-42-01 FAIL-TO-CERTIFY; five-test matrix; ranking B>A>C) | Last detection-plane gap closes honestly or stays precisely scoped-out |
| BCK-42-006 | P1 | Legacy-index rejection-burst watch — SELF-EXTINGUISHES at 2026-08-27T00:00Z rollover | Platform/detection eng | None (<16 h window) | Hourly reads per phase42-14 §1 cadence; alert ONLY on worker-container rejections, dashboards/indexer health flip, or mutation attempt; zero otherwise | No action unless trigger fires (no-config-change rule binds) | phase42-01/-08/-12/-14 watch-log (2746 in bursts 07:02/07:45, zero since 07:45:42Z; worker lifetime 0) | Bounded interim risk retires itself structurally at birth |
| BCK-42-007 | P1 | VirusTotal rotation dry-run ROT-VT-01 once (accepted-risk posture: plaintext-in-conf platform-blocked this Wazuh version; perms+clean-git mitigations live) | MCT SOC | Owner availability; paired backups both nodes | Dry-run executed without exposing any value; MTTR measured; runbook validated or corrected | Revert to current state; no key material ever printed | phase42-51…54 (QW-SEC-42-01 residual R2/R3; ROT-VT-01 skeleton) | Rotation rehearsed before it is ever needed |
| BCK-42-008 | P1 | Land Phase-42 changeset: single logical commit + push-if-approved per REPO-42-04 PLAN record | ops-reports-owner + orchestrator approval | Triple CI re-run immediately pre-commit; catalog refresh or explicit delta acceptance | Checklist §7 of REPO-42-04 fully green; commit message verbatim; expected-untracked superset holds | Git-native revert paths per changeset | phase42-99-repo (PLAN record); git status live | Corpus of record reaches origin; v1.3.2 register can then grow cleanly |
| BCK-42-009 | P2 | FP population triggers watch (≥50 natural alerts OR repeat-offender rule fires) | Detection eng | Population growth only | Statistical FP-rate claims remain suppressed until threshold; sample extraction repeat per phase41-69 method | N/A measurement discipline | phase42-74/-75/-76; `p42-fp-sampling/universe-rolling7d-20260826.json` | Tuning decisions become statistically grounded |
| BCK-42-010 | P2 | Restore-rehearsal staging once target approved (plan executes BCK-42-001c+d outcomes) | Infra + SOC lead | 001c signature + 001d target landing | Stage0 checklist opens on named target; rehearsal scheduled; go/no-go leaves NO-GO only via measured drill | Rehearsal environment disposable | phase42-40/-41; plan lineage v3 | DR AMBER cell finally has its exit path armed |
| BCK-42-011 | P2 | Dashboard visual-render session (pixels, not just queries) using ready browser-session kit | Operator + detection eng | Browser credentials operator-held | Each panel renders with live data; screenshots archived; usability notes appended | Delete saved objects (rollback IDs recorded); text-table runbooks fallback | phase42-68/-70/-71/-73; session kit ready | Visibility domain reaches full GREEN alongside 001g swap |
| BCK-42-012 | P3 | Physical duplicate-path retirement in catalogs (alias rows APPLIED non-destructively; file moves approval-gated) | Governance + operator | Operator sign-off | Duplicate rows retired without breaking backlink integrity | Delete JSON alias rows; files never moved | phase40-79/-80 lineage; source-map-aliases.json | Catalog hygiene fully converged |

---

## 4. Crosswalk — Canonical → Lineage

| Canonical | Lineage | Origin plane |
|-----------|---------|--------------|
| BCK-42-001a–d | OW-40-01/-02/-05/-06 carryover (all inputs READY multiple phases) | Endpoints + DR/business |
| BCK-42-001e | QW-SEC-42-01 residual R1 (host 644; blocked-no-sudo) | Security hygiene |
| BCK-42-001f | REL-EXE-42-01 blocker (BLOCKED-AWAITING-TOKEN) | Release |
| BCK-42-001g | EID arc remediation option (a) chosen, safe-path applied | Visibility |
| BCK-42-001h | NEW this phase — disk-threshold discovery (phase42-61 §5/-65/-66) | Capacity |
| BCK-42-002 | G41-14 successor; five conditions re-staged phase42-03…09 | Detection pipeline / capacity |
| BCK-42-003 | MON-CERT-42-01 §3 binding flip condition + owner items O1/O2 | SOAR monitoring |
| BCK-42-004 | OW-40-03 carryover (exact ETA recomputed live) | Capacity / retention |
| BCK-42-005 | ROUT-PKT lineage; CERT-42-01 FAIL-TO-CERTIFY + ranking B>A>C | SOAR / detection |
| BCK-42-006 | NEW this phase — legacy-burst mechanics (phase42-01/-08/-12/-14) | Ingest / capacity |
| BCK-42-007 | QW-SEC-42-01 residuals R2/R3 (ROT-VT-01) | Secret hygiene |
| BCK-42-008 | OW-40-11 successor (commit/push gate) | Governance |
| BCK-42-009 | FP program continuation | Detection quality |
| BCK-42-010 | OW-40-06 execution stage | DR |
| BCK-42-011 | OW-41-03 carryover (kit now ready) | Visibility |
| BCK-42-012 | OW-40-12 carryover | Governance |

---

## 5. Dispositioned / Closed This Phase (no longer backlog)

| Lineage | Disposition |
|---|---|
| R-CHURN frontend restart churn (BCK-41-007 successor) | **ELIMINATED + CERTIFIED.** Historical 1,381 restarts/~15 days (~92/day) quantified; FRONTEND_REPAIRED gate shipped — restart only on actual reconnect; healthy no-op ×3 proven; forced-failure (backend detach) recovered WITHOUT touching frontend (zero collateral restarts); CHURN-CERT-42-01 PASS; projected forward churn 0/day with cron unchanged. phase42-43…48 |
| XCTO/nosniff dedup (OW-41-01) | **CLOSED** — exactly one X-Content-Type-Options header live through :3443, HSTS intact, HTTP 200 verified; ownership split documented. phase42-49/-50/-54 |
| VT key exposure (BCK-41-008 successor) | **HARDENED container-side, value-blind.** Container conf now 640 root:root (was world-readable 644!); value never read; git/history proven clean; native secret-ref unsupported this Wazuh version → accepted-risk path chosen with rotation runbook skeleton (ROT-VT-01); host-side 640 = owner item 001e. phase42-51…54 |
| v1.3.1 cut (BCK-41-005 successor) | **EXECUTED** — annotated tag created from verified tree and PUSHED TO ORIGIN (remote-visible ls-remote exit 0, object identical); asset built sha256 `4e6c3712…` (15,558,573 bytes, 5,263 entries); MANIFEST written; release-page upload honestly BLOCKED-AWAITING-TOKEN with exact curl runbook → owner 001f. phase42-77…80 |
| Monitor maturity (MON-CERT-42-01) | **PASS-WITH-WINDOW-NOTE** — second REAL fail-closed ERROR caught (07:45Z, correlated backend restart) making failure detection TWICE-proven by genuine faults; Δ≈900 s cadence audited; watchdog LIVE-TESTED in sandbox (stale→ALERT, repeat-guard holds); strict 24 h certificate completes 2026-08-27T01:45Z → BCK-42-003. phase42-55…59 |
| EID discrepancy (BCK-41-010 successor) | **ROOT-CAUSED + SAFE FIX SHIPPED.** Signal actually lives in `data.win.system.eventID` (1,955,152 archived docs); event.code NEVER populated anywhere; original W2 panel aggregated a text field (fielddata-broken); v2 `.keyword` artifact IMPORTED 4/4 with live-count parity (EID7 44,095/EID5 981/EID1 842 vs control 46,226); originals retained; swap = owner signoff 001g. phase42-69/-73 |
| Restore streak (DR component-grade evidence) | **STREAK ×4** — fourth consecutive bounded spot-check PASS (170,521=170,521 parity, temp cleaned). phase42-64 |
| Field-cycle staging (G42-02) | **STAGED-READY** — adjudicator script executable, syntax-clean; `_index_template/_simulate_index` PRE-PROVES template resolution (total_fields.limit 2000 + ISM policy resolve through order-320 template); birth window tonight 00:00:02Z. phase42-03/-60 |
| Packet capability question (BCK-41-004 successor) | **FINALIZED as platform truth** — five-test matrix across two phases proves Tools-app cannot consume references on this build (execute_python no-injection; $refs literal; if_else runtime-missing; repeat_back_to_me ignores input; only HTTP interpolates); lane correctly DISABLED/TEST-ONLY; remediation ranking B>A>C → decision 005. Zero production contamination maintained. phase42-15…32 |
| Disk-capacity framing (audit finding) | **DISCOVERED + DISCLOSED** — `cluster.routing.allocation.disk.threshold_enabled=false` set statically in indexer configs: the 85% watermark is ADVISORY-ONLY, reframing prior capacity risk as known-limitation; wave-before-fill math shown; owner decision queued 001h. phase42-61/-65/-66 |
| Legacy-index rejection resumption (interim risk) | **BOUNDED + WATCHED** — 2746 rejections in two/three bursts (07:02/07:45) from syscollector/vuln-detector against the immutable 08.26 mapping; zero since 07:45:42Z; zero on worker; counter counts objects+leaves+multi-fields (~1978 ≈ cap 2000); self-extinguishes at midnight rollover; hourly-watch plan ACTIVE → 006. phase42-01/-08/-11/-12/-14 |

---

## 6. Sequencing View for Phase 43

```
Tonight Aug-27 00:00:02Z:
  08.27 birth → BCK-42-002 adjudication (script staged; addendum template ready)
  legacy-burst watch self-extinguishes at rollover (006)

Morning Aug-27:
  01:45Z  BCK-42-003 monitor strict-24h flip verification (+ logrotate)
  AM      adjudicator run + plateau sampling t+1h/t+6h/t+24h schedule

Aug-29T21:00:44Z:
  BCK-42-004 ISM wave observation (hourly cadence; F1–F5 flips RET-CERT-42-02)

Owner batch — ONE session, EIGHT items:
  001a 013 power · 001b 015 caffeinate · 001c sign DEC-40-01 · 001d approve target
  001e host 640 chmod ⚡ · 001f GitHub token (runbook ready) ⚡
  001g dashboard v2-swap signoff ⚡ · 001h disk-threshold policy ruling

P0 decision + execution:
  005 packet remediation B (recommend) > A opportunistic falsification > C fallback;
      re-run withheld proofs before any gate claim revives

Governance:
  008 land Phase-42 changeset per REPO-42-04 after fresh triple-CI (approval-gated)

Anytime (XS/S):
  007 ROT-VT-01 dry-run · 009 FP triggers watch · 010 rehearsal staging post-approval
  011 dashboard render session (kit ready) · 012 duplicate-path retirement
```

⚡ marks where automation has ALREADY pre-staged the human step to minutes: 001e (exact
command), 001f (three-call runbook + digest-verify step), 001g (import proven, receipts
filed), 003 (flip-check reduces to one log-window assertion). Additional pre-staging
possible: catalog refresh for the phase42 corpus ahead of the 008 commit window.

## 7. Standing Rule

Unchanged from prior registers: new findings enter with fresh canonical IDs and a crosswalk
row; reports cite IDs but never mint private variants.

<!-- END phase42-96 -->
