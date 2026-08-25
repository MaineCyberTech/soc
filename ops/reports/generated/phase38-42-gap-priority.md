# Phase 38-42: Gap Register & Priority Classification

**Title:** Phase 38-42: Gap Register **Report ID: Priority Classification
**Report ID:** phase38-42-gap-priority
**Phase:** 38
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-42-gap-priority.md`
**Retention Class:** LONG
**Author:** opencode (ox-alpha)

---

## 1. Method

Every gap below is verified against evidence on disk or live state (2026-08-25). Priorities: P0 = active security/reliability exposure; P1 = capability required for security value delivery; P2 = resilience/coverage; P3 = hygiene. Deadlines are event-based only (no invented dates); the sole calendar anchor is the already-documented ISM wave on 2026-08-29.

Canonical action IDs come from `generated/phase38-36-duplicate-action-scan.md` §3.

---

## 2. P0 — Critical

### GAP-01 / ACT-001: Shuffle frontend exposed without TLS or access control

| Field | Value |
|---|---|
| Evidence (live) | `ss -tlnp`: LISTEN 0.0.0.0:3001; HTTP 200 via nginx; HTTPS probe empty |
| Evidence (corpus) | `phase37-04-shuffle-listener.md:11,74` (HIGH active); `phase37-07-shuffle-exposure-apply.md` all steps ⏸; `generated/phase38-92-scorecard.md:44` FAIL |
| Impact | Unauthenticated-network reachability to SOAR control plane; bearer token already disclosed in reports (`generated/phase38-01-preflight.md:131`) → compounding risk |
| Dependencies | None. Blocked only on operator approval artifact (currently nonexistent — phase38-34 MISS-08) |
| Risk if unaddressed | External tampering with workflows; credential replay |
| Owner | Shuffle ops + Operator (approval) |
| Acceptance | Listener shows loopback/management-only bind OR firewall DROP verified from external vantage; TLS or documented protected path; both validations archived as evidence files |
| Rollback | Remove iptables rules / revert bind via compose revert (procedure already drafted in `generated/phase38-73-shuffle-hardening.md` §Step 2) |

### GAP-02 / ACT-002: Field errors ~100/min — decoder_order_size=512 insufficient

| Field | Value |
|---|---|
| Evidence | Live error rate; `phase37-38-field-postlogs.md:11-19`; cumulative 18,849+ (`phase37-81-final.md:48`); contingency staged-not-applied (`phase37-42-field-limit-apply.md:3`) |
| Impact | Continuous decoder failures for Suricata stats events → silent alert loss risk + log noise at ~144k/day; disk write amplification |
| Dependencies | Choice between lever (a) stats minimization (`phase37-39`) and lever (b) limit ≥1024 (`phase37-41-field-limit-plan.md:13`); decision record exists (`phase37-43-field-resolution.md`) but execution not started |
| Risk | Normalized detection coverage for sensor-stats events remains degraded indefinitely |
| Owner | Wazuh config |
| Acceptance | Sustained <10 "Too many fields" errors/min over 24h post-change, with before/after log windows archived |
| Rollback | Revert local_internal_options.conf entry to 512 and restart analysisd |

---

## 3. P1 — High

### GAP-03 / ACT-003: Packet workflow exists as design only

| Field | Value |
|---|---|
| Evidence | `phase37-81-final.md:35-40` ("Implementation: DEFERRED… Design only"); two design passes (`phase37-17…31`, `generated/phase38-75-packet-workflow.md:5`, `phase38-76…:5`); no workflow JSON/execution proof on disk |
| Impact | SPAN packet pipeline (proven P31v2–P35) delivers no automated SOC action; detection→response chain broken at SOAR hop |
| Dependencies | ACT-001 first (safe deployment surface); Shuffle UI/webhook availability |
| Owner | SOAR ops |
| Acceptance | Workflow created in test mode; synthetic execution proof captured (per `phase38-76` methodology); export + hash stored in ops/evidence/ |
| Rollback | Delete/disable workflow; exports provide restore baseline |

### GAP-04 / ACT-004: Wazuh→Shuffle integration never configured

| Field | Value |
|---|---|
| Evidence | Blocker + 5-step resolution path untouched since P36 (`phase36-17-shuffle-wazuh-integration-blocker.md`); 0 real routing executions across 796 (`phase37-32-routing-decision.md`; live) |
| Impact | Zero end-to-end alert automation; SOC value of SOAR currently nil despite GREEN cluster |
| Dependencies | ACT-001 (exposure), GAP-02 (error noise), owner approval for production routing (explicit blocker list item 5 in `phase37-32`) |
| Owner | SOC + Shuffle ops |
| Acceptance | ossec.conf integration block live; one high-severity synthetic alert routed E2E with case/ticket artifact |
| Rollback | Remove integration block from ossec.conf; restart manager |

### GAP-05 / ACT-005: Credential rotation loop incomplete + tokens disclosed

| Field | Value |
|---|---|
| Evidence | Operator receipt rows all ⏸ (`phase37-03-shuffle-password.md`); bearer token printed in reports and NOT yet rotated (`generated/phase38-00-master.md:169` roadmap vs `phase38-01-preflight.md:131` disclosure); IRIS credentials plaintext at `ops/backups/iris-api-key.txt` |
| Impact | Disclosed token = working bypass of UI controls regardless of GAP-01 hardening |
| Dependencies | None for token rotation; operator channel for receipt closure |
| Owner | Security + Operator |
| Acceptance | Token rotated; old token rejected (proof captured); operator receipt checklist closed; validation script output archived (`ops/scripts/credential-rotation-validation.sh`) |
| Rollback | Re-issue token per runbook; previous token already invalid post-rotation |

---

## 4. P2 — Medium

### GAP-06 / ACT-006: ISM deletion wave unobserved; relief forecast unsupported

| Field | Value |
|---|---|
| Evidence | Zero deletions to date; explain endpoint empty (`generated/phase38-79-retention-verification.md` §§1–2); ~7.9GB forecast conflicts with per-index table (~3.76GB computable for cited indices — see `generated/phase38-39-metric-consistency.md` MCY-04); observation mandated (`phase37-81-final.md:63`) |
| Impact | Disk planning (84% LOW watermark) relies on relief that may not execute; watermark breach risk continues |
| Dependencies | Calendar anchor **2026-08-29** (first eligible archive); no invented deadline |
| Owner | Infrastructure |
| Acceptance | Post-wave: deletion count + bytes freed recorded; disk % delta measured; forecast corrected against actuals |
| Rollback | N/A (observation); contingency = manual index delete runbook under change control if policy fails to fire |

### GAP-07 / ACT-007: Agents 013/015 disconnected with stalled recovery

| Field | Value |
|---|---|
| Evidence | Live fleet state; recovery program artifacts ended at status-only follow-ups (`phase37-51-agent013-status.md`, `phase37-52-agent015-status.md`); strategy docs (`phase36-41-endpoint-recovery-strategy.md`) define actions never executed |
| Impact | Coverage gap on BYOD/mobile endpoints; billing/completeness claims (PARTIAL) persist |
| Dependencies | Endpoint access windows (historically the blocker per finals P22–P30 throttle/access notes) |
| Owner | SOC / endpoint owners |
| Acceptance | Both agents ACTIVE ≥24h with telemetry flowing, OR formally moved to retired with asset-register update |
| Rollback | N/A (additive) |

### GAP-08 / ACT-010: Report migration apply deferred after passing dry-run

| Field | Value |
|---|---|
| Evidence | Dry-run PASSED (`generated/phase38-68-migration-dryrun.md`); apply DEFERRED pending approval (`generated/phase38-69-migration-apply.md:5,18`); verify step unexecuted; rollback proof absent (phase38-34 MISS-09) |
| Impact | Canonical-index/superseded-metadata benefits blocked; stale-claim risk persists corpus-wide |
| Dependencies | Operator approval; rollback proof execution in scratch target first |
| Owner | opencode + Operator (approval) |
| Acceptance | Apply executed with manifest log (as drafted in phase38-69 §template); verify report clean; rollback rehearsal proof archived |
| Rollback | Manifest-driven reverse operations (already specified) |

### GAP-09: Full-cluster restore remains NO-GO

| Field | Value |
|---|---|
| Evidence | Gate table NO-GO since P28 era through current (`phase36-75-final-report.md:54`; `generated/phase38-94-deployability.md`; master roadmap item 15) |
| Impact | DR posture for the core stack unproven at full scale (single/multi-index drills passed earlier) |
| Dependencies | Isolated target provisioning (recorded blocker: "Isolated target: No", `phase37-81-final.md:126`) |
| Owner | Infrastructure |
| Acceptance | Fresh-target full-stack restore reaching GREEN with healthcheck 0 FAIL |
| Rollback | N/A |

---

## 5. P3 — Hygiene

### GAP-10 / ACT-009: Corpus hygiene batch open

Evidence: 8 zero-byte stubs still present (`generated/phase38-04-report-inventory.md:30-43`); 3 duplicate groups/12 files (`generated/phase38-05…` §Summary); 60 files lacking superseded markers (`generated/phase38-00-master.md:166`); unreconciled 1,877 canonical figure (`generated/phase38-03`). Impact: mis-citation risk across 1,833+ reports. Owner: opencode. Acceptance: stubs deleted, aliases marked, consolidation counts closed out. Rollback: git-tracked deletes revertable.

### GAP-11: Secret redaction backlog in generated/

Evidence: three confirmed plaintext-credential locations (`generated/phase38-40-security-claim-audit.md` §2.3: SEC-01/02/03). Impact: every generated file becomes non-client-safe until redacted. Owner: opencode + Security. Acceptance: values stripped, rotation proofs attached (ties to GAP-05), CI secret gate enabled (`generated/phase38-71-report-ci.md` extension). Rollback: n/a (redaction is subtractive; originals remain in git history — history rewrite is a separate governed decision).

---

## 6. Priority Overview

| ID | Gap | Pri | Class | Owner | Anchor |
|---|---|---|---|---|---|
| GAP-01 | Shuffle exposure | P0 | REPEATEDLY-DEFERRED | Shuffle ops | approval gate |
| GAP-02 | Field errors 100/min | P0 | OPEN | Wazuh config | none — immediate |
| GAP-05 | Credentials/token | P1* | PARTIAL/DISCLOSED | Security | immediate (token) |
| GAP-03 | Packet workflow | P1 | STALLED | SOAR ops | after GAP-01 |
| GAP-04 | Integration/routing | P1 | OPEN | SOC+SOAR | after GAP-01/02 |
| GAP-06 | ISM wave observation | P2 | SCHEDULED | Infra | 2026-08-29 wave |
| GAP-07 | Agent recovery | P2 | STALLED | SOC | access window |
| GAP-08 | Migration apply | P2 | APPROVAL-GATED | opencode | rollback proof first |
| GAP-09 | Full-cluster restore | P2 | NO-GO standing | Infra | isolated target |
| GAP-10 | Corpus hygiene | P3 | OPEN | opencode | — |
| GAP-11 | Secret redaction | P3* | NEW | opencode | with GAP-05 |

\* GAP-05/GAP-11 are prioritized above their nominal class because disclosure converts them into effective security gaps.

## 7. Standing Rule

No date commitments beyond the documented 2026-08-29 ISM anchor. Sequencing rule: GAP-01 → GAP-03 → GAP-04 forms the minimum path to first real routing value; GAP-02 and GAP-05 proceed in parallel immediately.
