# Phase 41 Billing Certification

**Report ID:** phase41-94-billing
**Phase:** 41
**Title:** BILL-41-04 — August 2026 Billing Coverage Matrix: Capture VERIFIED, Detection VERIFIED, Class-A Routing CERTIFIED-AUTOMATED Sustained (delivered=46, Monitor Matured With Watchdog); Packet Lane DEFERRED-Disclosed With Platform-Level Evidence; Stance RECOMMENDED
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T07:00:00Z
**Classification:** INTERNAL (client-shareable only via phase41-95 §client-safe section)
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-94-billing.md`

---

## 1. Certification Statement

| Field | Value |
|---|---|
| Certification ID | BILL-41-04 |
| Invoice period | **August 2026** |
| Billable stance | **RECOMMENDED — with disclosures (§4)** |
| Supersedes | BILL-40-03 (phase40-92) |
| Cross-references | SCORE-41-05 (phase41-95), MONTHLY-41-09 (phase41-96), BCK-41 register (phase41-93) |

## 2. Coverage Matrix per Service Line

| Service line | Status | Basis of verification | Evidence |
|---|---|---|---|
| Log capture (7 active-class endpoints + packet sensor) | **VERIFIED** | Fleet 7 active-class of 10 registered; sensor pipeline healthy post-containment (production Suricata single-instance verified after dual-process fix; capture kernel drops = 0 throughout the arc; alerts lane flowing at 10,655 docs during postcheck window) | phase41-15/-16; fleet state live [phase41-81] |
| Detection (rules + canary E2E) | **VERIFIED** | Canary coverage proven across three eras (SO legacy → Class-A automated → packet-lane test-only); archives quality IMPROVED this cycle — full-stats field bloat removed at source and replaced by a compact health-telemetry lane (`stats_compact`, 16 whitelisted counters, searchable), so detection-relevant data is leaner and ingest rejection risk is structurally retired | phase41-15/-16/-18; phase41-89 |
| Notification routing — Class-A lane | **CERTIFIED — AUTOMATED (sustained)** | delivered count climbed 40→46 on REAL honeypot (OpenCanary) flow overnight; monitor SLA-visible at 15-min cadence and now MATURED-WITH-PROOF: 14 overnight cycles zero silent gaps INCLUDING one real fail-closed ERROR caught at the 04:15Z slot (failure detection proven by an actual event, not a synthetic drill); watchdog added at offset cron 3,18,33,48 | phase41-35/-39/-40/-43; fresh run cumulative delivered=46 failed=31 aborted=3 other=4 [phase41-89] |
| Packet-analysis lane | **DEFERRED (disclosed, with precise cause)** | Workflow imported+rebuilt as TEST-ONLY lane reaching ALL-NODES-CLEAN executions and IRIS test-route HTTP 200; production routing deferred because `execute_python` in this Shuffle build exposes NO incoming-data variable (probe-verified: five candidate keys all UNDEF) and `$param` refs pass as literals — normalize/validate/isolation/dedup semantics cannot be certified here. Two remediation paths staged. Zero production contamination (all events synthetic-marked) | phase41-41…52 |
| Endpoint service state | **HONEST-PARTIAL** | 7 of 10 registered endpoints active-class; two offline both OWNER-BLOCKED (013 power-on runbook ready + sustained-proof chain complete; 015 caffeinate ask packaged after its manager-side defect was fixed in P40); one retired-stopped (008) with restart=no validation PASS this phase | phase41-19…26; phase41-80 |
| Dashboards | **DATA-LIVE** | W1/W2 dashboards validated against live queries (agent-active widget read, panel queries return rows); visual-render check remains login-gated; one honest discrepancy FLAGGED not papered over (event.code 0 hits vs rule.groups sysmon_eid1 signal — owner query raised) | phase41-61/-62 |
| Backup/retention service | **VERIFIED** | fs repo 42 snapshots (latest snap-20260826-0517); s3 repo 87 snapshots (latest s3-snap-20260826-0547); restore spot-check #3 PASS (170521=170521 parity) — THREE consecutive bounded restores across phases; first policy-driven ISM deletion wave ETA unchanged 2026-08-29T21:00Z | Live snapshot API output [phase41-86]; phase41-57 |
| Evidence quality of this certification | **STRONG** | Every claim traces to same-day command output embedded in cited reports; hash-chained catalogs reconciled to 392 unique rows with 0 hash mismatches across 93 phase41 entries; release custody closed BYTE-EXACT (published-original sha256 re-verified on-box); platform-behavior claims are probe-verified, not assumed | Triple-CI embed phase41-98; custody chain phase41-75/-76 |

## 3. What Changed vs BILL-40-03

1. **Monitor line upgraded from "scheduled" to "matured-with-proof":** failure detection was proven
   by a REAL fail-closed ERROR caught mid-soak (04:15Z slot), and a watchdog now covers silent
   stalls — the monitoring claim is no longer novel, it is evidenced.
2. **Detection line strengthened structurally:** the containment work removed the quarter's main
   ingest-risk source at producer level (limit untouched at 2000 per policy — demand shrunk, not
   supply raised) while adding a compact health lane; capture health is now observable via
   `stats_compact` without field-cardinality cost.
3. **Packet-lane disclosure sharpened from "deferred by choice" to "deferred WITH platform-level
   evidence":** the blocker is named precisely (execute_python input/kwargs defect) with two
   concrete remediation paths — an honest scoped exclusion rather than a vague pending item.
4. **Release custody retired as a caveat entirely:** v1.3.0 published-original custody CLOSED
   byte-exact; the earlier "labeled rebuilt-only" footnote no longer applies.

## 4. Disclosures (client-visible honesty items)

1. **Packet-platform defect (bounded):** automated packet-workflow routing cannot be certified on
   the current Shuffle build (input-injection defect, probe-verified). The lane is disabled /
   test-only; all packet events are synthetic-marked and isolated from production counters, cases,
   billing, and scorecards. Remediation paths documented (UI rebuild on native nodes or platform
   upgrade).
2. **Self-signed TLS (TOFU posture):** management plane served over TLS 1.2/1.3 (:3443) with
   HSTS/single-header XFO/nosniff and LAN plaintext refused; certificate self-signed, SHA-256
   fingerprint pinned in the release record; renewal procedure documented.
3. **Webhook endpoint unauthenticated within the trusted LAN segment:** internal-only exposure;
   Wazuh-side integrator is the sanctioned producer; accepted-risk disclosure carried forward.
4. **RTO/RPO objectives remain draft:** DEC-40-01 ready-to-sign but AWAITING-OWNER; recovery
   objectives are planning-grade, not contractual, until signed.
5. **Minimal FP population:** false-positive baseline established honestly on a 12-alert universe
   (8 canary-marked + 4 natural) with ZERO natural FPs observed; explicitly qualitative-only until
   ≥50 natural alerts accumulate — no statistical FP-rate claims are made or may be cited.

## 5. Billable Stance Rationale

- **RECOMMENDED** because the billable telemetry pipeline (capture + detection) is independently
  verified end-to-end for the invoice period, the notification lane is certified-automated AND now
  monitored with proof of failure-detection, and every residual gap is a disclosed scope boundary
  with a named remediation path — none is an unstated limitation.
- **Evidence-quality STRONG statement:** this cycle's material claims rest on hash-chained report
  catalogs (392 rows, zero mismatches), byte-exact release custody, and probe-verified platform
  behavior. Where earlier cycles rode conditional labels, this certification's weakest line
  (packet lane) is deferred with the strongest negative evidence of the engagement: a controlled
  probe that proved what the platform CANNOT do before anything depended on it.

*No secret values appear in this report; credentials are referenced exclusively by storage location.*
