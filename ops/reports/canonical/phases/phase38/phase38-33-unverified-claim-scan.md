# Phase 38-33: Unverified Claim Scan

**Title:** Phase 38-33: Unverified Claim Scan
**Report ID:** phase38-33-unverified-claim-scan
**Phase:** 38
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-33-unverified-claim-scan.md`
**Retention Class:** LONG
**Author:** opencode (ox-alpha)

---

## 1. Purpose

Flag claims in the corpus that lack located evidence: unsupported PASS verdicts, forecasts stated as fact, effectiveness asserted from config presence alone, claims with no verification commands/outputs, and broken or self-referential evidence pointers. Verification status is assessed against artifacts actually present on disk as of 2026-08-25.

---

## 2. Unverified Claims Found

### UNV-01: Effectiveness asserted from config presence alone — decoder fix

| Field | Value |
|---|---|
| Claim | "Impact: Will eliminate 15,189 'Too many fields' errors … Status: APPLIED AND ACTIVE" (`phase36-75-final-report.md:29-30`) |
| Why unverified | The only artifact demonstrating outcome (`phase36-34-field-cardinality-post-fix-validation.md`) carries `## Status: PENDING restart` (:17) and lists "ELIMINATED" under **Expected outcome** (:12) — a plan, not a result. No post-restart log excerpt exists anywhere in P36. Outcome was later measured only in P37 (`phase37-38-field-postlogs.md:11-17`) and contradicted the claim. |
| Classification | EFFECTIVENESS-FROM-CONFIG + FORECAST-AS-FACT |
| Required verification | Post-restart ossec.log window showing error rate; sustained <10/min for the acceptance window. Still outstanding (live ~100/min). |

### UNV-02: Registered claims left UNVERIFIED by Phase 38's own claim schema

| Field | Value |
|---|---|
| Claim set | CLM-38-005 ("512 insufficient"), CLM-38-009 ("first archive deletion 2026-08-29"), CLM-38-010 ("deployability PARTIAL / full-cluster NO-GO"), CLM-38-015 ("73 files near-duplicate") — status UNVERIFIED per `generated/phase38-09-claim-schema.md:154-159,164` |
| Why unverified | Phase 38 registered 20 claims, verified 15, deferred 5 without scheduling verification (`generated/phase38-00-master.md:52-54`). CLM-38-009 cannot be verified before 2026-08-29 by construction. |
| Required verification | Independent command outputs per claim; wave observation on 2026-08-29 for CLM-38-009. |

### UNV-03: Workflow export integrity hashes never recorded

| Field | Value |
|---|---|
| Claim | "Computed SHA-256 hash for integrity verification"; Integrity table says "See export file" ✅ (`phase37-10-workflow-export.md` §Export Procedure, §Integrity) |
| Why unverified | No hash value appears in the report, and the cited filenames (`workflow-eb937a37-export.json`, `workflow-e951db98-export.json`) do not exist on disk — `ops/evidence/p37-workflow-export/` contains `wazuh-high-severity-to-iris.json` and `wazuh-flow-classb-to-iris.json` instead. Hash verification is impossible; the evidence pointer is broken/self-referential. |
| Required verification | Compute SHA-256 of the two on-disk JSONs, store values in an addendum, correct filename references. |

### UNV-04: Retention forecast mechanics unverified while schedule asserted

| Field | Value |
|---|---|
| Claim | First deletion 2026-08-29 will deliver ~7.9GB (`phase36-75-final-report.md:14-15`; `phase37-46-retention-relief.md:15`) |
| Why unverified | `generated/phase38-79-retention-verification.md` §2: ISM explain endpoint "returned no per-index step information (empty response)" — the report itself concedes policies "may not be fully applied, or the policy uses a different trigger mechanism." A forecast built on an unverified execution mechanism is presented across summaries as a scheduled certainty. |
| Required verification | ISM explain output showing deletion step queued for 2026.08.15 index; post-wave observation on 2026-08-29. |

