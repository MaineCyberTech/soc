# Phase 38-31: Contradiction Scan

**Title:** Phase 38-31: Contradiction Scan
**Report ID:** phase38-31-contradiction-scan
**Phase:** 38
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-31-contradiction-scan.md`
**Retention Class:** LONG
**Author:** opencode (ox-alpha)
**Supersedes:** prior draft of this same report ID (expanded candidate set, live-state re-verification)

---

## 1. Purpose

Identify conflicting claims about the same entity, metric, or time window across the report corpus (`/opt/mct-security-stack/ops/reports/` — 1,833 .md files live count) and against live state as of 2026-08-25. Each contradiction records Claim A, Claim B, live truth, severity, and a resolution statement. This scan supersedes the earlier draft by adding the retention forecast-as-fact, agent-014 throttle, and report-count contradictions that were absent from it.

---

## 2. Contradictions Found

### CON-01: Field Error Resolution — "Eliminated/Applied" vs ~100/min Ongoing

| Attribute | Claim A | Claim B |
|---|---|---|
| Statement | Fix will eliminate errors; status "APPLIED AND ACTIVE" | "decoder_order_size=512 did **NOT** resolve… active and accumulating"; "~100/min" |
| Source A | `phase36-75-final-report.md:29-30` ("Will eliminate 15,189 'Too many fields' errors"; "Status: APPLIED AND ACTIVE"); `phase36-34-field-cardinality-post-fix-validation.md:12` ("'Too many fields' errors: ELIMINATED") | `phase37-38-field-postlogs.md:11-19` (~100/min; 1,830 errors in 18 min; NOT resolve); `phase37-81-final.md:44-52` (18,849 total; "Resolution: Not resolved"); `generated/phase38-01-preflight.md:116-121` |
| Live truth | Field errors continue at ~100/min; decoder_order_size=512 confirmed INSUFFICIENT (live state 2026-08-25) |
| Severity | HIGH |
| Resolution | Claim B is correct. Config deployment succeeded; resolution did not occur. A's "ELIMINATED/APPLIED AND ACTIVE" was a forecast asserted before post-restart validation completed (phase36-34 itself shows `Status: PENDING restart`). Canonical: **512 applied, insufficient, ~100/min ongoing.** |

### CON-02: Shuffle Frontend Binding — "Loopback" vs "0.0.0.0 EXPOSED"

| Attribute | Claim A | Claim B |
|---|---|---|
| Statement | "Shuffle frontend: UP on 127.0.0.1:3001" (protected loopback) | "Frontend (UI) bind 0.0.0.0 port 3001 … externally reachable"; "EXPOSED on 0.0.0.0:3001" |
| Source A | `phase36-17-shuffle-wazuh-integration-blocker.md` §Current state ("Shuffle frontend: UP on 127.0.0.1:3001") | `phase37-04-shuffle-listener.md:11,22,52` ; `phase36-26-shuffle-final-status.md:8`; `phase36-75-final-report.md:21` |
| Live truth | `ss -tlnp` shows LISTEN on `0.0.0.0:3001`; HTTP probe returns 200 via nginx; HTTPS handshake fails (no TLS) |
| Severity | HIGH |
| Resolution | Claim B is correct and matches live state. Claim A described an assumed/unverified binding. The parenthetical "(was 127.0.0.1:3001)" at `phase36-75-final-report.md:21` implies a deliberate change for which no change record exists (no iptables/compose diff; `phase37-07-shuffle-exposure-apply.md` confirms "Firewall rules on 3001: None"). Canonical: **frontend bound 0.0.0.0:3001 since initial deployment; never loopback-only.** |

### CON-03: Retention Relief — "~7.9GB" Forecast Treated as Realized vs Zero Deletions

| Attribute | Claim A | Claim B |
|---|---|---|
| Statement | "~7.9GB relief" cited as an expected/coming benefit, repeated in summaries as if secured | "Realized Relief: Bytes freed 0; Indices deleted 0" |
| Source A | `phase36-75-final-report.md:15-16` ("Expected relief: ~7.9GB"; "Post-wave disk estimate: 76%") | `phase37-46-retention-relief.md:7-15` (Realized = 0; Expected ~7.9GB on 2026-08-29); `generated/phase38-79-retention-verification.md` §1 ("No deletions have occurred") |
| Live truth | Zero deletions to date; first wave forecast 2026-08-29; disk still ~84% (LOW watermark) |
| Severity | MEDIUM |
| Resolution | Not yet resolvable — forecast vs fact must not be conflated. Any summary stating ~7.9GB as obtained relief is PREMATURE/STALE until the 2026-08-29 wave is observed. Canonical phrasing: **~7.9GB FORECAST on 2026-08-29; realized relief = 0 bytes as of 2026-08-25.** Note additionally: `phase38-79` reports ISM explain endpoint returned empty, so even policy execution mechanics are unverified. |

### CON-04: Workflow Counts — "No Workflows" / "2 Workflows" / "Routing Exists"

| Attribute | Claim A | Claim B |
|---|---|---|
| Statement | "Workflow backup: N/A — No workflows to back up" | "2 workflows already exist (wazuh-high-severity-to-iris, wazuh-flow-classb-to-iris)"; elsewhere "Real routing: None" |
| Source A | `final-phase35-operator-report-20260825-1841Z.md:54` | Existence: `phase36-75-final-report.md:19`; exports: `phase37-10-workflow-export.md`; routing-none: `phase37-81-final.md:26-31`; `phase37-32-routing-decision.md:9` |
| Live truth | 2 workflows exist (both healthcheck), 796 executions, zero production routing; backup JSONs exist on disk (`ops/backups/shuffle-workflows/shuffle-workflows-20260823-054501.json` and older) |
| Severity | MEDIUM |
| Resolution | Claim A is FALSE as of Phase 36 discovery (and backups exist since 2026-08-11). "2 workflows" vs "no routing" are different metrics frequently conflated. Canonical: **2 workflows total (both healthcheck), 0 production routing workflows, 796 healthcheck executions.** |

### CON-05: Agent 014 Throttle — "Throttled / RETAIN" vs "None Detected"

| Attribute | Claim A | Claim B |
|---|---|---|
| Statement | Agent 014 Sysmon flood throttled; throttle suppression retained pending endpoint access | "Throttle: No active throttle rule"; "Active Throttle to Retire: None"; "Throttle: None detected" |
| Source A | `final-phase22-operator-report-20260822-034811.md:17,126`; `final-phase28-operator-report-20260824-184100.md:28` ("Throttles: RETAIN"); `deepdive-audit-20260822-052122.md:23` | `phase37-49-agent014-throttle.md:12,28`; `phase37-50-agent014-retire.md:10,29`; `phase37-81-final.md:70` |
| Live truth | Agent 014 ACTIVE per fleet list (000,006,007,011,012,014,016); no throttle-retirement action record exists between P30 and P37 |
| Severity | LOW-MEDIUM |
| Resolution | Unreconciled across time. Either the throttle was retired without a written action record, or the earlier "RETAIN" state silently lapsed. No artifact proves retirement. Canonical: **No throttle detected as of P37 certification (P37-49); provenance of earlier RETAIN state unrecorded — treat earlier throttle references as historical context only.** |

### CON-06: Report Corpus Counts Diverge Across Summaries

| Attribute | Claim A | Claim B |
|---|---|---|
| Statement | ".md files: 1,831; non-md 25; totals scanned 1,856" | Live: 1,833 .md files; 27 non-md; 1,860 files in reports/ root; `phase38-03` separately claims "3 roots, 1,877 canonical files" |
| Source A | `generated/phase38-04-report-inventory.md:17-20`; `generated/phase38-00-master.md:144-145` | Live `ls` counts 2026-08-25; `generated/phase38-03-report-root-discovery.md` §Summary |
| Severity | LOW |
| Resolution | Inventory was accurate at write time and drifted as new reports were added (including these twelve). Canonical going forward: counts are point-in-time; any summary must carry its measurement timestamp. Root cause of the 1,877-vs-1,856 gap in the SAME phase is unexplained and requires reconciliation in phase38-03. |

### CON-07: Non-Active Agent Categorization — "3 retired/disconnected" vs 2+1 Split

| Attribute | Claim A | Claim B |
|---|---|---|
| Statement | "Disconnected: 3 (008-retired, 013, 015)"; master table "Retired agents: 3" | "008 RETIRED (decommissioned); 013 DISCONNECTED waiting; 015 DISCONNECTED waiting" |
| Source A | `phase36-75-final-report.md:68`; `generated/phase38-00-master.md:117` | `phase36-75-final-report.md:36-38` (own detail section); `phase37-81-final.md:77-83` |
| Live truth | 7 active; 2 disconnected (013, 015); 1 retired (008) |
| Severity | LOW |
| Resolution | A conflates distinct operational states (retired ≠ recoverable). Canonical: **7 active / 2 disconnected / 1 retired.** |

### CON-08: "Config Applied + Drift None" vs "Problem Not Resolved"

| Attribute | Claim A | Claim B |
|---|---|---|
| Statement | Drift table marks local_internal_options.conf staged 512 as "Applied \| None" drift | "Resolution: Not resolved" with continuing error rate |
| Source A | `phase37-73-drift.md` §config rows | `phase37-81-final.md:50` |
| Severity | HIGH (language hazard) |
| Resolution | Deployment state and remediation outcome are distinct axes being merged into one column. Canonical rule: report **deployed-config** and **error-rate outcome** as separate fields. See CON-01. |

### CON-09: Memory Percentage Rounding

| Attribute | Claim A | Claim B |
|---|---|---|
| Statement | "Memory: 15,553MB total, 78% used" | "Used 11,747 MB (75%)"; swap 64% consistent in both |
| Source A | `phase36-75-final-report.md:64` | `phase37-81-final.md:110,112` |
| Live truth | Mem 75% (live state 2026-08-25) |
| Severity | LOW |
| Resolution | 78% is an over-round of ~75.5%. Canonical: **75%.** |

---

## 3. Summary Table

| # | Contradiction | Severity | Disposition |
|---|---|---|---|
| CON-01 | Field fix "eliminated" vs ~100/min ongoing | HIGH | B correct; A forecast-as-fact |
| CON-02 | Loopback vs 0.0.0.0:3001 exposure | HIGH | B correct; live ss confirms |
| CON-03 | 7.9GB relief forecast vs 0 deletions | MEDIUM | Forecast; unresolved until 08-29 wave |
| CON-04 | Workflow existence/routing phrasing | MEDIUM | 2 healthcheck / 0 production canonical |
| CON-05 | Agent 014 throttle present vs none | LOW-MED | Current truth = none; provenance gap logged |
| CON-06 | Report-count divergence | LOW | Point-in-time counts; 1,877 anomaly open |
| CON-07 | Retired/disconnected conflation | LOW | 7/2/1 canonical |
| CON-08 | Applied≠resolved language | HIGH | Split deploy-state vs outcome fields |
| CON-09 | Memory rounding | LOW | 75% canonical |

---

## 4. Recommendations

1. Enforce two-field reporting for every remediation: `config_state` and `verified_outcome`.
2. Ban future-tense benefit statements in summary sections unless tagged `FORECAST` with an observation date (see retention, CON-03).
3. Standardize fleet reporting as `active/disconnected/retired` triplets.
4. Standardize workflow reporting as `total(healthcheck, production)` pairs.
5. Reconcile the phase38-03 "1,877 canonical" figure against root-level inventory in a follow-up.
