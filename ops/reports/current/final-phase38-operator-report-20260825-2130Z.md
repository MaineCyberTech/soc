# Final Phase 38 Operator Report

| Field | Value |
|-------|-------|
| **Report ID** | final-phase38-operator-report |
| **Generated** | 2026-08-25T21:30Z |
| **Classification** | Internal / Operational summary |
| **Owner** | MCT SOC |
| **Verdict** | **PARTIAL overall** — major progress, gated completions |
| **Companion reports** | phase38-90 (backlog) · 91 (billing) · 92 (scorecard) · 93 (monthly) · 94 (deployability) · 95 (release) · 96 (repo) |

---

## 1. Executive Verdict

**PARTIAL overall — the most consequential operating day of the phase.** Three long-standing wrong beliefs were corrected by direct measurement and one of them was fixed on the spot:

- **Field-error root cause found AND fixed (proof pending).** The ~147–150/min indexer rejections (~14k/day) on archives indices are an index-template field budget (`Limit of total fields [1000]`) hitting Filebeat docs — not the P36 decoder theory. Composable template `wazuh-archives-fieldlimit` (limit 2000 + carried ISM setting, priority 320) applied today: PUT acknowledged:true, GET verified. Affects new daily indices only; proof lands with tomorrow's `2026.08.26` index.
- **Corpus audited and cataloged.** ~1,900 md files inventoried; 87 generated reports hash-cataloged; contradictions CON-38-01…10 registered; status taxonomy + 9 templates shipped; report-CI script created and running honest-FAIL until credential redaction completes.
- **Snapshot repositories verified live** — fs repo 42 snapshots (newest today 20:17Z), s3 repo 85 snapshots (newest today 20:47Z). Retention deletions are restore-safe.
- **Still gated:** token rotation, frontend hardening, migration APPLY — all plan-ready, all awaiting approval.

Nothing regressed operationally today: cluster GREEN (274 shards), alerts flowing (~44k docs/day tier), backups fired twice today.

## 2. Corrections Table (claims retired this phase)

| # | Prior claim | Status | Corrected understanding | Evidence |
|---|-------------|--------|-------------------------|----------|
| C-1 | Field errors caused by decoder-side `decoder_order_size` (P36 attribution) | **RETRACTED** | Indexer-side template field budget on `wazuh-archives-*`; fix = index template, applied today | phase38-78 §1–3; drift D-01 |
| C-2 | Shuffle executions are "healthcheck-only, zero real routing" (796 total figure) | **RETRACTED** | High-severity workflow: 68 executions (65 FINISHED / 3 ABORTED) carrying REAL OpenCanary payloads (53× L12, 11× L10), freshest today; delivery intermittent due to IRIS DNS failures inside finished execs | phase38-74/86; hash-pinned exports; D-02 |
| C-3 | "No snapshot repository registered" (`repository_missing_exception`) | **STALE (drift D-03b)** | Both repositories exist, healthy, current as of tonight | phase38-79 §6 |
| C-4 | Fleet narrative "8 ACTIVE" (flat) | **UPDATED** | Registered(9)/active-at-design(8)/live triple: 013 offline ~15h; 015 flapping (reconnected 20:11Z, relapsed by query time); 008 retired-absent; uniform v4.14.7 | phase38-80 §§2–3 |

## 3. What Changed Operationally Today

1. Archives field-limit template created, applied, verified in cluster state; probe protocol executed and cleaned up.
2. Snapshot posture upgraded from "unknown/missing" to "verified twice-daily-current" via live repository inspection.
3. Routing truth established from execution exports; billing routing certification explicitly withheld rather than assumed.
4. Report governance stood up end-to-end: catalogs, schema enforcement for new reports, templates, CI gate script (0755).
5. Migration dry-run PASSED (8/8 checks, 1,851 rows, 0 collisions); apply deferred pending approval.
6. Fleet API adopted as the sanctioned agent-control interface (binary absent in container).
7. Zero forced retention deletions performed; first expiry ETA stands at 2026-08-29T21:00Z.

## 4. Risks Register — Top 5