### UNV-05: PASS-with-limitations final verdict lacking limitation tie-out

| Field | Value |
|---|---|
| Claim | "Final Status: **PASS** (with known limitations documented)" (`final-phase35-operator-report-20260825-1841Z.md:140`) |
| Why unverified | The same phase's own commit message records routing DEFERRED and deployability PARTIAL (git cbcca53); no gate-by-gate mapping of each "known limitation" to an owned action exists in the final. PASS-with-limitations is not a taxonomy value (`generated/phase38-08-status-taxonomy.md` defines 14 statuses; this is not one). |
| Required verification | Reclassify per taxonomy (see phase38-37); enumerate limitations as tracked items. |

### UNV-06: Live-state assertions published without captured commands/outputs

| Field | Value |
|---|---|
| Claim | Shuffle security table including auth state and bearer token presented as fact (`generated/phase38-01-preflight.md:127-138`); master repeats them as "Live state" (`generated/phase38-00-master.md:63`) |
| Why unverified | Reports state results but include no command transcript (no curl/API call output, no timestamped probe) proving auth success at write time. Additionally, printing the live bearer token created a security finding handled in phase38-40 rather than evidence. |
| Required verification | Evidence capture template: command + output + timestamp stored under ops/evidence/ for every live-state row marked VERIFIED. |

### UNV-07: Agent 013/015 recovery posture "waiting" without probe evidence

| Field | Value |
|---|---|
| Claim | "013 DISCONNECTED — waiting", "015 DISCONNECTED — waiting" (`phase36-75-final-report.md:36-37`; carried through `phase37-51-agent013-status.md`, `phase37-52-agent015-status.md`, `phase37-81-final.md:77-83`) |
| Why unverified | No stored agentctl/list probe output or last-seen timestamps accompany the "waiting" status in those reports; recovery strategy docs (`phase36-41-endpoint-recovery-strategy.md`, `phase36-43/44`) define actions but contain no executed check transcripts. Status may be stale within hours of writing. |
| Required verification | Timestamped `agent_control` query per disconnected agent, archived to evidence root. |

### UNV-08: Hardening plan steps presented with executable detail but zero execution proof

| Field | Value |
|---|---|
| Claim | iptables restrict/TLS/proxy procedure (`generated/phase38-73-shuffle-hardening.md` §3; `phase37-06/07-shuffle-exposure-plan/-apply.md`) |
| Why unverified | `phase37-07-shuffle-exposure-apply.md` §Execution Status shows every step ⏸ Not yet; `phase38-73` header states PLAN-DEFERRED. No firewall rule listing or bind change exists on disk; live `ss -tlnp` still shows 0.0.0.0:3001. Any summary implying hardening "in progress" is unsupported. |
| Required verification | Post-apply listener census + blocked-source probe stored as evidence. |

---

## 3. Summary

| ID | Claim class | Severity | Blocker to verification |
|---|---|---|---|
| UNV-01 | Effectiveness-from-config | HIGH | Post-restart log window (still failing) |
| UNV-02 | Registered-but-unverified claims | MEDIUM | Scheduled independent checks |
| UNV-03 | Broken hash/evidence pointer | HIGH | Re-hash on-disk exports |
| UNV-04 | Forecast-as-fact (retention) | HIGH | ISM explain + 08-29 observation |
| UNV-05 | Non-taxonomy PASS verdict | MEDIUM | Reclassification (see 38-37) |
| UNV-06 | Live-state w/o transcripts | MEDIUM | Evidence capture pipeline |
| UNV-07 | Agent status w/o probes | LOW | Timestamped agent queries |
| UNV-08 | Plan mistaken for progress | HIGH | Execution + validation artifacts |

## 4. Recommendation

Adopt the standing rule from `generated/phase38-09-claim-schema.md`: every VERIFIED claim must carry `evidence_refs` pointing at a file that exists AND contains the observed value. Claims failing that test are auto-downgraded to UNVERIFIED by report CI.
