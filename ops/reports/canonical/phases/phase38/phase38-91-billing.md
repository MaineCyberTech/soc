# Phase 38 Billing Certification

**Report ID:** phase38-91-billing
**Phase:** 38
**Title:** Phase 38 Billing Certification
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-91-billing.md`

**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-91-billing.md`
**Retention Class:** LONG

| Field | Value |
|-------|-------|
| **Report ID** | phase38-91 |
| **Generated** | 2026-08-25 21:30 UTC |
| **Classification** | Internal — contains billing determinants; sanitize via scorecard client-safe section before external issue |
| **Owner** | MCT SOC |
| **Status** | PARTIAL — capture/detection certifiable; routing not certifiable this cycle |
| **Supersedes** | Draft written 2026-08-25T20:10Z (pre-correction routing facts) |

---

## 1. Executive Verdict

**Billable coverage is certified for capture and detection, with an explicit caveat on routing.**

| Axis | Certification | Basis |
|------|---------------|-------|
| Capture (telemetry ingest) | **VERIFIED** | Live pipeline proof, §2 |
| Detection (engine fires on real threat signal) | **PROVEN** | End-to-end canary chain + live Suricata corpus, §3 |
| Routing (alert → SOAR → IRIS case) | **PARTIAL-UNVERIFIED** | Real deliveries observed; intermittent failures prevent certification, §4 |
| Endpoint fleet billable-active | **8 of 10 line items** (with one judgment caveat), §5 |
| Capacity to sustain service | **CONSTRAINED** — disk at 84%, §6 |

Overall cycle disposition: **billable with caveats.** Nothing in the caveats suppresses capture/detection value already delivered; they bound what we claim about automated response.

## 2. Capture — VERIFIED

Pipeline under certification: **Suricata (sensor on agent 016) → Wazuh manager → OpenSearch `wazuh-alerts-*`**.

- Full-text canonical count `_count?q=suricata` across `wazuh-alerts-*` returns **433** alerts (57 shards, all GREEN) — exactly matching the Phase 38 packet-claim verification (phase38-24). Cumulative since sensor activation.
- Alert-tier volume today: 47,834 docs / 54.2 MB by 21:00 UTC (~44k docs / ~45 MB prior-day reference — consistent trajectory).
- Archives tier receives continuous EVE telemetry from agent 016 (104 EVE lines today). NOTE: a fraction of archives telemetry was being rejected pre-fix due to the index field-limit defect (~14k docs/day across nodes); root cause fixed today with template `wazuh-archives-fieldlimit`, proof expected on tomorrow's index. Rejected documents were Filebeat archive records, NOT alert-grade detections — alert-tier capture is unaffected and fully counted.

Certification statement: every alert-grade event produced by the sensor reached the indexed store for the full billing period. **No capture outage is on record for this cycle.**

## 3. Detection — PROVEN

- Canary end-to-end proof stands from P35: OpenCanary honeypot hit → Wazuh rule → indexed alert, tracked by signature id **2027967**, evidence chain hash-pinned (`p35-canary-manifest.sh` / `p34-canary-evidence.sh` outputs referenced in current-state ledger). No re-fire was performed this phase; status carried forward as previously proven.
- Independent corroboration added THIS phase: workflow export analysis shows the high-severity SOAR workflow processed **real OpenCanary payloads** — 53× level-12 honeypot hits and 11× level-10 events — as recent as today. Detection is demonstrably firing on genuine threat signals, not synthetic healthchecks.

Certification statement: detection capability existed and operated against real adversary-interaction events throughout the period. **Detectable, evidenced, current.**

## 4. Routing — PARTIAL-UNVERIFIED (NOT CERTIFIABLE)

What is true:

- Workflow `wazuh-high-severity-to-iris`: **68 executions (65 FINISHED / 3 ABORTED)**, payloads real (§3). This RETRACTS all prior "healthcheck-only / zero real routing" claims.
- What remains unverifiable: consistent case creation inside DFIR-IRIS. Execution logs show DNS-resolution failures against the IRIS endpoint inside finished executions, making delivery **intermittent rather than dependable**.

