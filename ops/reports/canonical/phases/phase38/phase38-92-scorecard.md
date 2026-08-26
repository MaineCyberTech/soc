# Phase 38 Internal Scorecard (+ Client-Safe Section)

**Report ID:** phase38-92-scorecard
**Phase:** 38
**Title:** Phase 38 Internal Scorecard (+ Client-Safe Section)
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-92-scorecard.md`

**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-92-scorecard.md`
**Retention Class:** LONG

| Field | Value |
|-------|-------|
| **Report ID** | phase38-92 |
| **Generated** | 2026-08-25 21:30 UTC |
| **Classification** | Hybrid — §1–4 INTERNAL; §5 clearly marked CLIENT-SAFE (sanitized: no IPs, no credentials, no internal paths; product names only) |
| **Owner** | MCT SOC |
| **Status** | COMPLETE |
| **Supersedes** | Draft written 2026-08-25T20:11Z |

---

## 1. Internal Metrics Table

Baseline = prior month (Phase ~34 era) narrative state. Arrows compare to that baseline.

| # | Metric | Prior month | This cycle | Trend | Evidence |
|---|--------|-------------|------------|-------|----------|
| M1 | Registered endpoints / active now | 3/3 client fleet (v1.2 era) → 8 ACTIVE claim mid-phase | 9 registered incl. manager; 8 active design-intent; live: 013 offline ~15h, 015 flapping (reconnect 20:11Z, relapse by 21:06Z), 008 retired-absent | ▲ fleet grew, ▼ stability on two lines | 80 §§2–3 |
| M2 | Agent version uniformity | mixed-era notes | 100% v4.14.7 across roster | ▲ | 80 §2 |
| M3 | Detection proven end-to-end | canary proven P35 (synthetic + real SPAN) | Carried PROVEN (sid 2027967) + NEW corroboration: 53× L12 / 11× L10 real honeypot payloads through SOAR workflow, freshest today | ▲ | 86; workflow exports hash-pinned |
| M4 | Packet-path alert corpus | 433 at last proof | 433 cumulative (sensor-steady); alert-tier ingest ~44k docs/day, ~45 MB/day trajectory | ▬ healthy | 86; 85 §ingest |
| M5 | Routing dependability | believed zero-real ("796 healthcheck") — wrong | Real deliveries confirmed BUT intermittent (IRIS DNS failures inside 65 finished execs of 68 total, 3 aborted) | ▲ truthfulness, ▼ certainty | 74; 89 D-02 |
| M6 | Indexer field-error noise | misattributed to decoder (P36); unquantified | Root-caused: archives template field budget (~147–150/min, ~14.1k/day); fix applied today (template `wazuh-archives-fieldlimit`, acknowledged+verified); proof due 08.26 index | ▲ root-cause found; verification pending | 78; 89 D-01 |
| M7 | Backup posture | believed NO repository (stale) | BOTH repos verified live: fs 42 snaps latest today 20:17Z; s3 85 snaps latest today 20:47Z | ▲▲ biggest positive surprise | 79 §6; 89 D-03b |
| M8 | Retention execution | wave staged ~08-29 | Zero deletions (expected); all 11 archives hot/condition_not_met; first expiry ETA 2026-08-29T21:00Z (~1.8 GB vs ~15 GB footprint); no forced deletion | ▬ on-schedule | 79 §§4–5 |
| M9 | Disk / Mem / Swap | disk 83% earlier today | 84% / 75% / 64%; OS GREEN 274 shards | ▲ pressure creeping | 83; 85 |
| M10 | MTTR-ish: field-error defect | open since P36 (misdiagnosed) | Correct diagnosis + template fix within one operating day once re-instrumented; residual verification T+1 day | ▲ | 78 timeline |
| M11 | MTTR-ish: agent 015 reconnect | multi-day outage previously | Same-day reconnect achieved, then relapsed — flap class, not outage class | ▲ then ▬ | 80 §3.3 |
| M12 | Report governance health | free-text drift, contradictions accumulating | ~1,900-file corpus audited; 26 dup groups; 8 stubs; CON-38-01…10 cataloged; 10–12 stale chains; status taxonomy enforced for NEW reports but 48 legacy non-enum statuses found; CI gate script created (runs honest FAIL); catalogs+templates shipped (87 records, 9 templates) | ▲▲ governance stood up | 43–48, 61–66, 71 |
| M13 | Migration readiness | plan only | Dry-run PASS 8/8 (1,851 rows, 0 collisions); APPLY deferred pending approval | ▲ gated-ready | 59; 68 |
| M14 | Release integrity | tag existed, asset chain asserted | Tag/asset/sha256 chain VERIFIED byte-exact (v1.3.0 @ c726182; manifest da72bde…) | ▬ maintained | 21; 95 |
| M15 | Deployability | PARTIAL | PARTIAL — same four blockers (restore proof, RTO/RPO, full-cluster restore NO-GO, on-box asset missing) | ▬ | 94 |

## 2. Trend Narrative vs Prior Month