| Rank | Risk | Exposure | Mitigation trajectory |
|------|------|----------|----------------------|
| R1 | Disclosed bearer token treated as compromised while workflows depend on it | Credential abuse → SOAR takeover | Rotate (BCK-38-001); redact 3 leak locations (BCK-38-002); both gate external sharing |
| R2 | Shuffle frontend exposed without TLS/access control (0.0.0.0:3001) | Unauthorized automation access | Gated iptables plan ready (73 §Step1) — BCK-38-004, approval required |
| R3 | Disk at 84% pre-relief; first ISM deletion unproven | Ingest degradation if wave slips past plateau (~09-12 forecast) | Observe 08-29 wave with restore-safe spot check (BCK-38-010); capacity program staged |
| R4 | IRIS delivery intermittent (DNS failures inside 65 finished execs) | Silent loss of case creation on real alerts | Investigate then formalize integration (BCK-38-005/006); routing uncertified meanwhile |
| R5 | Full-system restore never rehearsed; RTO/RPO undefined; release asset not on-box | Recovery objectives unverifiable under incident conditions | Asset→objectives→rehearsal chain defined (BCK-38-009/015; needs adequate target — out-of-scope PVE noted) |

## 5. Domain One-Liners

- **Deployability:** PARTIAL — components reproducible (compose pins verified), backups proven current; full-cluster restore NO-GO, no adequate-target restore proof, RTO/RPO undefined, asset not archived on-box (phase38-94).
- **Billing:** capture VERIFIED (Suricata→016→Wazuh→OS, 433-alert corpus) and detection PROVEN (canary sid 2027967 E2E + real honeypot traffic today); routing NOT certifiable; endpoints 8/10 billable-active lines (excl. retired 008, offline 013; 015 judgment caveat); evidence quality STRONG (phase38-91).
- **Scorecard:** ops AMBER · detection GREEN · security RED (exposure items with ready plans) · governance AMBER→GREEN trajectory; client-safe section published clean (phase38-92 §5).

## 6. Phase 39 Roadmap (prioritized)

**P0 — this week**
1. Rotate Shuffle bearer token; verify old secret dead; re-authenticate workflows (BCK-38-001).
2. Redact the 3 credential locations; re-hash affected reports; refresh catalog; rerun CI to GREEN (BCK-38-002).
3. Verify field-limit fix on the 08.26 archives index (settings + rejection counters flatline) (BCK-38-003).
4. Apply approved iptables hardening for port 3001 with rollback armed (BCK-38-004).

**P1 — next**
5. Root-cause and fix IRIS DNS failures; prove ≥3 consecutive real deliveries; re-certify routing (BCK-38-005).
6. Formalize Wazuh→Shuffle integration config of record (BCK-38-006).
7. Build packet workflow per design 75 + proof criteria 76 (BCK-38-007).
8. Execute corpus migration APPLY after redaction; run link-rewrite and verification (BCK-38-008).
9. Archive v1.3.0 asset on-box (BCK-38-009).

**P2 — scheduled/dated**
10. Observe ISM first deletion 08-29 (+ restorability spot-check) (BCK-38-010).
11. Agent 013 recovery; 015 flap diagnosis with owner contact (BCK-38-011/012).
12. Fix 48 legacy status enums post-migration (BCK-38-013); build W1/W2 dashboards (BCK-38-014).
13. Author RTO/RPO and schedule restore rehearsal on adequate target (BCK-38-015).

**P3 — hygiene**
14. Stub cleanup (8), duplicate collapse (26 groups), missing finals P1/P36 (BCK-38-016).
15. Stale-claim retirement across remaining chains; contradiction dispositions (BCK-38-017).

## 7. Attestation

No secrets appear in this report or its companions; credentials are referenced exclusively by file location. All quantitative statements trace to command outputs captured in same-day phase reports; carried-forward proofs are labeled as such. Commit/push remains APPROVAL-GATED (phase38-96): tree clean at HEAD `7bd3b82`, payload planned as a single logical commit after redaction-before-commit ordering is honored.

*— End of Phase 38.*
