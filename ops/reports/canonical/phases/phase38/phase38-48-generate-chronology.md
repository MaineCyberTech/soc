# Phase 38 Authoritative Chronology (P13 → P38)

**Report ID:** phase38-48-generate-chronology
**Phase:** 38
**Title:** Authoritative Timeline — Major Changes, Decisions, Regressions, Incidents, Releases, Carryover
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-48-generate-chronology.md`
**Retention Class:** LONG
**Supersedes:** `phase38-12-phase-chronology.md` (retained as draft history)
**Sources:** git log/tag dates (`/opt/mct-security-stack`, HEAD 7bd3b82), corpus mtimes, verification reports phase38-21..30
**Owners:** ["ops-reports-owner"]

---

## 1. Reading Guide

Dates come from git commit/tag timestamps where available; entries marked *(inferred)* derive from report mtimes without a direct commit anchor. Releases observed: v1.0.0 (2026-08-16), v1.1.0 (2026-08-19), v1.2.0 (2026-08-22), v1.3.0 (tag 790968b8, 2026-08-24).

---

## 2. Timeline

### 2026-08-16 — P13/P14: externalization begins
- GitHub publish, CI results, staged review; LevelIO script refactor; Windows FP tuning; Proxmox capacity watch *(report mtimes 03:28–05:xx)*.
- **v1.0.0 tagged** (2026-08-16). Phase 14 adds billing baseline, client013 baseline/SCA/Sysmon validation, DR S3 risk review, first GitHub release workflow.
- Note: Phase 1 has **no final operator report** (MIS-38-01) — trail starts effectively here.

### 2026-08-16→17 — P15–P18: Zeek era and noise control *(P15–P17 inferred from commit clustering)*
- P15–P17: architecture risk register, whitelabel wiring, agent buffer tuning, suppression tests.
- P18 (commits 37096f4…eba217b, Aug 17): Zeek decoder extended; zeek rule pack v1 deployed; Suricata eve path fixed (symlink + hourly updater); syslog 15140 allowlist (operator-approved client subnet 192.168.111.0/24); Redis loop noise fix (rule 120537 L5→L3).
- **Incident (P18.15): macOS telemetry CRITICAL flood** — 1.4M docs/day, 204 queue-full events/24h; agent-local fix documented.
- Index noise review: archives ≈10GB dominant storage consumer; ILM action plan seeded (later becomes ISM policy line).
- Shuffle/IRIS packet routing mapped but disabled pending noise validation.

### 2026-08-19 — P19–P21: integrations, hygiene, **v1.1.0**
- Commits ebd9463…171d837: packet/flow/macos/syslog docs, Zeek rules v2.2, retention runbook, billing readiness.
- Credential cleanup (fail-fast guards), CI false-pass fix, unpinned-image coverage extension, SECRET-HANDLING doc.
- **v1.1.0 released** (release object + asset uploaded).

### 2026-08-22 — P22–P24: remediation, fleet restoration, **v1.2.0**
- P22 (fd1cb3e): credential env-abstraction, image pinning policy, retention ISM fix attempt, source-of-truth cleanup.
- P23 (baf8b95…143e81d): endpoint remediation prep, disk relief 85%→83%, swap root-cause work, doc governance banners (122 docs), deep-dive audit, action-item ledger.
- P24 close (52c3e91…637fca0): **fleet restored — 013 reconnected this window**, evidence archive 22/22, RMM-safe Sysmon tuning suite (check/apply/rollback), canonical manager config.
- **v1.2.0 released** (release object + asset verified).

### 2026-08-22→24 — P25–P30: routing enabled, guardrails, releases, memory stabilization
- P25 (96970c4, f1fa2fd, 508b793): **Zeek Class A routing ENABLED (approved)** — Wazuh integration rule_id 122001-122003 → Shuffle webhook → IRIS; synthetic tests FINISHED; archives aligned to 14d; v1.2.0 verified. *This is the origin of the real Shuffle execution stream later confirmed.*
- P26 (cb8ca76): snapshot restore drill PASSED; Zeek hard guardrails (rate-limit + kill switch tested); retention deletes observed under then-active mechanisms (disk 79.5%). *Note: distinct from current ISM policies which have zero deletions (phase38-44 CON-38-10).*
- P27 (9f09dda): multi-index restore drill PASSED; Shuffle backup + guardrail failover tested; plateau ~81%.
- P28 (21ba3d1): consolidation audit stack; **incident: guardrail exec-bit — cron down ~40h, closed**; DR architecture; **full-cluster restore declared NO-GO**; fresh-target dry-run gates PASS.
- P29 (bbe14c8, c726182, 8e37ae9): image digest pinning (8 refs) prepared + APPLIED (approved); **v1.3.0 released** — tag 790968b8, release id 375979989, asset sha256 da72bde4; indexer rotation attempted and rolled back cleanly inside maintenance window; SO VM down + swap pressure recorded.
- P30 (0c24353): memory stabilization — stale-swap diagnosis, **swappiness 60→10 applied**; SO postmortem blocked by PVE creds; deployability PARTIAL (target NO-GO).

### 2026-08-24→25 — P31/P31v2: packet pipeline pivot, /tmp incident
- P31 (43c4bf1): **SO packet scanning RETIRED** (healthcheck 0 FAIL, CI PASS, forward disabled); **Suricata-minimal selected** (31MB / 0 drops < 2GiB ceiling, SPAN-gated); CI hardened (SHA-pinned checkout + image/exec-mode gates).
- P31 SPAN benchmark PASSED (98d5baf): Suricata 32MB < 2GiB, 0.79% CPU, 0 drops over 16.5K pkts, 0 FPs.
- P31v2 (91f6789): SPAN-live pipeline proven end-to-end (Suricata + agent 016 EVE ingest).
- **Incident: /tmp 100% full** — fixed via docker exec restore path restored.

### 2026-08-25 (early hours) — P32–P33: detection gate closes, live wiring
- P32 (49dfdda): detection value gate CLOSED — ET ruleset sid 2027967 fired offline + Wazuh suricata decode proven via logtest; observe-only live posture; /tmp safe hardening (~6%).
- P33 (79f6cbe): live alert wiring operational (sensor timer + core cron, 7 checks HEALTHY, state-dedup); canary routing gated; /tmp scheduled control.

### 2026-08-25 (evening) — P34–P35: canary proof, routing still deferred
- P34 (3d4d072, dca1691): observe window finalized (17h / 8.3M pkts / 0 drops / 529 rules / 74MB); **canary SID 2027967 APPROVED + designed**; agent 016 eve.json forwarding applied; production routing deferred (SPAN read-only constraint at the time).
- P35 (cbcca53): **canary E2E PROVEN** (synthetic + real SPAN alert); detection pipeline through OpenSearch confirmed; Shuffle routing deferred again (UI-gated); retention wave staged (~08-29); endpoint reconciliation; alert inventory.

### 2026-08-25 ~18:51–19:22Z — P36: incident-heavy remediation week compressed
- Disk incident + ISM policies attached (`wazuh-archives-14d` → archives; `wazuh-retention` → alerts); relief forecast "~7.9GB" authored (later contradicted: computable ≈3.76GB, ceiling ~7.5GB — CON-38-06).
- Shuffle investigation: password reset resolved auth; frontend discovered EXPOSED 0.0.0.0:3001.
- **Field cardinality fix applied: decoder_order_size=512** — later shown misattributed (signature is indexer-side "Limit of total fields [1000]"; knob irrelevant) — the cycle's principal regression-in-analysis (CON-38-01/02).
- Endpoint recovery push (013/015/016 statuses), /tmp cleanup, audits.

### 2026-08-25 ~19:31–19:43Z — P37: evidence, exports, honest negatives
- Workflow inventory + **exports captured** (with trailing-comment defect now flagged, MIS-38-06); execution inventory (~796); packet workflow create attempted; routing decision maintained deferral; **field 522-vs-512 investigation opened doubts**; stats minimization; agent 014 retired; tmp thresholds; audits; final (81).

### 2026-08-25 ~19:56–20:50Z — P38: verification and correction cycle
- Full claim verification (21–30) against live system; scan suite (31–42).
- **Corrections established:** field-error true signature/mechanism (8,746 lifetime, ~150/min, indexer mapping limit); Shuffle real activity discovered (**68 FINISHED real-payload runs of wazuh-high-severity-to-iris**, OpenCanary L12, newest today); fleet canon **8 ACTIVE** (015 Julians-Air reconnected today; 013 disconnected; 008/014 retired-out); release asset hash VERIFIED byte-exact but not persisted on-box; snapshot repo absent (`repository_missing_exception`); plaintext credentials found in 3 generated reports; corpus census reconciled to class+scope convention (1,888 .md pre-write).
- This report set (43–54) written as the corrective layer.

---

## 3. Release Series

| Version | Date (tag) | Anchor commit/release | Notes |
|---|---|---|---|
| v1.0.0 | 2026-08-16 | P13/14 era | Initial tagged baseline |
| v1.1.0 | 2026-08-19 | release object + asset uploaded | Hygiene/CI-hardened cut |
| v1.2.0 | 2026-08-22 | release object + asset verified | Fleet-restored cut |
| **v1.3.0** | 2026-08-24 | tag 790968b8; release id 375979989; asset sha256 da72bde4 (byte-exact VERIFIED 08-25; not archived on-box) | Current; HEAD 7bd3b82 builds on it |

---

## 4. Incidents Register (chronology extract)

| Incident | Phase | Resolution | Residue |
|---|---|---|---|
| macOS telemetry flood (1.4M docs/day) | P18 | Agent-local fix documented/applied | Noise classes monitored |
| Guardrail exec-bit → cron down ~40h | P28 | Closed | CI exec-mode gate added; audit timed out this cycle (MIS-38-10) |
| SO VM down + swap pressure | P29 | Recorded; swappiness fix P30 | Memory watch continues (swap 64%) |
| /tmp 100% full | P31v2 | docker exec restore path | Cron verbatim present; 21% now |
| Field-error misdiagnosis (decoder knob) | P36→P38 | Corrected P38 | Errors still flowing (~150/min) until ACT-38-002 lands |
| Transient OpenSearch Unauthorized (R-18) | P38 session | Retry succeeded | Monitor recurrence |

---

## 5. Unresolved Carryover into Phase 39+

| Item | Since | Canonical tracker |
|---|---|---|
| Shuffle exposure hardening | P36 discovery | ACT-38-001 |
| Token rotation | P38 disclosure | ACT-38-003 |
| Field-limit template fix | P36 (misdiagnosed) → P38 (corrected) | ACT-38-002 |
| Packet workflow | P37 attempted | BCK-38-101 |
| Production routing formalization | P33 gating chain | BCK-38-102 |
| Snapshot repository | pre-P26 assumption broken | BCK-38-103 |
| Agent 013 recovery | P32 chain | BCK-38-104 |
| First ISM wave evidence | P36 staging | BCK-38-105 (2026-08-29) |
| Corpus migration + stub cleanup | P38 design | BCK-38-106/107 |
| RTO/RPO definition | absent through P37-78 | REM-38-11 (phase38-54) |