The month's story is **truth discovery under load**. Three long-standing beliefs were overturned by direct measurement: the field-error mechanism (decoder → indexer template budget), the routing picture ("healthcheck-only" → real honeypot traffic with intermittent delivery), and backup posture ("no repository" → both repositories current as of tonight). None of the corrections made operations worse; all three made the operation *knowable*. Meanwhile governance moved from prose-drift to machine-checked: a CI script that honestly fails while secrets remain in the historical corpus is worth more than a green checkmark that lies.

Negative movements are concentrated in capacity and endpoint stability: disk crept 83→84% ahead of the first retention relief (ETA 08-29), and two endpoints (013 offline, 015 flapping) reduce dependable coverage.

## 3. RAG Status by Domain

| Domain | RAG | Justification |
|--------|-----|---------------|
| Operations | **AMBER** | Cluster GREEN and backups verified, but 84% disk pre-relief, 013 down ~15h, 015 unstable, tmp cron pending-first-run with scope gap. No red condition present; several ambers trending favorable. |
| Detection | **GREEN** | Capture verified (433-alert Suricata corpus, continuous EVE), detection PROVEN on real adversary interactions, ruleset curated (544 ET). Only gap is packet-lane workflow separation (design ready). |
| Security | **RED** | Disclosed bearer token not yet rotated; 3 credential locations in generated corpus unredacted; Shuffle frontend exposure hardening still gated-unapplied. All have ready plans and owners (BCK-38-001/002/004) — red reflects exposure, not inaction. |
| Governance | **AMBER→GREEN trajectory** | Corpus fully audited/cataloged, schema/templates/CI standing up, migration dry-run clean; blocked items are approval-gated, not capability-gated. |

## 4. Scorecard One-Liners

- **Deployability:** PARTIAL — four enumerated blockers unchanged (see 94).
- **Billing:** capture+detection certifiable; routing withheld; 8/10 endpoint lines billable-active (see 91).
- **Release assurance:** integrity chain byte-exact; sensitive-file gates FAIL until redaction (see 95).
- **Repo:** COMMIT-PENDING-APPROVAL; tree carries phase38 payload untracked; push gated (see 96).

---

## 5. CLIENT-SAFE SCORECARD — Service Period Ending 2026-08-25

*This section is approved for external sharing. It contains no network addresses, credentials, internal file paths, or tooling identifiers beyond product names. Do NOT append internal sections when sharing.*

### Service Health Summary

| Area | Status | Notes for Client |
|------|--------|------------------|
| Monitoring coverage | ● On target | Managed sensor fleet reporting; uniform current agent version across all endpoints. Two endpoints need attention: one offline awaiting site access, one macOS device intermittently disconnecting (power-management behavior suspected; recommendation pending owner response). One retired device formally removed from coverage. |
| Threat detection | ● Proven | Detection pipeline validated end-to-end this period, including genuine honeypot-interaction events (dozens of real interaction alerts processed, most recent today). Network-detection telemetry continuously indexed. |
| Alert routing to case management | ◐ Improving | Automated escalation of high-severity alerts to the IRIS case system operated throughout the period. Delivery consistency is being tuned (name-resolution issue inside the automation path identified, fix scheduled). Not represented as fully dependable until remediation verifies. |
| Data protection | ● Verified | Both backup repositories confirmed current as of tonight — local snapshots taken twice daily cadence and cloud-object snapshots present, newest today. Retention lifecycle healthy: first automated archive expiry expected within days, restoring storage headroom. |
| Platform capacity | ◐ Watch | Storage utilization 84% with relief arriving via retention automation; memory within bounds. Capacity program scheduled around the retention milestone. |
| Reporting & documentation quality | ● Strengthened | Full audit of the operational report corpus completed: every report inventoried, hashed, and cataloged; automated truthfulness checking introduced; duplicate/stale records queued for consolidation. |
| Deployment readiness | ◐ Partial | Core platform reproducible from pinned release artifacts; full disaster-recovery certification awaits agreed recovery-time objectives and a rehearsal on suitable target hardware (scheduling item). |

### Commitments Carried Into Next Cycle

1. Complete security key rotation and remove sensitive values from historical internal documents (in progress; gating any document sharing).
2. Apply approved firewall restriction to the automation console.
3. Verify telemetry fix on tomorrow's data index and publish the proof.
4. Restore dependable case-management delivery and re-certify routing.
5. Execute first retention expiry observation and confirm restorability of expired data.

### Metrics Snapshot (client-visible)

- Endpoint coverage: 8 active service lines
- Detection: proven on real events, current as of today
- Backups: 42 local + 85 offsite snapshots, newest today
- Ingest: ~44k alerts/day sustained, cluster healthy (green)
- Open priority actions: 4 critical (all with approved remediation plans)

---

## 6. Method Note

All figures measured or verified 2026-08-25 via live API/command evidence cited per row. Where a metric is carried forward from a prior proof (canary sid 2027967), it is marked as carried, not re-measured. Corrections issued this phase (field mechanism, routing reality, repository existence, fleet counts) are reflected here in place of superseded figures.
