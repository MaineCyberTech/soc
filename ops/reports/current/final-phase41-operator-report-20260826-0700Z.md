# Final Phase 41 Operator Report

**Report ID:** final-phase41-operator-report
**Phase:** 41
**Title:** Phase 41 Operator Closeout — Field Growth CONTAINED At Source, Release Custody CLOSED Byte-Exact, Monitor MATURED-With-Proof, Packet Lane HONESTLY-DEFERRED On Platform Evidence; Verdict PASS-WITH-PRECISE-BLOCKERS; Owner Items Correctly Gated Not Failed
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T07:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/current/final-phase41-operator-report-20260826-0700Z.md`

| Field | Value |
|-------|-------|
| **Report ID** | final-phase41-operator-report |
| **Generated** | 2026-08-26T07:00Z |
| **Classification** | Internal / Operational summary |
| **Owner** | MCT SOC |
| **Verdict** | **PASS-WITH-PRECISE-BLOCKERS** |
| **Supersession** | Supersedes `final-phase40-operator-report-20260826-0300Z.md`; superseded only by a newer phase final. Historical reports are never rewritten in place. |
| **Companion reports** | phase41-93 (backlog) · 94 (billing) · 95 (scorecard) · 96 (monthly) · 97 (deployability) · 98 (release assurance) · 99 (repo plan) |

---

## 1. Executive Verdict

**PASS-WITH-PRECISE-BLOCKERS.** Phase 41 contained the engagement's top technical risk at its
source, closed release custody byte-exact, matured delivery monitoring to proof-grade, and —
when the packet lane hit a genuine platform wall — deferred it with controlled negative evidence
instead of shipping an uncertifiable gate. Every still-open owner item is open **correctly**:
gated, packaged, and ready; none is a failure of evidence.

- **FIELD-GROWTH CONTAINMENT ACHIEVED.** Full-stats events eliminated from eve.json ON THE SENSOR
  (mct-soc-scan); compact emitter chain LIVE end-to-end (suricatasc dump-counters → 16-field flat
  JSON → systemd timer 60s → agent localfile → indexed+searchable `data.event_type:stats_compact`);
  −425 mapped leaves steady-state; plateau honestly decomposed (1706→1766 raw: +34
  compact-lane-by-design, +16 win trickle); **limit UNCHANGED at 2000 per policy** — demand was
  shrunk, not supply raised. Certification CONTAINED-PENDING-FULL-CYCLE flips tomorrow on the
  08.27 index; addendum pre-drafted.
- **DUAL-SURICATA DEFECT FOUND+FIXED en route.** The production PID (init-parented, `-i ens19`)
  coexisted with a misconfigured systemd-spawned duplicate polluting eve.json; unit MASKED;
  production restarted exact-args via setsid; single instance verified.
- **RELEASE CUSTODY CLOSED BYTE-EXACT.** The published v1.3.0 asset was located via GitHub REST
  API (no `gh`), downloaded, and hash-matched exactly to the published identity; on-box beside the
  retained rebuilt-provenance variant; MANIFEST updated. A multi-phase PARTIAL became CLOSED.
- **DELIVERY MONITOR MATURED-WITH-PROOF.** Overnight: 14 cycles, zero silent gaps, INCLUDING one
  real fail-closed ERROR caught at the 04:15Z slot — failure detection proven by an actual event.
  Watchdog implemented (its own self-masking bug caught before install); delivered count climbed
  40→46 on genuine honeypot flow.
- **PACKET WORKFLOW IMPORTED+REBUILT — THEN HONESTLY DEFERRED.** Test-only lane reached
  ALL-NODES-CLEAN executions and IRIS test-route HTTP 200 after solving API creation (curated-body
  POST; trailing-newline root cause), extending hook registration (`workflows` must target self;
  backend caches → flush), and replacing hallucinated artifact functions with the real inventory.
  Then probe workflows proved `execute_python` on this build exposes NO incoming-data variable
  (five keys UNDEF) and passes `$param` refs as literals — normalize/validate/isolation/dedup
  CANNOT be certified here. Routing = DEFERRED with two remediation paths. Zero production
  contamination; all synthetic-marked.

Also closed this phase: XFO dedup (single header, HSTS+nosniff intact); windows/mac `.bak`
ownership sweep verified clean (remoted noise gone ~3 h 50 m silent); SecurityOnion validation
PASS (exited, restart=no, volumes intact); restore spot-check #3 PASS (170521=170521 parity —
streak ×3); FP baseline established honestly (12-alert universe: 8 canary + 4 natural, ZERO
natural FPs, qualitative-only until ≥50); dashboards data-validated live with one discrepancy
FLAGGED not papered over (event.code 0 hits vs rule.groups sysmon_eid1 signal — owner query
raised); AGENTS.md updated under CHG-41-AGENTS-01 with three new codified hazards; triple CI
GREEN; catalogs reconciled to 392 unique rows / 0 hash mismatches across all 93 phase41 entries.

Nothing regressed operationally: cluster GREEN (3 nodes, 282 shards); fleet 7 active-class of 10
(both offline halves fully packaged for ONE owner session); disk 84% with Aug-29 relief wave
staged; snapshots fs 42 / s3 87 fresh tonight.

## 2. Corrections Table (claims retired this phase)

| # | Prior belief/trap | Status | Corrected understanding | Evidence |
|---|---|---|---|---|
| C-41-1 | Post-cutover rejection hits appeared to exist (false alarm on the field-fix verdict) | RETIRED | Minute-bucketed histograms dissolved it: ALL rejections sit pre-cutover; last ever ≤00:00:01.431Z. Raw "rejection present" greps without time-bucketing would have re-opened a closed win | phase41-01 §4; phase41-18 row 1 |
| C-41-2 | Field counts quoted interchangeably ("441 vs 877", "1706 vs 1766") as if one number existed | CORRECTED | Unique-mapped-leaf vs raw-leaf bases are DIFFERENT measures; guardrail reads raw basis. Basis labels are now mandatory in every field report, and the plateau decomposes cleanly: +34 compact-lane-by-design, +16 win trickle | phase41-06 §3; phase41-17 §4 |
| C-41-3 | eve.json pollution attributed to config/timing mysteries on the production sensor | RETIRED | TWO Suricata processes were running: init-parented production (`-i ens19`) plus a systemd-spawned misconfigured duplicate from P40-era restarts. Unit MASKED; production restarted exact-args via setsid. Lesson codified: systemctl state ≠ runtime state — verify with pgrep | phase41-15 G41-02/03; AGENTS.md note |
| C-41-4 | `execute_python` assumed able to receive workflow input variables | PROBE-RETIRED | On this Shuffle build: `data_in`/`input`/`execution_input`/`execution_data`/`data` ALL UNDEF in globals; `$param` refs pass as literals. Multiple cycles were spent building gates on an interface that never existed before the five-line probe ran | phase41-52 §2; R-PKT-PLATFORM; AGENTS.md note |
| C-41-5 | Alert universe read as ~11 natural + 1 canary | CORRECTED | Marker-based separation shows 8 canary-marked synthetic + 4 natural of the 12-alert/7d population (sids 2260001 / 2210038 / 2100366×2) — the FP finding is honest precisely because the split is | phase41-70/-71/-74 |

## 3. What Changed Operationally (timestamped, UTC)

1. **~03:38–03:56Z** — sensor containment arc applied (G41-01…04): `stats:` removed from
   eve.json types on mct-soc-scan; suricata.service MASKED after the dual-process discovery;
   production restarted exact-args via setsid (ruleset loaded 03:55:58.844937Z); unix command
   socket enabled. Last full-stats document EVER indexed: **03:53:31.766Z**.
2. **~04:05–04:20Z** — compact lane stood up (G41-05…07): `/usr/local/bin/suricata-compact-stats.py`
   installed; systemd timer pair active at 60s; agent localfile added + agent 016 restarted.
3. **~03:50–04:49Z** — overnight monitor soak adjudicated en route: 14 cycles zero silent gaps,
   real fail-closed ERROR caught at the 04:15Z slot; fresh 05:14Z run reconciles cumulative
   delivered=46 failed=31 aborted=3 other=4 (+6 overnight, real OpenCanary flow).
4. **04:39:08Z** — v1.3.0 published-original retrieved via unauthenticated GitHub REST API → direct
   download → sha256 byte-exact vs published identity; stored beside rebuilt-provenance variant;
   MANIFEST primary row written same session (DEC-CUSTODY-41-01, CLOSED-VERIFIED).
5. **04:49→06:24Z** — compact lane proven indexed+searchable: 43 docs @04:49Z → 129 @06:24Z,
   live growth observed; all 16 whitelisted counters present per doc.
6. **~04:30–04:55Z** — XFO dedup applied at the proxy (single header now; HSTS+nosniff intact);
   windows/mac `.bak` ownership sweep verified clean — remoted noise gone (~3 h 50 m silent).
7. **05:10Z** — FIELD-RISK CERTIFICATION: CONTAINED-PENDING-FULL-CYCLE with pre-drafted flip
   addendum and explicit five-condition band (phase41-18).
8. **05:33Z / 05:48Z** — MON-CERT-41-01 PARTIAL-PASS issued (full-day certificate completes
   tomorrow morning); FP-BASE-41-01 established (zero natural FPs; qualitative regime declared).
9. **05:57–05:58Z** — packet routing DEFERRED with platform-level probe evidence and two staged
   remediation paths (ROUT-PKT-41); RELPLAN-41-01 staged for the v1.3.1 cut.
10. **06:35Z** — canonical refresh CS-41-01 (`current-state-20260826-postp41.md`) + open-work
    ledger OPENWORK-41-01 (ten closures moved to resolved log).
11. **~06:37Z** — CHG-41-AGENTS-01 applied with full compliance chain (backup sha256 banked →
    dry-run → apply → post-validate → agents-ci GREEN), codifying three new hazards.
12. **~06:30–06:57Z** — drift sweep MANAGED (14 items dispositioned): NEW findings include
    R-CHURN (shuffle-repair-network restarts frontend ~96×/day unconditionally; docker events
    kill/start observed 06:30:02–03Z), XCTO residue (nosniff still duplicated app+proxy),
    VT-key value-blind flag in master ossec.conf.
13. **07:00Z** — closeout corpus landed (93–99 + this final); triple CI re-run embedded
    phase41-98 §6.

## 4. Risks Register — Top 5

| Rank | Risk | Exposure | Mitigation trajectory |
|------|------|----------|----------------------|
| R1 | **Field-cycle adjudication tomorrow** — containment is CONTAINED-PENDING until the 08.27 index passes the five-condition band; a surprise late field family would keep it pending | One more day of pending on the quarter's dominant capacity risk; rejection risk itself remains structurally retired | Five conditions pre-committed in writing (phase41-18 §4/§8); attribution rerun method set documented; un-wire rollback armed (phase41-15 §7) |
| R2 | **Packet platform defect (R-PKT-PLATFORM)** — gating semantics uncertifiable on this build | Lane stays disabled/test-only; detection coverage excludes packet-workflow routing until remediation | Two concrete paths staged (UI rebuild on native ref-consuming nodes RECOMMENDED, or platform upgrade); blocked proofs enumerated; zero production contamination maintained |
| R3 | **Owner-batch latency** — 013 power, 015 caffeinate, DEC-40-01 signature, target approval all wait on ONE human session | Fleet stuck 7/10; objectives stay draft; rehearsal stays NO-GO | Batch explicitly packaged as one session (BCK-41-001); all inputs READY so the session is pure execution |
| R4 | **R-CHURN restart churn** — shuffle-repair-network.sh restarts frontend ~96×/day unconditionally | Masks real availability signals; adds noise; wastes cycles | Quick-win fix staged (gate restart on detected DNS failure); forced-failure test defined to prove the gate both ways |
| R5 | **XCTO residue + VT-key flag** — nosniff still duplicated app+proxy; master ossec.conf carries inline virustotal key of unknown reality (value-blind) | Cosmetic-to-compat header noise; secret-hygiene inconsistency if key is real | XS/S quick-wins queued with acceptance criteria (BCK-41-006/-008); value never printed; paired-backup rule binds the config window |

## 5. Domain One-Liners

- **Deployability (DEPLOY-41-06):** PARTIAL maintained precisely — B4 custody RESOLVED this phase
  (byte-exact published-original on-box); remaining blockers 3, all owner-input-gated; credited:
  spot-check streak ×3, plan v3, published-original custody; flip-path ordered with owners.
- **Billing (BILL-41-04):** RECOMMENDED for Aug-2026 with disclosures — capture VERIFIED,
  detection VERIFIED, Class-A CERTIFIED-AUTOMATED sustained (delivered=46↑, monitor matured),
  packet lane deferred-disclosed with platform evidence, evidence-quality STRONG.
- **Scorecard (SCORE-41-05):** Ops GREEN · Detection GREEN · Security GREEN (three AMBER-lite
  cells) · Governance GREEN · Visibility GREEN-pending-visual · DR AMBER · SOAR GREEN; M-series
  gained two new metrics (release custody CLOSED ▲▲, catalog parity 392 rows ▲▲); client-safe
  section sanitized and shareable.

## 6. Phase 42 Roadmap (prioritized)

**P0 — tomorrow morning (Aug-27)**
1. Run the field-flip adjudication on the `wazuh-archives-4.x-2026.08.27` index against the
   five pre-committed conditions (script staged; addendum template ready in phase41-18 §8);
   flip CONTAINED-PENDING→VERIFIED or document the exact failing condition.
2. Wave-watch setup for Aug-29: confirm ISM policy attachment on the 08.27/08.28 indices at each
   birth, stage the observation checkpoint for Aug-30 morning.

**P0 — owner session (ONE sitting, four items)**
3. Power on agent 013 · caffeinate/power-settings on agent 015 · sign DEC-40-01 RTO/RPO sheet ·
   approve the restore-rehearsal target. All inputs READY; execution only.

**P0 — decision**
4. Packet remediation path: **recommend UI rebuild on native reference-consuming nodes**
   (`filter_list` / `if_else_routing` / `set_datastore_value`) — cheaper than a platform upgrade,
   uses only primitives already proven by Class-A precedent; upgrade remains the fallback path.
5. Then re-run the blocked proofs (dedup, counter, malformed, datastore/downstream failure)
   before any gate claim revives; lane stays disabled/test-only until then.

**P1**
6. v1.3.1 cut execution per RELPLAN-41-01 (checklist pre-drafted; freeze → docs sweep → tag →
   publish → API hash verify → on-box custody repeat → MANIFEST → closeout).
7. R-CHURN cron fix: gate shuffle-repair-network frontend restart on detected DNS failure;
   forced-failure test once, steady-state zero restarts after.
8. XCTO cleanup (single nosniff header; minutes) and VT-key value-blind verification + migration
   to creds-reference at the next config window (paired backups both nodes).
9. Dashboard visual-render login session (pixels, not just queries); fold EID-mapping owner
   answer into the same pass if returned.

**P2**
10. FP sampling continuation on population triggers (≥50 natural alerts or repeat-offender rule);
    rehearsal staging once target approved (plan v3 executes B1+B2 outcomes).

## 7. Attestation

No secrets appear in this report or its companions; credentials are referenced exclusively by file
location, and one unknown key was handled strictly value-blind (never printed). All quantitative
statements trace to command outputs captured in same-day phase reports (live API counts, guardrail
and monitor logs, execution/IRIS identifiers, probe transcripts, snapshot listings, triple-CI runs
embedded in phase41-98 §6); carried-forward proofs are labeled as such. Commit/push remains
APPROVAL-GATED per phase41-99: tree holds the classified changeset with expected-untracked sets
enumerated, redaction sweep counts ZERO, single logical commit message provided verbatim therein
awaiting orchestrator execution.

*— End of Phase 41.*
