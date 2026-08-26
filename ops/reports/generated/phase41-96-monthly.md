# Phase 41 Monthly Operations Report

**Report ID:** phase41-96-monthly
**Phase:** 41
**Title:** MONTHLY-41-09 — August Cycle Closer: Endpoint, Packet (18-Webhook-Exec Proof Ladder), IRIS (Alerts 36–46 Era), Alert Volumes, Backup, Retention (Wave ETA + Restore Streak ×3), Capacity Series, Temp, Dashboard (Data-Validated/Render-Pending), Governance Cycles; Blocker Review; Retrospective
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T07:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-96-monthly.md`

---

## 1. Cycle Frame

Closes the August operating cycle alongside BILL-41-04 (phase41-94), SCORE-41-05 (phase41-95),
and the BCK-41 register (phase41-93). Facts below are live-verified today per the cited phase41
evidence chain.

## 2. Endpoint Cycle

| Agent | State | Action this cycle |
|---|---|---|
| Fleet overall | **7 active-class of 10 registered** | 000, 006, 007, 011, 012, 014, 016 active |
| 013 (SAMSUNG) | Offline | Sustained-proof + final-cert chains completed (phase41-20/-21/-22); owner power-on packaged in the one-session batch |
| 015 (Julians-Air) | Offline (device-side flap) | Power baseline + remediation record + final state complete (phase41-23…26); manager side long fixed; caffeinate ask staged for the same owner session |
| 008 | retired-stopped | Validation PASS — exited, restart=no, volumes intact, reactivation documented (phase41-80) |

Sensor endpoint note (agent 016 host): production Suricata now runs as a SINGLE verified instance
after the dual-process defect was found and fixed (systemd unit masked; exact-args setsid
invocation); sensor disk 57%; wazuh-agent active.

## 3. Alert & Packet Pipeline Volumes

| Measure | Value | Note |
|---|---|---|
| Alerts lane (`wazuh-alerts` today) | **10,655** flowing during the containment postcheck window | capture health intact through the arc |
| Top alert groups (today) | ubiquiti 8463 · mctportal 3784 · audit 1086 · audit_anom 1079 · wireless 966 · wan 579 · windows 524 · syslog 523 | live aggs [phase41-88] |
| Top rule IDs | 120518 / 120537 / 120527 | unchanged leaders |
| Archives stats source | **ELIMINATED at source** (last full-stats doc ever indexed 03:53:31.766Z) | replaced by compact lane |
| Compact health lane | `data.event_type:stats_compact`: 43 docs by 04:49Z → **129 by ~06:24Z**, live growth observed | ~1/min cadence, all 16 counters present |

FP baseline (new this cycle): universe of 12 alerts/7d = 8 canary-marked synthetic + 4 natural
(sids 2260001 / 2210038 / 2100366 ×2); ZERO false positives in the natural population;
qualitative-only regime until ≥50 natural alerts (phase41-74).

## 4. Workflow & Packet Cycle

Three-workflow estate live and clean: `suricata-packet-routing` (test-only/disabled trigger,
13 actions), high-sev→IRIS Class-A workflow, flow-classb draft.

The packet import arc climbed an **18-webhook-execution proof ladder** against the test-only lane:
API creation solved via curated-body POST (trailing-newline root cause closed); hook registration
pattern extended (the `workflows` field must target the workflow ITSELF; backend caches require a
flush to see it); the imported artifact's hallucinated node functions were replaced with the real
function inventory; iterative defects were fixed until executions reached ALL-NODES-CLEAN with
IRIS test-route HTTP 200 delivery. The ladder then hit its honest ceiling: probe workflows proved
`execute_python` on this Shuffle build exposes NO incoming-data variable (five candidate keys all
UNDEF) and passes `$param` refs as literals — so normalize/validate/isolation/dedup semantics
cannot be certified here, and production routing was DEFERRED with two staged remediation paths
(phase41-52). All events synthetic-marked; zero production contamination; probe artifacts deleted,
datastore + cache flushed.

## 5. IRIS Cycle

Delivery SUSTAINED through the alerts 36→46 era. The Class-A lane added real honeypot volume:
cumulative delivered climbed **40→46** overnight on genuine OpenCanary flow (+6 delta reconciled
by the fresh 05:14Z monitor run). Accounting of record: delivered=46 / failed=31 / aborted=3 /
other=4 — the failed family remains frozen at its historical silent-degradation era total
(last failure 2026-08-10T19:24:16Z). Overnight soak: 14 monitor cycles, ZERO silent gaps,
INCLUDING one real fail-closed ERROR at the 04:15Z slot that emitted no counters and self-healed —
failure detection proven by an actual event. Watchdog live at offset cron 3,18,33,48 with a
dedicated alert log (phase41-39/-43).

## 6. Backup Cycle (live repository inspection)

| Repository | Snapshots | Latest | Time |
|---|---|---|---|
| `wazuh-backup` (fs) | **42** | snap-20260826-0517 | fresh tonight per schedule |
| `do-spaces` (s3) | **87** | s3-snap-20260826-0547 | fresh tonight per schedule |

Restore safety streak extended to THREE consecutive bounded restores across phases: spot-check #3
PASS with 170521=170521 count parity (phase41-57). ISM pre-wave snapshot discipline held
(before-snapshot taken during wave prep, phase41-55).

## 7. Retention

First policy-driven deletion wave window opens **2026-08-29T21:00Z** (~1.8 GB expected relief);
policy verified attached, hot, evaluating transitions (live `_ism/explain`, phase41-53/-54).
Observation checkpoint staged Aug-30 morning; forced deletion remains prohibited. Disk relief
bookkeeping captured mid-cycle (phase41-58); capacity plateau analysis updated (phase41-59).

## 8. Capacity & Temp (series)

| Measure | Series today | Note |
|---|---|---|
| Root filesystem | ~83% early cycle → **84% late re-read** (118G/148G, 24G avail) | within the disclosed 82–84% band; Aug-29 wave relief staged; ingest unaffected |
| Memory | ~77% used (11,950/15,553 MB); load ~2.0–2.1 | stable |
| Cluster | GREEN, 3 nodes, 282 shards / 149 primary, 0 unassigned | zero ingest rejections trailing 24h |
| `/tmp` | Healthy at last verified reading (21% of tmpfs; daily pip-cleanup cron continues) | no tmp incidents logged this phase |

## 9. Dashboard Cycle

W1/W2 dashboards DATA-VALIDATED against live queries (agent-active widget read among them) —
upgraded from P40's structural import verification. Two honesty items carried forward rather than
papered over: (1) visual-render verification is login-gated (pixels not yet seen); (2) the
event.code-vs-rule.groups EID mapping discrepancy is flagged with an owner query raised
(`sysmon_eid1`=576 lives in rule.groups while event.code shows 0 hits in the sample dataset).
Mobile/accessibility pass completed client-safe (phase41-63/-64).

## 10. Governance Cycle

- **Triple CI GREEN** through the closeout corpus (report · canonical · agents) — verbatim outputs
  embedded phase41-98.
- **Catalog reconciliation APPLIED:** +91 lagging rows then self-rows appended with real sha256s;
  ledgers now hold **392 unique rows with 0 hash mismatches across all 93 phase41 entries**.
- **AGENTS.md updated under CHG-41-AGENTS-01** with the full compliance chain (backup sha256
  banked before edit, dry-run, apply, post-validate, CI green), adding the heredoc-via-ssh stdin
  collision hazard, the systemd-unit-vs-invocation warning, and the execute_python platform note.
- Canonical current-state refreshed (CS-41-01, current-state-20260826-postp41.md) and open-work
  ledger rewritten (OPENWORK-41-01: ten closures moved to the resolved log).
- Drift sweep MANAGED: fourteen items each dispositioned; two fixed in-phase; five discovered by
  the session's own commands (phase41-92).

## 11. Blocker Review (owner-batch)

| # | Blocker | Unlocks when cleared |
|---|---|---|
| 1 | Owner batch not yet executed (013 power, 015 caffeinate, DEC-40-01 signature, rehearsal-target approval) — ONE session covers all four | Fleet numerator recovery; objectives bind; rehearsal leaves NO-GO |
| 2 | Field-flip adjudication (dated tomorrow morning, 08.27 index) | Certification flips CONTAINED-PENDING→VERIFIED |
| 3 | Packet remediation path choice (recommend UI rebuild on native nodes) | Lane can leave test-only or stay honestly deferred |
| 4 | v1.3.1 cut execution (checklist pre-drafted, RELPLAN-41-01) | Twelve labeled deltas fold into a tag with day-one custody posture |
| 5 | Dashboard render session + EID mapping answer | Visibility domain reaches full GREEN |

## 12. Billing Cross-Reference

BILL-41-04 (phase41-94): stance **RECOMMENDED with disclosures** — capture VERIFIED, detection
VERIFIED, Class-A routing CERTIFIED-AUTOMATED sustained (delivered=46, monitor matured-with-proof),
packet lane DEFERRED-disclosed with platform-level evidence, capacity 82–84% with relief staged
Aug-29, dashboards data-live, evidence-quality STRONG. Invoice period August 2026.

## 13. Retrospective

**Went well**
- **Empirical probing culture prevented fabricated proofs twice.** The function-inventory rebuild
  replaced an artifact's hallucinated node functions with what actually exists, and the globals
  probe (five UNDEF keys) stopped a normalize/validate gate claim that would have been unfounded.
  Negative evidence — proving what the platform cannot do BEFORE anything depended on it — is why
  the packet deferral carries conviction instead of apology.
- **The dual-process discovery validated suspicion-driven verification.** eve.json pollution that
  "shouldn't happen" was chased to a second, misconfigured Suricata running beside the production
  PID; masking plus exact-args restart made the containment deterministic.
- **Custody closed without the tool everyone assumed was required.** No `gh`, no privileged
  network path — the REST API location-and-download pattern retrieved the published original and
  hash-matched it byte-exact, converting a multi-phase PARTIAL into CLOSED in one morning.
- **Failure detection proven by reality, not drills:** the monitor's first genuine fail-closed
  ERROR (04:15Z slot) did exactly what it was built to do, and the watchdog's self-masking bug was
  caught before install rather than after a missed alert.

**Went poorly (and lessons)**
- **The execute_python assumption cost multiple cycles before the probe ran.** Hours went into
  building gating semantics on an input variable that never existed on this build. **Lesson,
  codified in AGENTS.md: probe platform contracts FIRST** — write the five-line UNDEF check before
  designing anything on top of a documented-but-unverified interface.
- **YAML values-support assumption untested upfront:** two attempts to whitelist stat fields were
  silently ignored by Suricata 7.0.10 before source elimination was chosen. Same lesson shape —
  verify config-contract support with a minimal live test before iterating on structure.
- **The ssh-heredoc stdin collision recurred** (script consumed the heredoc stream meant for the
  remote shell). Now codified in AGENTS.md: stage scripts to files on targets or use
  `ssh host bash -s < localfile`.

*No secret values appear in this report; credentials are referenced exclusively by storage location.*
