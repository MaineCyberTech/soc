# Phase 39 Monthly Operations Report

**Report ID:** phase39-100-monthly
**Phase:** 39
**Title:** MONTHLY-39-09 — September Cycle Opener / August Closer: Endpoint Cycle, Packet Pipeline Volumes (Live API), Workflow Audit, IRIS Cycle, Backup Cycle, Retention ETA, Capacity, Governance, Blockers, Retrospective
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:58:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-100-monthly.md`

---

## 1. Cycle Frame

Closes the August operating cycle and opens the September cycle. All live numbers below were
captured via API at report time (~23:56–23:58Z). Companion: BILL-39-02 (phase39-98),
SCORE-39-03 (phase39-99), BCK-39 register (phase39-97).

## 2. Packet Pipeline Stats (live API counts)

| Index | Docs | Note |
|---|---|---|
| `wazuh-alerts-*` (all-time) | **3,894,182** | 57/57 shards successful |
| `wazuh-alerts-4.x-2026.08.25` | **53,347** | today |
| `wazuh-alerts-4.x-2026.08.24` | **55,001** | |
| `wazuh-alerts-4.x-2026.08.23` | **49,602** | |

Archives tier (`wazuh-archives-4.x-*`, recent days — note the post-template volume signature):

| Day | Docs | Store size |
|---|---|---|
| 2026.08.20 | 1,486,141 | ~1.31 GB |
| 2026.08.21 | 1,423,025 | ~1.31 GB |
| 2026.08.22 | 599,196 | ~742 MB |
| 2026.08.23 | 170,521 | ~103 MB |
| 2026.08.24 | 248,458 | ~147 MB |
| **2026.08.25** | **879,734** | ~639 MB |

Today's archives jump is consistent with restored field headroom on the day's index under the new
template (effectiveness proof formalizes after 00:00Z — BCK-39-001).

## 3. Workflow Audit (SOAR)

Two workflows of record; live delivery-check run at report time:

```
eb937a37  executions=74  delivered=36  failed=31  aborted=3  other=4
e951db98  executions=1   delivered=1   failed=0   aborted=0  other=0
== ALERT-39-01 SUMMARY: delivered=37 failed=31 aborted=3 other=4 ==
```

Lifetime: **delivered=37 / failed=31 / aborted=3** (plus 4 non-terminal/other). The failed=31 family
is the Aug-15→Aug-25 silent-degradation era (header corruption) — root-caused and fixed this phase;
the monitor script that surfaced it exists but is not yet cron-scheduled (BCK-39-012).

## 4. IRIS Cycle

**RESTORED + PROVEN.** Three consecutive API-triggered real deliveries: executions
`53e2e193…`, `ab14f34c…`, `413c137a…` → IRIS HTTP 200 ×3 → distinct DB alerts 37/38/39 all at
22:08:24Z, full context preserved (severity 6, customer 1, clean `${body:rule_id}` interpolation).
Direct endpoint probe produced alert 36. Routing recertified CONDITIONAL-PASS (manual/API lane);
automated webhook wiring pending one UI session (BCK-39-005). Evidence: DLV-39-01 (phase39-34),
phase39-33, phase39-36.

## 5. Backup Cycle (live repository inspection)

| Repository | Snapshots | Latest | Time |
|---|---|---|---|
| `wazuh-backup` (fs) | **42** | snap-20260825-2017 | 2026-08-25T20:17:10Z |
| `do-spaces` (s3) | **85** | s3-snap-20260825-2047 | 2026-08-25T20:48:08Z |

Both fired fresh today per schedule. First real restore-cycle proof of the quarter executed against
the smallest index in snap-20260825-2017 (restored GREEN to temp name, verified, deleted clean;
production untouched — phase39-73).

## 6. Retention

First policy-driven ISM deletion wave ETA stands at **2026-08-29T21:00Z** (~1.8 GB expected relief).
Observation checkpoint staged for Aug-30 morning; restore-safe spot-check precondition already
satisfied. Forced deletion remains prohibited (AGENTS.md MUST-NOT).

## 7. Capacity & Temp

| Measure | Value | Note |
|---|---|---|
| Root filesystem | **84% used** (148G total, 119G used, 24G avail) | Plateau holds; ISM wave is partial relief; host remains self-disqualified as rehearsal target (external target REQUIRED) |
| `/tmp` | **21% used** (1.6G of 7.6G tmpfs) | Healthy |

Cron next-runs of record (from crontab): tmp pip cleanup daily 03:00; elastic snapshot daily 03:30;
health-check + IRIS DB dump daily 04:30; MISP DB dump 04:35; Shuffle network repair every 15 min +
@reboot; core-alert check every 15 min; freshness check daily 06:15; Sunday jobs: prune 06:00,
Greenbone backup 05:15, Shuffle workflow export 05:45.

## 8. Governance Cycle

- **Three CI gates GREEN same-day:** p38-report-ci · p39-canonical-ci · p39-agents-ci
  (full outputs embedded in phase39-102 §6).
- **Migration applied clean:** 1,992/1,992 files into canonical tree, hash-verified N=1992 M=0,
  rollback drill <2 min estimate, originals untouched (phase39-45…52).
- AGENTS.md established (134 lines, source-tagged, dynamic-state policy enforced); change ledger
  CHG-39-AGENTS-01; status enums normalized (14 mapped, one listed-not-guessed); open-work register
  consolidated to canonical/current/open-work.md with several chains RESOLVED-TODAY.
- Release v1.3.0 archived rebuilt-labeled with DIFFERENCE-FROM-PUBLISHED manifest (original
  retrieval blocked — owner item BCK-39-008).

## 9. Endpoint Cycle Results

| Agent | State | Action |
|---|---|---|
| Fleet overall | **7/9 active-class** | Registered 9; 008 retired-absent |
| 013 (SAMSUNG) | Offline since 06:30Z cutoff | Owner physical ask documented + dispatched (phase39-75) → BCK-39-003 |
| 015 (Julians-Air) | Flap correlated to macOS sleep cycles | REAL DEFECT found: `mac-clients/merged.mg Permission denied` every 10 s in manager logs; fix minutes-level once owner reachable (phase39-76) → BCK-39-002 |

## 10. Blocker Review (top-5)

| # | Blocker | Unlocks when cleared |
|---|---|---|
| 1 | Field-effectiveness proof calendar-bound to first post-template index | Detection-pipeline certification closes; ~150/min rejection baseline should flatline |
| 2 | Automated Wazuh→Shuffle webhook unwired (UI session) | Routing CONDITIONAL-PASS→PASS; billing notification line fully automated |
| 3 | No adequate external rehearsal target provisioned/approved | Deployability blocker B1; DR AMBER→GREEN path opens |
| 4 | RTO/RPO unsigned business values | Objectives bind; rehearsal go/no-go can leave NO-GO |
| 5 | Owner-latency items (013 physical access; 015 chmod; TLS decision) | Fleet denominator recovery; merged.mg defect closure; security AMBER cell clears |

## 11. Billing Cross-Reference

BILL-39-02 (phase39-98): stance **RECOMMENDED with disclosures** — capture VERIFIED,
detection VERIFIED, IRIS lane RESTORED-TODAY (silent-degradation era disclosed with era analysis),
automated routing PARTIAL (conditional), capacity 84% disclosed. Invoice period August 2026.

## 12. Retrospective

**Went well**
- IRIS root-cause speed: two-layer fault (swarm-overlay DNS isolation, then corrupted Authorization
  header inside a live workflow) found and fixed same-day, ending in a 3-consecutive-delivery proof
  within hours of first failure baseline.
- Leak sweep depth: recursion scan went beyond the known 3 locations and caught a 13-file IRIS-bearer
  family including an evidence export — tracked set now provably clean under CI.
- Migration cleanliness: copy-first apply with frozen manifest, zero mismatches, originals untouched,
  rollback drilled.

**Went poorly (and lessons)**
- Header corruption escaped P37/P38 scans entirely until a functional delivery test exposed it —
  **lesson: functional probes beat config audits.** Delivery-monitor cron scheduling (BCK-39-012) is
  the structural fix; "FINISHED" status must never again be treated as "delivered."
- TLS keeps slipping (P38→P39→P40-planned): force the decision in early September rather than
  re-deferring (BCK-39-007 has no third outcome).

*No secret values appear in this report; credentials are referenced exclusively by storage location.*
