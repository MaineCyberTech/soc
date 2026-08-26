# Phase 38 Prioritized Remediation Plan

**Report ID:** phase38-54-generate-remediation
**Phase:** 38
**Title:** Corrective Plan — Report Gaps + Operational Gaps Merged, Prioritized
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:55:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-54-generate-remediation.md`
**Retention Class:** LONG
**Supersedes:** `phase38-42-gap-priority.md` prioritization (retained as input) and scattered backlog rows absorbed by phase38-47 IDs
**Owners:** ["opencode/ox-alpha", "SOAR ops owner", "Wazuh/indexer config owner", "Infrastructure owner", "Endpoint ops owner", "ops-reports-owner"]

---

## 1. Plan Structure

Three horizons: **Immediate** (≤48h), **Near-term** (≤2 weeks), **Structural** (this quarter). Every item carries owner, dependencies, acceptance criteria, rollback, and the output report that proves completion. Canonical work-item IDs come from phase38-47; missing-artifact IDs from phase38-46.

---

## 2. Immediate (≤48h)

### REM-38-01 — Rotate disclosed Shuffle bearer token (= ACT-38-003)

| Field | Content |
|---|---|
| Rationale | Token `[REDACTED-TOKEN]` printed plaintext in generated/phase38-01-preflight.md:131; treat as compromised regardless of redaction |
| Owner | SOAR ops owner |
| Deps | Consumer inventory (workflow webhook nodes, cron/scripts using the token) |
| Acceptance | Old token → 401 everywhere; new token stored env-abstraction style (pattern: ops/creds.env, mode 600); functional test of high-severity workflow run; grep sweep shows no new plaintext copies |
| Rollback | Forward-fix only; re-issue old value solely to unbreak a critical consumer, then re-rotate |
| Output report | `phase39-XX-token-rotation-proof.md` (API 401/200 transcript, redacted) |

### REM-38-02 — Redact 3 credential leaks in generated reports

| Field | Content |
|---|---|
| Locations | `generated/phase38-00-master.md:63` · `generated/phase38-01-preflight.md:131` · `generated/phase38-73-shuffle-hardening.md` §Step 1 code block |
| Owner | ops-reports-owner (with SOAR ops owner for values) |
| Deps | None (redaction independent of rotation; do both anyway) |
| Acceptance | Secrets replaced by `[REDACTED see creds.env]` placeholders via git-tracked commits (no history rewrite needed for INTERNAL repo — note: if repo ever publishes, history scrub becomes mandatory); grep sweep clean; commit messages contain no secrets |
| Rollback | Git revert of redaction commits (never desirable post-rotation) |
| Output report | `phase39-XX-redaction-diff.md` with before/after hunks (values masked) |

### REM-38-03 — Fix field limit via index template (= ACT-38-002, corrected mechanism)

| Field | Content |
|---|---|
| Action | Create/update index template for `wazuh-archives-*` setting `index.mapping.total_fields.limit` ≥2000; optionally prune high-cardinality Filebeat source fields. Do NOT touch decoder_order_size (irrelevant; leave staged value documented) |
| Owner | Wazuh/indexer config owner |
| Deps | None; coordinate messaging with BCK-38-105 observation window |
| Acceptance | Template visible via API; error rate ≈0/min over 60 min measured against exact signature `"Limit of total fields [1000]"`; new archive indices inherit template; no mapping errors introduced |
| Rollback | Delete/previous-version template; mapping-only change, no data loss |
| Output report | `phase39-XX-field-limit-template-applied.md` (before/after rate series) |

---

## 3. Near-term (≤2 weeks)

### REM-38-04 — Harden Shuffle (= ACT-38-001)

| Field | Content |
|---|---|
| Action | Bind frontend to 127.0.0.1 or deploy TLS-terminating authenticated reverse proxy; firewall allowlist if off-box UI required; close DEC-38-008 governance hole with explicit approval record either way |
| Owner | SOAR ops owner |
| Deps | Off-box access decision; maintenance window; token rotation done first (REM-38-01) |
| Acceptance | Listener/probe evidence: external :3001 denied; workflows unaffected (spot-run); approval artifact filed under `ops/checklists/approvals/` |
| Rollback | Revert compose edit from backup; restore prior listener state (documented as re-exposure — unacceptable long-term) |
| Output report | `phase39-XX-shuffle-hardening-applied.md` |

### REM-38-05 — Register snapshot repository + canary drill (= BCK-38-103 / MIS-38-07)

| Field | Content |
|---|---|
| Action | Register fs or S3 repository; snapshot canary index; restore it to a scratch location; leave nightly cron pointing at working destination |
| Owner | Infrastructure owner |
| Deps | Storage decision; disk headroom check (24G avail constrains fs repos — prefer S3/off-box) |
| Acceptance | `_snapshot/_all` non-empty; restore drill log with byte counts; cron success log next cycle |
| Rollback | Unregister repository (indices unaffected) |
| Output report | `phase39-XX-snapshot-repo-drill.md` |

### REM-38-06 — Ratify decision records (MIS-38-05)

| Field | Content |
|---|---|
| Action | Operator signs retroactive approval artifacts for DEC-38-001/002/005/006/009/010/012/015/016; exposure decision (DEC-38-008) gets an incident-style record acknowledging the unrecorded change |
| Owner | ops-reports-owner + operator |
| Deps | Operator availability |
| Acceptance | Signed/dated artifacts under `ops/checklists/approvals/` referenced from phase38-52 ledger rows |
| Rollback | N/A (records additive) |
| Output report | `phase39-XX-approval-ratification.md` |

### REM-38-07 — Archive v1.3.0 release asset on-box (MIS-38-04)

| Field | Content |
|---|---|
| Action | Fetch once; store `ops/evidence/releases/v1.3.0/<asset>` + `<asset>.sha256`; verify da72bde4… match; adopt pattern for all future releases |
| Owner | Release owner |
| Deps | Network + GitHub reachability; install gh CLI (MIS-38-09) recommended |
| Acceptance | On-disk hash equals release manifest; ledger EV-38-03 updated to on-box |
| Rollback | Remove archived copy (keep hash record) |
| Output report | `phase39-XX-release-asset-archived.md` |

### REM-38-08 — Build packet workflow (BCK-38-101) + formalize integration (BCK-38-102)

| Field | Content |
|---|---|
| Action | Build packet-card workflow per phase37 design; formalize existing high-severity→IRIS integration (trigger contract = OpenCanary L12; routing approval path) |
| Owner | SOAR ops owner + Detection owner |
| Deps | REM-38-01/04 complete (don't build on exposed surface or leaked token) |
| Acceptance | Synthetic packet run FINISHED; dedup/failure/replay checks per phase37 matrix; integration doc approved; valid JSON export + sha256 sidecar stored |
| Rollback | Disable/delete drafts; prior exports retained immutable |
| Output report | `phase39-XX-packet-workflow-live.md` |

### REM-38-09 — Clear tooling gaps (MIS-38-09, MIS-38-10)

| Field | Content |
|---|---|
| Action | Install gh CLI (least-privilege token, env-stored); re-run exec-mode audit chunked to avoid timeout |
| Owner | Infrastructure owner |
| Deps | Package availability; token provisioning |
| Acceptance | `gh auth status` OK scoped; exec-mode audit completes with PASS/PARTIAL verdict recorded |
| Rollback | Remove gh/token on compromise suspicion |
| Output report | `phase39-XX-tooling-audit-rerun.md` |

### REM-38-11 — Author RTO/RPO targets (MIS-38-08)

| Field | Content |
|---|---|
| Action | Define RTO/RPO per service tier (indexer, manager, IRIS, Shuffle); map current NO-GO reality to gaps; attach to deployability cert |
| Owner | Infrastructure owner + operator sign-off |
| Deps | REM-38-05 (snapshot capability informs achievable RPO) |
| Acceptance | Targets published in deployability section; UNVERIFIED flag cleared in phase38-50 CLM-38-046 |
| Rollback | Supersede targets document (targets are policy, reversible by revision) |
| Output report | `phase39-XX-rto-rpo-definition.md` |

---

## 4. Structural (this quarter)

### REM-38-10 — Corpus migration apply (BCK-38-106) + stub cleanup (BCK-38-107)

| Field | Content |
|---|---|
| Action | Execute designed migration (frontmatter, supersession markers incl. STL-38 pointers, dup alias marking, link rewrites); delete 8 stubs; reconcile counters by class+scope |
| Owner | ops-reports-owner |
| Deps | Freeze window; dry-run artifacts phase38-55..70 reviewed |
| Acceptance | Migration verify passes (0 broken links, markers applied, canonical index resolves); 0 zero-byte .md; count statement convention adopted corpus-wide |
| Rollback | Git revert to pre-migration HEAD |
| Output report | `phase39-XX-migration-applied-verified.md` |

### REM-38-12 — CI gates for report truthfulness (from phase38-71 design)

| Field | Content |
|---|---|
| Action | Enforce gates: secret-scan on generated reports (would have caught all 3 leaks), live-signature anchoring rule for error claims (would have caught CON-38-02), count-with-scope lint, status-vocabulary lint, evidence-hash sidecars for exports |
| Owner | ops-reports-owner + CI owner |
| Deps | REM-38-10 schema conventions |
| Acceptance | Gates run on report commits; intentional bad-commit rejected in test; dashboard-free (CLI) operation |
| Rollback | Disable individual gates without removing pipeline |
| Output report | `phase39-XX-ci-gates-live.md` |

### REM-38-13 — Capacity program around ISM reality

| Field | Content |
|---|---|
| Action | Adopt corrected relief arithmetic (≈3.76GB first wave; ~7.5GB archive ceiling) in all capacity plans; define disk escalation thresholds given 84% now and 24G headroom; observe 08-29 wave (BCK-38-105) and recalibrate |
| Owner | Infrastructure owner |
| Deps | BCK-38-105 date-driven evidence |
| Acceptance | Capacity doc cites computable numbers only; FORECAST rows quarantined per phase38-51 rules; post-wave plan updated |
| Rollback | N/A (planning artifact revisions) |
| Output report | `phase39-XX-capacity-recalibrated.md` |

---

## 5. Execution Order & Dependencies Graph

```
REM-38-01 (token) ─┬─> REM-38-04 (harden) ──> REM-38-08 (workflows)
REM-38-02 (redact) ┘        │
REM-38-03 (field template)  ├──> REM-38-11 (RTO/RPO) needs REM-38-05 (snapshots)
REM-38-05 (snapshots) ──────┘
REM-38-06/07/09 independent
REM-38-10 -> REM-38-12 -> ongoing enforcement
BCK-38-105 (08-29 wave) -> REM-38-13
```

## 6. Certification Unblock Map

| Blocked claim | Unblocked by |
|---|---|
| Release assurance reproducibility | REM-38-07 (+09) |
| Governance/security sections | REM-38-06 (+01/02/04) |
| DR/restore narratives | REM-38-05 + REM-38-11 |
| Reporting workstream completeness | REM-38-08 (+10 dashboards MIS-38-03) |
| Deployability certification | REM-38-03/05/11 combined |

## 7. Cadence

Immediate items reviewed daily until closed; near-term weekly; structural at phase boundaries. All closures must reference this plan's REM IDs and land their output reports in `generated/` following the naming standard.
