# Phase 42 Monthly Operations Report

**Report ID:** phase42-99-monthly
**Phase:** 42
**Title:** MONTHLY-42-10 — August Cycle Closer: Endpoint, Packet (Five-Test Capability Matrix Finality), IRIS (delivered=46 Era Continues, Dual Real-Fault Proof), Alert Volumes (24.9K Today), Backup (Fresh Counts Re-Verified), Retention (Exact Wave ETA + Streak ×4), Capacity (+Threshold Disclosure), Temp, Dashboard (v2 Fix Shipped Pending Swap), Governance Cycles; Blocker Review; Billing Cross-Ref; Retrospective
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:55:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-99-monthly.md`

---

## 1. Cycle Frame

Closes the August operating cycle alongside BILL-42-05 (phase42-97), SCORE-42-06
(phase42-98), the BCK-42 register (phase42-96), DEPLOY-42-07 (phase42-100), and REL-42-07
(phase42-101). Facts below are live-verified today per the cited phase42 evidence chain;
several figures re-pulled live during this closeout session and are marked as such.

## 2. Endpoint Cycle

| Agent | State | Action this cycle |
|---|---|---|
| Fleet overall | **7 active-class of 10 registered** | stable set; both offline halves fully packaged in the eight-item owner batch |
| 013 (SAMSUNG) | Offline — **>26 h dark** at last pull (08:49Z) | sustained-proof + final-cert chains complete (phase42-34…36); power-on is batch slot T+0 |
| 015 (Julians-Air) | Offline (device-side flap) | power remediation + sustained-proof complete (phase42-37…39); caffeinate plist slot T+10 |

Sensor endpoint note: production Suricata remains a SINGLE verified instance post-mask
(exact-args setsid invocation); sensor healthy throughout the phase's stress events.

## 3. Packet & Workflow Cycle — the probe-matrix story

The packet lane's capability question was SETTLED this cycle by completing a **five-test
matrix across two phases**, each test a controlled probe against the test-only workflow:

| # | Probe | Result |
|---|---|---|
| T1 | `execute_python` input-injection | NO incoming-data variable exists on this build (all candidate keys UNDEF) |
| T2 | `$param` reference passing | refs arrive as LITERALS — no interpolation |
| T3 | `if_else_routing` native gate | runtime-MISSING from the Tools app inventory |
| T4 | `repeat_back_to_me` echo node | ignores its input ENTIRELY — even with full-metadata parameter objects cloned from the working Class-A HTTP action |
| T5 | HTTP app `${body:*}` interpolation | WORKS — the sole reference consumer (IRIS delivery 200 ×12) |

Conclusion of record: **no native reference-consuming gate primitive is operational in
Tools on this build** → normalize/validate/isolation/dedup semantics cannot be certified
here → lane correctly stays DISABLED/TEST-ONLY with exact blockers named and remediation
ranked **B (platform upgrade) > A (UI-session rebuild falsification test) > C (external
Wazuh-side filter)**. Zero production contamination maintained all cycle (synthetic-marked
events only). Estate remains three workflows with exports hashed (`p42-workflow-export` +
SHA256SUMS). Evidence: phase42-15…32.

## 4. IRIS Cycle

Delivery SUSTAINED in the delivered=46 era (fresh monitor runs re-read this cycle:
`delivered=46 failed=31 aborted=3 other=4`; failed family still frozen at its historical
silent-degradation era total, last failure 2026-08-10). The monitoring story matured again:

- **Second REAL fail-closed ERROR caught @07:45Z** during a genuine backend restart window —
  failure detection now proven TWICE by actual faults, not drills; green SUMMARY resumed in
  the immediately following slot with zero operator action.
- Cadence audit held Δ≈900 s across every observable slot since activation.
- Watchdog LIVE-TESTED in sandbox: stale-detection fired ALERT correctly, isolation and
  ≤1/h repeat-guard verified, clean-clear on recovery.
- MON-CERT-42-01 = PASS-WITH-WINDOW-NOTE; strict 24 h-contiguous certificate completes
  **2026-08-27T01:45Z** (binding flip condition stated in phase42-59 §3).

## 5. Alert Volumes

| Measure | Value | Note |
|---|---|---|
| Alerts today (`wazuh-alerts-4.x-2026.08.26`) | **24,926 docs** | live `_count` at closeout |
| Top groups today | ubiquiti 13,259 · mctportal 5,670 · vulnerability-detector 2,708 · audit 1,641 · audit_anom 1,631 · wireless 1,450 · windows 937 · wan 870 | live aggs this cycle |
| Archives lane | leaner post-containment (compact-stats health telemetry); legacy-index rejection bursts (2746) hit ONLY the doomed 08.26 index — zero on worker, zero since 07:45:42Z | phase42-01/-08/-14 |

FP program: population watch continues under the qualitative-only regime until ≥50 natural
alerts (universe snapshot hashed at `p42-fp-sampling/universe-rolling7d-20260826.json`;
phase42-74/-76).

## 6. Backup Cycle (live repository inspection, re-verified at closeout)

| Repository | Snapshots | Latest | Note |
|---|---|---|---|
| `wazuh-backup` (fs) | **42** | snap-20260826-0517 SUCCESS (58 indices) | fresh tonight per schedule |
| `do-spaces` (s3) | **87** | s3-snap-20260826-0547 SUCCESS (97 indices) | fresh tonight per schedule |

Restore safety streak extended to **×4**: spot-check #4 PASS with exact count parity
170,521=170,521, index green, temp cleaned (phase42-64). Wave-candidate coverage confirmed
inside latest snapshots (phase42-61).

## 7. Retention

First policy-driven deletion wave window opens at the EXACT recomputed ETA
**2026-08-29T21:00:44Z** (from live creation-timestamp explain; supersedes earlier planning
shorthand), leader #2 due 08-30T00:00:01Z confirming cadence. Readiness COMPLETE on every
mechanical dimension: policy armed/hot/evaluating on both leaders (fresh explains, zero
retries consumed), birth pipeline pre-proved via `_index_template/_simulate_index`,
hourly disk checks added to observe cadence, prohibitions restated binding. Certification
RET-CERT-42-02 = PENDING-WAVE with published flip conditions F1–F5 (phase42-67).
Forced deletion remains prohibited per AGENTS.md.

## 8. Capacity & Temp (series)

| Measure | Series today | Note |
|---|---|---|
| Root filesystem | **84%** plateau (119G/148G, 23G avail; re-read live at closeout) | df-basis headroom to advisory line 6.8G; ES-allocation-basis margin 0.89G |
| **Threshold disclosure (NEW)** | `cluster.routing.allocation.disk.threshold_enabled=false` set statically in indexer configs | the 85% watermark is ADVISORY-ONLY — prior "low watermark in force" phrasing described the configured number, not an enforced gate; reframed honestly as known-limitation; enable-vs-formally-accept decision queued (BCK-42-001h); watermarks stay DO-NOT-TOUCH |
| Wave-before-fill math | inflow ≈0.5–1 GB/day × 3.5 d ≈ 1.8–3.5 G < 6.8 G headroom | wave arrives before any plausible fill risk; hourly reads anyway |
| Memory / cluster | stable; cluster GREEN, 3 nodes | zero unexplained shard loss |
| `/tmp` | Healthy — tmpfs 21% used (1.6G/7.6G; live read) | daily pip-cleanup cron continues; no tmp incidents logged this phase |

## 9. Dashboard Cycle

The cycle's visibility headline is a REAL defect found→root-caused→fixed:

- Root cause: Windows EventID maps to `data.win.system.eventID` (1,955,152 archived docs);
  ECS `event.code` is NEVER populated anywhere in this stack; the original W2 table
  aggregated a text field whose fielddata is broken (real error reproduced, not assumed).
- Fix shipped: v2 saved objects retarget `eventID.keyword` — IMPORTED 4/4 objects with
  live-count parity proven (EID7 44,095 / EID5 981 / EID1 842 vs control 46,226);
  originals retained for rollback.
- Swap pending one owner signoff (BCK-42-001g); visual-render login session kit ready
  (BCK-42-011); mobile/accessibility pass completed client-safe (phase42-70/-71/-72).

## 10. Governance Cycle

- **Triple CI GREEN** through the closeout corpus (report · canonical · agents) — verbatim
  outputs embedded phase42-101 §6.
- **Catalog parity:** base ledgers hold 392 unique rows / 0 hash mismatches (93 phase41
  rows intact); the phase42 corpus append is QUEUED as an explicit pre-commit checklist
  item in REPO-42-04 — tracked delta, not silent lag.
- **AGENTS ledger:** AGENTS.md UNCHANGED this phase (no new hazard classes required —
  P41 codifications held, including probe-first discipline which drove the five-test
  matrix); no CHG-42-AGENTS entry needed.
- Repair-gate fix, nosniff dedup, adjudicator script, and proxy header change all carry
  same-day apply records with rollback paths (phase42-45/-50/-53 lineage).

## 11. Blocker Review (owner-batch, now EIGHT items — one session)

| # | Blocker | Unlocks when cleared |
|---|---|---|
| 1 | 013 power-on (>26 h dark) | Fleet numerator 7→8 |
| 2 | 015 caffeinate plist | Sleep-correlated disconnects end |
| 3 | DEC-40-01 signature | RTO/RPO objectives bind |
| 4 | Restore-target approval | Rehearsal leaves NO-GO path |
| 5 | Host-conf 640 chmod (blocked-no-sudo) | Last secret-perms residual closes host-side |
| 6 | GitHub token for v1.3.1 page | Release-page publication completes (runbook staged) |
| 7 | Dashboard v2-swap signoff | Corrected EID views go live |
| 8 | Disk-thresholds policy decision | Capacity posture formally dispositioned |

Automation-executable items NOT blocked: field adjudication tomorrow AM (script staged),
monitor full-day flip 01:45Z, ISM wave observation Aug-29, legacy-burst watch
(self-extinguishes at rollover).

## 12. Billing Cross-Reference

BILL-42-05 (phase42-97): stance **RECOMMENDED with disclosures** — capture VERIFIED,
detection VERIFIED through containment+bursts with zero impact, Class-A routing
CERTIFIED-AUTOMATED sustained (delivered=46, dual-fault-proof monitor), packet DEFERRED on
finalized platform evidence, capacity 84% transparently disclosed incl. threshold finding,
dashboards improved (v2 fix shipped pending swap), evidence-quality STRONGEST-YET. Invoice
period August 2026.

## 13. Retrospective

**Went well**
- **Probe-first discipline AGAIN prevented fabricated certifications.** The five-test
  capability matrix was completed BEFORE any production claim was attempted on the packet
  lane; the negative result is what makes the deferral conviction-grade rather than apologetic.
- **The churn fix was designed-for-evidence in BOTH directions.** Healthy-fleet no-op ×3 AND
  a forced backend-detach failure were proven before certification — the gate demonstrates
  restraint when nothing is wrong and recovery when something is, without collateral
  restarts either way.
- **The disclosures culture caught a configuration surprise.** Discovering that disk
  allocation thresholds were statically disabled could have stayed buried; instead it was
  verified, quantified against wave timing, disclosed same-day, reframed as
  known-limitation, and converted into a tracked owner decision within hours.
- **Reality kept certifying the monitor.** A second genuine fail-closed ERROR arrived
  mid-phase and was caught exactly as designed — twice-proven by life, not by drills.

**Went poorly (and lessons)**
- **The legacy-index burst surprised monitoring assumptions.** 2,746 rejections resumed at
  07:02/07:45Z against the immutable pre-containment mapping while attention was on the
  newborn index's readiness; blast radius was bounded exactly as designed (legacy index only,
  worker untouched, self-extinguishes at rollover), but the hourly-watch plan now in force
  (phase42-14) should have been standing from the moment the legacy window opened. Lesson:
  a dying index is still an active attack surface for schema-drift noise until its last byte.
- **The Tools-app rabbit hole spanned three phases before the definitive probe.** The
  execute_python question was first raised P40, partially probed P41 (five UNDEF keys), and
  only reached decisive finality this cycle with the full five-test matrix including T4's
  full-metadata falsification. The probe-first lesson WAS codified earlier — it should have
  been ENFORCED sooner: one systematic capability matrix at lane-opening would have saved two
  phases of incremental discovery. Codified enforcement: any new automation primitive gets
  the matrix treatment before design work begins.

*No secret values appear in this report; credentials are referenced exclusively by storage location.*
