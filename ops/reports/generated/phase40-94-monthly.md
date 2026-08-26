# Phase 40 Monthly Operations Report

**Report ID:** phase40-94-monthly
**Phase:** 40
**Title:** MONTHLY-40-09 — August Cycle Closer / September Cycle Opener: Endpoint, Packet, Workflow, IRIS, Alert, Backup, Retention, Capacity, Temp, Dashboard, Governance Cycles; Blocker Review; Retrospective
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-94-monthly.md`

---

## 1. Cycle Frame

Closes the August operating cycle and opens the September cycle. Live numbers below were captured
via API/CLI at report time (~03:00–03:03Z). Companion: BILL-40-03 (phase40-92), SCORE-40-04
(phase40-93), BCK-40 register (phase40-91).

## 2. Endpoint Cycle

| Agent | State | Action this cycle |
|---|---|---|
| Fleet overall | **7 active-class of 10 registered** | 000, 006, 007, 011, 012, 014, 016 active |
| 013 (SAMSUNG) | Offline | Recovery runbook READY (phase40-14…17); BLOCKED-OWNER → BCK-40-002 |
| 015 (Julians-Air) | Offline (device-side flap) | Manager-side permission defect FIXED+DURABLE: root-owned shared-config files chowned wazuh:wazuh @00:50Z; **83,736 lifetime errors ENDED**, proven across 5+ restarts (phase40-18…24). Remaining flap is device-side → BCK-40-008 |
| 008 | retired-stopped | Long-standing; no action |

Asks outstanding (owner-batch): power on 013 · caffeinate/power-settings on 015 · sign DEC-40-01 · name rehearsal target.

## 3. Alert & Packet Pipeline Volumes (live API counts)

| Index | Docs | Note |
|---|---|---|
| `wazuh-alerts-4.x-2026.08.26` | **6,836** | today, partial day at 03:00Z |
| `wazuh-alerts-4.x-2026.08.25` | 53,481 | |
| `wazuh-archives-4.x-2026.08.26` | **175,369** | first full post-template day-index; ZERO rejections |
| `wazuh-archives-4.x-2026.08.25` | 882,772 | |

Packet cycle note: sensor pipeline proven by **×7 canary-class synthetic proofs today**
(isolation, dedup, counter, test-route, replay/malformed/datastore/downstream failure modes in the
phase40-44…52 arc, plus full-chain E2E-007 with flow_id 999000777). Natural traffic on the packet
sensor remained quiet — expected for the current placement; proofs are synthetic-marked and
isolated from production counters per AGENTS.md.

## 4. Workflow Cycle

Two workflows of record; live delivery-check run at report time:

```
eb937a37  executions=77  delivered=39  failed=31  aborted=3  other=4
e951db98  executions=1   delivered=1   failed=0   aborted=0  other=0
== ALERT-39-01 SUMMARY: delivered=40 failed=31 aborted=3 other=4 ==
```

Lifetime accounting: delivered=40 / failed=31 / aborted=3 (+4 other). The failed=31 family is the
historical silent-degradation era (closed P39); NO new failures since. The monitor that watches it
is now scheduled (§6).

## 5. IRIS Cycle

**Delivery RESTORED + AUTOMATED LANE CERTIFIED.** Alert timeline of record:

| IRIS alert | When (UTC) | Chain |
|---|---|---|
| 36 | Aug-25 22:08Z (P39) | Direct probe during restoration proof |
| 37/38/39 | Aug-25 22:08:24Z (P39) | Three consecutive manual/API deliveries |
| 40 | Aug-26 00:57:16Z | Hook probe exec f28cb7e2 (post hooks-doc registration) |
| 41 | Aug-26 01:12:34Z | Manual fire exec 46b8fe3d (post DNS isolation fix master+worker) |
| 42 | Aug-26 01:28:57Z | **FULL CHAIN**: sensor flow 999000777 → alert 1787707735.1208554 → exec b6d07492 FINISHED src=webhook → HTTP 200 (~2 s latency) |

Config-of-record verified on both nodes; per-node integratord architecture documented
(phase40-35/-40). Routing certification: AUTOMATED lane PASS.

## 6. Backup Cycle (live repository inspection)

| Repository | Snapshots | Latest | Time |
|---|---|---|---|
| `wazuh-backup` (fs) | **42** | snap-20260826-0017 | 2026-08-26T00:17:11Z |
| `do-spaces` (s3) | **86** | s3-snap-20260826-0047 | 2026-08-26T00:48:15Z |

Both fired fresh tonight per schedule; s3 cadence corrected to the 5/day figure of record.
SECOND production-safe bounded restore this quarter: smallest index from snap-20260826-0017
(wazuh-monitoring-2026.32w, 652.9 kB) restored under temp name, count parity **603 = 603**,
deleted clean (phase40-57).

## 7. Retention

First policy-driven ISM deletion wave ETA unchanged: **2026-08-29T21:00:44Z** (~1.8 GB expected
relief). This cycle caught and corrected an attachment drift anomaly (ISM-40-01): the 08.26 index
had wrongly attached the `wazuh-retention` 30-day policy instead of `wazuh-archives-14d`; fixed via
remove→add; bounded impact eliminated. Observation checkpoint staged Aug-30 morning; forced
deletion remains prohibited.

## 8. Capacity & Temp

| Measure | Value | Note |
|---|---|---|
| Root filesystem | **~82–83% used** (live re-read at report time: 83%, 117G/148G, 25G avail) | Wave relief ETA Aug-29; ingest unaffected; field-growth guardrail WARN velocity noted as watch item BCK-40-001 |
| `/tmp` | **21% used** (1.6G of 7.6G tmpfs) | Healthy; daily pip-cleanup cron 03:00 continues |

Cron entries of record relevant this cycle: delivery monitor every 15 min (NEW — hardened script
with flock); tmp pip cleanup daily 03:00; elastic snapshot daily 03:30; health-check + IRIS DB
dump daily 04:30; MISP DB dump 04:35; Shuffle network repair every 15 min + @reboot; core-alert
check every 15 min; freshness check daily 06:15; Sunday jobs per standing schedule.

## 9. Dashboard Cycle

8/8 saved objects imported via API into the global tenant (first attempt against the private
tenant failed AUTHZ — honestly captured, then diagnosed and succeeded with securitytenant global).
GET verification confirms all objects present structurally. Runtime visual validation pending an
operator login session (BCK-40-010).

## 10. Governance Cycle

- **Triple CI GREEN same-day** (report · canonical · agents) — verbatim outputs embedded in
  phase40-96 §6.
- **AGENTS.md updated** through the governed chain backup→dry-run→apply→post-validate→ledger
  (CHG-40-AGENTS-01 / register G40-13): blockers refreshed to P40 reality; trailing-newline
  scripting hazard codified after it bit twice across phases.
- **Alias ledger applied:** 2 duplicate groups consolidated non-destructively via
  `canonical/ledgers/source-map-aliases.json`; empty-stub ruling deferred (BCK-40-013).
- **SecurityOnion stopped** after clean dependency sweep (~18 MiB freed; volumes preserved;
  rollback = start) — phase40-81.

## 11. Blocker Review (owner-batch)

| # | Blocker | Unlocks when cleared |
|---|---|---|
| 1 | Owner batch not yet executed (013 power, 015 caffeinate, DEC-40-01 signature, rehearsal target naming) — one session covers all four | Fleet numerator recovery; objectives bind; rehearsal can leave NO-GO |
| 2 | ISM wave observation (dated Aug-29) | Realized relief evidence; capacity decision input |
| 3 | Field-growth WARN velocity (guardrail armed) | Early containment if CRIT; plateau confirmation otherwise |
| 4 | Packet-import session unscheduled (path OPEN) | Last lane gap closes; billing disclosure retires |
| 5 | Published-asset retrieval (needs gh/network) | Byte-exact release custody; DEPLOY blocker B4 clears |

## 12. Billing Cross-Reference

BILL-40-03 (phase40-92): stance **RECOMMENDED with disclosures** — capture VERIFIED,
detection VERIFIED, Class-A routing CERTIFIED-AUTOMATED (upgraded from conditional-manual),
packet lane deferred-by-choice disclosed, endpoints honest (2 offline owner-blocked),
capacity ~82–83% disclosed, dashboards LIVE, monitor SLA-visible. Invoice period August 2026.

## 13. Retrospective

**Went well**
- **Three-layer defect hunting discipline:** the webhook arc refused to stop at the first fix —
  invalid trigger led to missing hooks-doc registration led to DNS isolation (master AND worker);
  each layer was proven before moving on. Result: a full-chain proof with exact IDs at every hop
  rather than a "probably works now."
- **Proof-first culture caught the FINISHED-trap's cousin:** the packet POST-401 "known limitation"
  was retested instead of trusted, exposing the trailing-newline token artifact — POST worked all
  along. The lesson is now codified in AGENTS.md so it outlives this phase.
- **Migration hygiene paid off again:** dashboards imported cleanly because overwrite semantics,
  tenant behavior, and rollback IDs were staged before touching the cluster; the one AUTHZ failure
  was captured honestly and turned into documentation.

**Went poorly (and lessons)**
- **rule_id filter assumption cost cycles:** the integrator-side filter was assumed semantic and
  turned out broken-in-build, forcing the group-suricata workaround. **Lesson: read the daemon
  source early** when behavior contradicts documented expectations — hours earlier.
- **Field budget underestimated:** the 2000-limit headroom was sized against a growth curve the
  real sensor beat within two hours (WARN at H+1.8h; trend ~2448/day projected). The guardrail did
  its job — escalation trigger armed — but sizing should have carried more margin.
- **Token newline bit us twice across phases** (P39 header corruption era adjacency; P41 probe
  reproduction). Finally codified as a scripting rule in AGENTS.md: strip whitespace whenever
  reading key material from files.

*No secret values appear in this report; credentials are referenced exclusively by storage location.*
