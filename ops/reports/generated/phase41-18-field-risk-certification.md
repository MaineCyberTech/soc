# Phase 41 Field Risk Certification

**Report ID:** phase41-18-field-risk-certification
**Phase:** 41
**Title:** Phase 41 Field-Risk Certification — CONTAINED-PENDING-FULL-CYCLE (Source Eliminated + Compact Lane Proven; VERIFIED on 08.27 Confirmation)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:10:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Certification:** **CONTAINED-PENDING-FULL-CYCLE**
**Limit Policy:** unchanged — limit 2000, soft 1400, hard 1800 per policy ✓
**Authoritative:** true
**Supersedes:** the open field-growth WARN disposition of phase40-07/phase40-11 (supersession completes on flip)
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-18-field-risk-certification.md`

---

## 1. Certification Statement

The dominant mapped-field growth source — Suricata full-stats events feeding
`data.stats.*` (441 unique leaves / 877 raw of today's vocabulary) — is **eliminated at
its producer** as of 2026-08-26T03:55:59Z (last stats document ever indexed:
03:53:31.766Z). The replacement compact-stats lane is **proven end-to-end**
(43+ docs indexed and searchable by 04:49Z, all 16 whitelisted aliases present,
~60s cadence).

Accordingly the field-growth risk state is certified:

> ## CERTIFICATION: CONTAINED-PENDING-FULL-CYCLE

Contained in every sense measurable today; final verdict flips to **VERIFIED** when
tomorrow's index (`wazuh-archives-4.x-2026.08.27`) confirms the projected birth
vocabulary. Thresholds were NOT touched: limit remains 2000 per P39 policy ✓ —
containment was achieved by shrinking demand, not raising supply.

## 2. Evidence Matrix

| # | Claim | Verdict | Primary evidence |
|---|---|---|---|
| 1 | Rejection false alarm resolved (no regression ever) | PASS | minute-bucketed histograms: all rejections pre-cutover; last ever ≤00:00:01.431Z (phase41-01 §4) |
| 2 | Plateau measured pre-containment (velocity zero) | PASS | 1706×3 samples, growth_per_day=0.0 (phase41-04 §2) |
| 3 | Full branch attribution incl. single producer for stats | PASS | agent 016 = 100% of stats docs (phase41-06/07) |
| 4 | Consumer safety proven before removal | PASS | greps + behavioral queries: zero consumers, zero rule-matched stats docs (phase41-09) |
| 5 | Design survived honest failure analysis | PASS | two silent YAML failures documented; dual-process defect found & fixed (phase41-10) |
| 6 | Options adjudicated against policy | PASS | limit-raise rejected-by-policy; O6 chosen (phase41-12) |
| 7 | Lab gate before production mutation | PASS | `-T` clean + first compact line valid (phase41-14) |
| 8 | Apply complete with rollback armed | PASS | yaml.bak-p41-containment + un-wire sequence (phase41-15) |
| 9 | Zero post-restart stats ingestion | PASS | count=0 query ≥03:56Z; awk window corroboration (phase41-16 §2) |
| 10 | Replacement lane indexed & searchable | PASS | 43 docs @04:49Z; all aliases present; embedded doc (phase41-16 §3) |
| 11 | Alert lane + capture health intact | PASS | 10,655 alerts flowing; kernel_drops=0 throughout (phase41-16 §4–5) |
| 12 | Projection with explicit flip band | ARMED | ≈1285 conservative / ≈900 corrected, both <1400 (phase41-17 §5) |

## 3. Why PENDING (not VERIFIED) — The Honest Reason

A containment claim about FIELD COUNTS can only be fully verified on an index that
started life WITHOUT the removed producer. Today's index retains its historical
mapping (1766 raw and append-only); no operation can shrink it. The certification
therefore carries exactly one outstanding condition rather than vague confidence.

## 4. Flip Condition (VERIFIED iff)

On `wazuh-archives-4.x-2026.08.27`:

1. First guardrail run: `leaf_fields` (raw basis) **≤1400**;
2. Second run mid-day: still ≤1400 (no surprise late families);
3. Zero documents with `data.stats.exists`;
4. Compact lane fresh (docs arriving at ~1/min);
5. win-family unique ≤150 (deferred-trigger not tripped, phase41-11).

All five → phase41-18 addendum flips certification to **VERIFIED** and closes the P38→P41 field arc chain. Any failure → revert to CONTAINED-PENDING with attribution rerun using this corpus's method set.

## 5. Limit Policy Note

No threshold was edited, and none is proposed. Post-containment steady-state
projection (~900–1285 raw vs 2000) restores >35% headroom minimum under the most
pessimistic accounting — the budget does its job again without amendment.

## 6. Residual Risks (accepted & tracked)

| ID | Risk | Severity | Mitigation / trigger |
|---|---|---|---|
| R-1 | Cross-index stats queries asymmetric over retention horizon (≤14d) | LOW | documented playbook shift to compact predicates (phase41-09 §4–5) |
| R-2 | Windows family slow growth (+8 unique during arc morning) | LOW-MED | deferred containment with >150-leaf / >25-per-day triggers (phase41-11) |
| R-3 | Compact emitter silent failure → capture-health blindspot | MED if it fires | monotonic freshness is observable; flip condition #4 checks it daily initially |
| R-4 | systemd unit ExecStart mismatch persists (masked, not fixed) | LOW while masked | fix ExecStart or formalize manual-invocation runbook next ops window |
| R-5 | Basis ambiguity recurrence in future reports | PROCESS | basis labels now mandatory (phase41-06 §3, phase41-17 §4) |

## 8. Flip Addendum Template (pre-drafted for tomorrow)

```
## ADDENDUM A — Certification Flip Record (to be filled 2026-08-27)

Run 1 (post-birth): ts=________ leaf_fields=____ verdict=____ stats_exists=____
Run 2 (mid-day):    ts=________ leaf_fields=____ verdict=____ win_unique≤150? ____
Compact freshness: latest doc age ____ min   Alerts lane: flowing? ____

FLIP DECISION: VERIFIED / STAY-PENDING (strike one)
Adjudicator: ________   Refs: phase41-17 §5–6, phase41-16 §8 re-run book
```

Pre-committing the adjudication template before the data exists is deliberate: it
fixes the acceptance criteria in writing and prevents post-hoc goalpost movement —
the same discipline that made phase40-13's PENDING→VERIFIED flip auditable.

## 9. Sign-Off Block

| Role | Status |
|---|---|
| Arc owner (opencode/ox-alpha) | certification drafted on live evidence 03:38–04:51Z window |
| Guardrail policy owner | thresholds untouched; no approval needed for source-side change |
| Operator sign-off | required only for G41-13 commit/push, NOT for this certification |
| Next reviewer | whoever runs the 08.27 flip addendum |

## 10. Chain Closure View

```
P38 hypothesis (field-limit defect)
 └─ P39 template fix designed+applied (limit 2000)
     └─ P40 proof VERIFIED + guardrail WARN opened
         └─ P41 SOURCE CONTAINED (this certification) ──flip──▶ VERIFIED on 08.27
```

The WARN that opened at Phase 40 H+1.8h is, as of this report, answered at its root:
not a bigger bucket, but a smaller shovel.