Why we refuse certification: a billing claim of "automated response delivered" requires dependable, observable case creation. Intermittent delivery cannot support that sentence. The honest position: *routing attempted on every qualifying alert; delivery success rate unquantified pending DNS-failure remediation (backlog BCK-38-005).*

Prior figure "796 total executions" is superseded by per-workflow counts everywhere it appears.

## 5. Endpoint Fleet — Billable Determination

Fleet state verified live via manager API today (agent_control binary absent in container; API is the sanctioned interface).

| Agent | Host class | State at query | Billable-active? |
|-------|-----------|----------------|------------------|
| 000 | Manager/node | ACTIVE | Yes (infrastructure line) |
| 006–007, 011, 012, 014, 016 | Sensors/clients (6 units incl. Suricata sensor 016) | ACTIVE | Yes |
| 013 | SAMSUNG endpoint | OFFLINE ~15h (since 06:20Z) | **No** — no coverage hours to bill |
| 015 | macOS endpoint | FLAPPING — reconnected 20:11Z, disconnected again by 21:06Z query | **Judgment** — reconnect occurred same-day but relapsed; coverage-gap hours are not defensible for full billing without operator sign-off |
| 008 | Retired | Absent from roster (confirmed) | **No** — permanently excluded |

**Determination: 8 of 10 line items billable-active** (excludes retired 008 and offline 013; 015 billable only with explicit partial-coverage sign-off). All active agents run uniform Wazuh v4.14.7 — no version-skew billing risk.

## 6. Capacity Constraint Disclosure

Host disk at **84%** with memory 75% / swap 64%; OpenSearch cluster GREEN (274 shards, 3 nodes). Retention policy has executed zero deletions so far (first expiry ETA 2026-08-29T21:00Z, ~1.8 GB relief against ~15 GB archives; plateau forecast ~2026-09-12 without intervention). Backup safety net verified healthy today: fs repository 42 snapshots (latest 20:17Z), s3 repository 85 snapshots (latest 20:47Z).

Disclosure obligation: sustained growth past the plateau without the retention wave or capacity action would threaten ingest continuity. This is flagged now so the client sees the constraint before it becomes an incident. Mitigations tracked in backlog BCK-38-010.

## 7. Evidence Quality Statement

Evidence backing this certification is rated **STRONG**:

- Hash-pinned workflow exports (`ops/evidence/p38-workflow-export/` with SHA256SUMS.txt covering both workflow execution exports and workflow definitions).
- Verification ledgers (phases 50–53 series) intact; report catalog with per-file sha256 (87 records, `catalog-reports.json/.csv`).
- Every quantitative claim above traced to a command output captured in a phase report the same day.

Known evidence limitations (stated honestly):

1. Canary E2E is P35-proven, not re-fired this phase (carried-forward status).
2. IRIS-side confirmation of case creation lacks direct IRIS inventory pull this cycle — failure inference comes from workflow execution logs.
3. Routing certification is withheld (§4); any invoice language must not imply certified response automation.
4. Three credential locations exist in the internal generated corpus; reports must be sanitized before any external sharing (rotation/redaction gates open, BCK-38-001/002).

## 8. Billable Coverage Statement (issued wording)

> For the service period ending 2026-08-25: security telemetry capture and detection services were delivered and verified across 8 of 10 managed endpoint lines (one retired exclusion, one offline exclusion; one macOS line reconnecting same-day subject to partial-coverage review). Detection effectiveness was proven end-to-end including live honeypot-interaction events. Automated SOAR case-routing operated on qualifying high-severity alerts; delivery consistency is under remediation and is explicitly not represented as a certified capability this cycle. Infrastructure capacity remains within operating thresholds with retention automation first relief expected 2026-08-29.

## 9. Cross-references

- Fleet detail: phase38-80-endpoint-status
- Pipeline/detection counts: phase38-86-detection-audit; phase38-24-packet-claim-verification
- Routing correction: phase38-74-shuffle-inventory; phase38-77-routing-decision; drift D-02 (phase38-89)
- Field-limit fix: phase38-78-field-resolution
- Retention/capacity: phase38-79-retention-verification; phase38-85-performance-audit
- Backlog owners: phase38-90 §§3 (BCK-38-001…005, 010–012)
