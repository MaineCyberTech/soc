# Phase 38 Risk History

**Report ID:** phase38-17-risk-history
**Phase:** 38
**Title:** Phase 38 Risk History — Risk Register with First/Last References, Status Transitions, and Currency
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T19:56:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/big-pickle
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-17-risk-history.md`
**Retention Class:** LONG

---

## 1. Method

All risk-type statements were harvested from git history (115 commits reviewed), final operator reports, technical reports, and live state. Each risk record: first reference, last reference, status trajectory, owner, mitigations applied, and current currency. Currency values: `STILL_CURRENT`, `SUPERSEDED`, `CONTRADICTED`, `UNVERIFIED`, `RESOLVED`.

Measured corpus signals used: 77 files mention "watermark"; 70 files contain "NO-GO"; 136 files mention "deferred"; 40 files reference the 0.0.0.0:3001 exposure; 54 files reference decoder_order_size.

---

## 2. Prompt-Mandated Key Risks

### R-01 — Disk at 84% with LOW WATERMARK ACTIVE

| Field | Value |
|---|---|
| First ref | P23-era relief work implies prior pressure; explicit watermark language from P36 session ("Disk first observed at 84%", "low watermark 85%") |
| Trajectory | 85% (P23) → 83% relief (`baf8b95`) → 79.5% post-deletes (`cb8ca76`) → plateau 81% (`9f09dda`) → 84% regrowth (P36) → 83-84% now (df re-check) |
| Mitigations | ES snapshot cleanup −4.3G (P16); retention alignment 14d (P25); deletes observed (P26); ISM attachment to all 11 archive indices (P36); expected wave ~7.9GB on **2026-08-29** |
| Owner | opencode/big-pickle (monitoring) + event-driven relief |
| Last ref | Live state today; phase38-01/13 |
| Currency | **STILL_CURRENT** — controlling mitigation is a future dated event; until 08-29 executes, risk stands. Failure mode if wave misses: watermark breach toward 85% |

### R-02 — Field errors unresolved (~100/min)

| Field | Value |
|---|---|
| First ref | P36 field-cardinality baseline series (phase36-29/30): Suricata stats 522 fields > default 256 |
| Peak claim | P36 fix design promised elimination of 15,189 errors via 512 |
| Contradiction | final-phase37 §4 + live state: rate ~100/min, total ~18,849+, restart 19:10Z did not change slope ⇒ **decoder_order_size=512 INSUFFICIENT** |
| Mitigation attempts | CHG-36-03 (applied, ineffective); phase37 field-resolution design exists (options: 1024 vs minimize field sources) |
| Owner | opencode+operator |
| Currency | **STILL_CURRENT and CONTRADICTED-success** — the only risk where an applied remedy provably failed |

### R-03 — Shuffle exposure unhardened (0.0.0.0:3001, no TLS)

| Field | Value |
|---|---|
| First ref | P36 (`b529e3b` exposure change) — exposure itself introduced as operational convenience |
| Corroboration | compose line 21 verified this session; final-phase37 §1 table: EXPOSED / TLS NOT CONFIGURED / hardening PENDING |
| Aggravators | Bearer token recorded in plaintext (live state + phase38 master §2); admin cred rotated but operator rotation pending |
| Mitigations planned | Shuffle hardening plan drafted P37 (`7bd3b82`); backend already internal-only (127.0.0.1:5001 verified) |
| Owner | opencode+operator |
| Currency | **STILL_CURRENT — highest-severity open risk (P0)** |

### R-04 — Agents 013/015 disconnected

| Field | Value |
|---|---|
| First refs | 013: deployed P13, dropped pre-P24, recovered `52c3e91`; 015: reconnect validated `baf8b95`, closed out `cb8ca76` |
| Recurrence | Both disconnected again by P36/P37 — repeat-loss pattern after earlier recovery success |
| Mitigations attempted | recovery strategies + monitoring plan docs (phase36-37…44 series); no automated recovery ("Manual intervention required" per final-phase37 §7) |
| Owner | operator (physical/network possession) |
| Currency | **STILL_CURRENT**; note R-26-01 contradiction in decision ledger (closed-out ≠ gone) |

### R-05 — Deployability PARTIAL / full-cluster restore NO-GO

| Field | Value |
|---|---|
| First ref | P28: "DR architecture + full-cluster NO-GO" (`21ba3d1`) |
| Re-affirmed | P30 "deployability PARTIAL (target NO-GO)" (`0c24353`); carried through every final since; live state concurs |
| Mitigations present | fresh-target dry-run PASS (P28/P30 gates); component drills PASSED (snapshot restore P26, multi-index restore P27, DR S3 P25); guardrail failover proven ×3 |
| Gap | component-level GO does not compose to full-cluster GO; isolated target build stalled at cert/deploy stages (phase30-39…53 series ends NO-GO) |
| Owner | opencode/big-pickle |
| Currency | **STILL_CURRENT** (70 corpus files carry the NO-GO marker family) |

---

## 3. Additional Risks Tracked

| ID | Risk | First ref | Last ref | Status trajectory | Currency |
|---|---|---|---|---|---|
| R-06 | macOS telemetry flood (1.4M docs/day; 204 queue-full/24h CRITICAL) | `3ededdb` P18 | P18 steady-state notes | CRITICAL → fixed via bounded syslog localfile (`7daa759` root fix; `5237db6` steady low) | RESOLVED (watch for regression) |
| R-07 | Archives growth >> alerts (9.3GB vs 2GB; 10GB noise) | `3598ee9` P17 | P36 ISM attach | open → mitigating via RET-36-01 | MITIGATING (folds into R-01) |
| R-08 | Swap pressure / SO VM down | `bbe14c8`,`0c24353` P29/P30 | live swap 64% | swappiness 60→10 applied; host stable; swap usage persists | PARTIALLY_MITIGATED → UNVERIFIED-long-term |
| R-09 | Guardrail exec-bit incident (cron down ~40h) | `21ba3d1` P28 | closed same phase | incident closed; failover re-proven P29 | RESOLVED |
| R-10 | Zeek UDP noise / Redis loop noise | `46a9120`,`c0e203d` P18 | tightened rules | level demotions + rule tightening | RESOLVED |
| R-11 | Syslog allowlist gap (client subnet dropped) | `b2422e8` P17 | `0c9ff5e` allowed | gap closed via operator approval | RESOLVED |
| R-12 | FP suppression mismatch | `fddb6bd` P14 | root cause `762fadf` | worker-node + rule-order cause fixed | RESOLVED |
| R-13 | Level.io deploy fragility (BASH_SOURCE/env lib) | `a201b6d`,`707ea58` P16 | self-contained scripts shipped | fixed pattern documented | RESOLVED |
| R-14 | macOS pkg arch 403 silent failure | `dbe4089` P16 | fixed curl fail-fast | resolved | RESOLVED |
| R-15 | Stale sysmon policy re-application (4.90 copy) | `f773d36` P24 | embedded-overwrite fix | resolved w/ marker verification | RESOLVED |
| R-16 | Canary E2E blocked by SPAN read-only | `dca1691` P34 | proven `cbcca53` P35 | blocked → proven | RESOLVED |
| R-17 | Bearer token plaintext persistence | phase38-00 §2 (first formal flag) | today | open hygiene item | STILL_CURRENT (P0 sub-item of R-03) |
| R-18 | OpenSearch credential auth drift observed this session | phase38-13 F-1 | today | investigation opened | UNVERIFIED/NEW |
| R-19 | /tmp cleanup cron location unprovable from host | phase38-13 F-2 | today | probe inconclusive | UNVERIFIED (control may be silently absent) |
| R-20 | Report corpus debt (empty stubs, dupes, dual headers) | phase38-04/05/06 today | migration plan phase38-59 | catalogued; remediation planned | STILL_CURRENT (P2) |

---

## 4. Status-Change Ledger (risks that changed state)

| Risk | Transition | When | Evidence |
|---|---|---|---|
| R-06 | OPEN→CRITICAL→RESOLVED | P17→P18 | queue-full fix commit + steady-state review |
| R-12 | OPEN→RESOLVED | P14→P14 | same-day root-cause commit pair |
| R-11 | OPEN→RESOLVED | P17.10→P18.08/09 | allowlist approval commit |
| R-16 | BLOCKED→RESOLVED | P34→P35 | forwarding apply then SPAN proof |
| R-09 | OPEN→RESOLVED | P28 | closure in consolidation report |
| R-02 | OPEN→(claimed CLOSED)→REOPENED | P36→P37 | contradiction pair |
| R-04 | RESOLVED(P24)→REOPENED(P36) | fleet history | repeat disconnect |
| R-01 | OPEN→MITIGATING→PENDING-EVENT | P16→P36 | chain of retention decisions |
| R-05 | DECLARED→RE-AFFIRMED×N | P28→today | every final gate table |

---

## 5. Ownership Summary

| Owner | Risks held |
|---|---|
| opencode/big-pickle | R-01 monitoring, R-02 remediation design, R-03 hardening plan, R-05 architecture, R-17, R-20 |
| operator | R-03 UI/config execution + password rotation, R-04 endpoint physical recovery, DF-35-01 webhook config |
| shared | R-02 choice of remedy (1024 vs field minimization), R-08 tuning follow-through |

---

## 6. Cross-Links

- Decision supersessions feeding risk states: see phase38-15 §12 (D-36-01 contradicted; DF-35-01 gating).
- Applied-change effectiveness backing each mitigation: see phase38-16 §2/§3.
- Current-state proof obligations per risk: see phase38-13 claims C-05..C-08, C-12, C-15, C-19..C-21, C-25..C-33.

---

## 7. Findings

1. Five prompt-mandated risks are all STILL_CURRENT; none has been silently retired — good register fidelity.
2. The register's only formal contradiction is R-02, where documentation previously over-claimed success; the reopen was caught within one phase (P37), which validates the cross-report audit loop.
3. Resolved-risk density is highest in endpoint/deployment ergonomics (R-11…R-15) — that class of issue has stopped recurring; current risk mass concentrates in infrastructure capacity (R-01/R-07) and security posture (R-03/R-17).
4. Two brand-new risks surfaced by this phase's own verification activity (R-18 credential drift signal; R-19 unlocatable cron control) — both are artifacts of stronger probing, not new system faults.
5. Risk half-life observation: infrastructure risks persist across phases unless a dated forcing event exists; R-01 is the only risk with such an event (2026-08-29). Recommend attaching forcing events to R-02 (post-change re-measurement deadline) and R-03 (hardening window).

---

## 8. Risk Scoring Snapshot (live-state basis)

Scores use Likelihood × Impact on a 1–5 scale, assigned from evidence frequency and severity markers in the corpus (not invented: anchored to the trajectory tables above).

| Risk | L | I | Score | Trend | Rationale anchor |
|---|---|---|---|---|---|
| R-03 Shuffle exposure + token | 4 | 5 | **20** | worsening while open | exposure verified in compose; token recorded; no TLS; UI reachable |
| R-01 Disk watermark | 4 | 4 | **16** | stable-pending-event | regrowth pattern proven twice; relief gated on 08-29 wave |
| R-02 Field errors | 5 | 3 | **15** | flat-high | continuous ~100/min accrual; remedy failed once already |
| R-05 Deployability/restore gap | 3 | 5 | **15** | static | NO-GO re-affirmed across ≥6 finals; drills pass component-wise only |
| R-04 Agents 013/015 | 4 | 2 | **8** | static-open | repeat-loss pattern; coverage gap only, no data loss evidenced |
| R-08 Swap pressure | 3 | 2 | **6** | improving-slowly | swappiness fix applied; usage persists at 64% without instability |
| R-18 OSD credential drift | 2 | 3 | **6** | new | single failed-auth observation this session |
| R-19 /tmp cron unproven | 2 | 2 | **4** | new | control may be silently absent; usage currently low (21%) |
| R-20 Corpus debt | 3 | 1 | **3** | managed | migration plan exists (phase38-59) |

Escalation triggers proposed: R-01 → P0 if disk ≥85% before wave executes or if 08-29 deletes fail to materialize; R-02 → escalate impact if cumulative errors double (~37K); R-03 → immediate P0 remediation block on any external-facing service deployment until bound/TLS fixed.

---

## 9. Monitoring Hooks (existing controls mapped to risks)

| Risk | Existing monitor | Cadence | Gap |
|---|---|---|---|
| R-01 | health-check.sh + watermark checks; daily audits (phase36-70) | daily | none — event pending |
| R-02 | error-rate observation (manual/P-series) | ad-hoc since restart | no automated threshold alert wired to analysisd logs |
| R-03 | phase38 hardening plan only | none operational | no bind-address/TLS probe in healthcheck suite |
| R-04 | endpoint-count-report.sh exists | unknown schedule | no reconnect-SLA alerting |
| R-05 | p28-fresh-target-gate.sh / p29 gates | per-release | no scheduled full-cluster drill |
| R-08 | memory audit (phase36-71) | session-based | PSI trend not continuously captured |
| R-19 | tmp validation report (phase38-81) | one-shot | cron-location proof outstanding |

---
