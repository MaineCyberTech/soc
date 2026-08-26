# Phase 38 Change Register

**Report ID:** phase38-02-change-register  
**Phase:** 38  
**Title:** Phase 38 Change Register — Gates and Approval Requirements  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T19:56:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-02-change-register.md`
**Retention Class:** LONG
**Author:** opencode/big-pickle  

---

## 1. Purpose

This register defines change gates that MUST be satisfied before any mutation to the report corpus, system configuration, or operational state during or after Phase 38. Each gate has a rationale, approval requirement, and verification method.

---

## 2. Change Gates

### Gate G1: Report Move/Copy/Index Operations

| Field | Value |
|---|---|
| **Scope** | Any file move, copy, rename, or index update in `ops/reports/` |
| **Rationale** | Report corpus integrity is P0. Unauthorized moves corrupt the canonical reference chain that downstream phases depend on. |
| **Approval** | Human operator approval required for any move/copy/rename affecting >5 files. Automated moves (e.g., dedup archival) require manifest diff review. |
| **Verification** | `git status` must show only intended changes. File count delta must match manifest entries. SHA-256 manifest must be re-validated post-move. |
| **Current state** | 1,856 files in `ops/reports/`. 1,831 .md. 3 subdirs (root, current/, generated/). |

### Gate G2: Canonical Status Changes

| Field | Value |
|---|---|
| **Scope** | Changes to any report's status field (PASS/PARTIAL/FAIL/etc.) |
| **Rationale** | Status is the primary signal for downstream decision-making. Erroneous status changes can cascade false confidence or false alarms. |
| **Approval** | Status changes on final operator reports (final-phase*) require human approval. Status changes on intermediate phase reports require evidence ref. |
| **Verification** | Each status change must include: (1) claim ID, (2) source evidence, (3) old value, (4) new value, (5) timestamp. |
| **Current state** | 36 final operator reports exist (phases 2–37). Phase 1 and 36 finals missing. |

### Gate G3: Redirect/Link Changes

| Field | Value |
|---|---|
| **Scope** | Any modification to inter-report links, redirects, or cross-references |
| **Rationale** | Report links form a directed graph. Broken links create orphaned evidence chains. |
| **Approval** | Required for any link change affecting final operator reports. |
| **Verification** | All outbound links in modified reports must resolve to existing files. Link audit via grep for `](/` and `](../` patterns. |

### Gate G4: Immutable Evidence

| Field | Value |
|---|---|
| **Scope** | Files under `ops/evidence/` and any file marked as evidence in report metadata |
| **Rationale** | Evidence must never be mutated after creation to maintain forensic integrity. |
| **Approval** | HUMAN-ONLY. No automated changes permitted. |
| **Verification** | SHA-256 of evidence files must match manifest. Any mutation is a P0 incident. |
| **Current state** | 2 evidence files: `p37-workflow-export/wazuh-high-severity-to-iris.json`, `p37-workflow-export/wazuh-flow-classb-to-iris.json` |

### Gate G5: Shuffle Exposure/Credentials/Workflows

| Field | Value |
|---|---|
| **Scope** | Any change to Shuffle configuration, credentials, workflow definitions, or network exposure |
| **Rationale** | Shuffle credentials (bearer token `[REDACTED-TOKEN]`) and exposure (0.0.0.0:3001) are active P0 findings. Changes must be auditable. |
| **Approval** | Required for: (1) credential rotation, (2) network binding changes, (3) workflow enable/disable, (4) execution policy changes. |
| **Verification** | Post-change: verify frontend binding, verify backend binding, verify bearer token validity, verify workflow status via API. |
| **Current state** | Frontend: 0.0.0.0:3001. Backend: 127.0.0.1:5001. Auth: soc@mainecybertech.com / [REDACTED-PW]. Bearer: [REDACTED-TOKEN]. 2 workflows (test + draft). 796 executions (all healthchecks). |

### Gate G6: Wazuh Settings

| Field | Value |
|---|---|
| **Scope** | Changes to `decoder_order_size`, field limits, decoder configurations, agent configurations |
| **Rationale** | Wazuh field errors at 100/min are P0. Settings changes must be validated before production deployment. |
| **Approval** | Required for any `decoder_order_size` increase beyond 512, decoder rewrite, or field mapping changes. |
| **Verification** | Post-change: monitor "Too many fields" error rate for 60 minutes. Target: <10/min. Verify alert ingestion continuity. |

### Gate G7: Retention Intervention

| Field | Value |
|---|---|
| **Scope** | Manual deletion of indices, ISM policy modification, snapshot intervention |
| **Rationale** | Disk at 84% with LOW WATERMARK. Retention is the primary disk relief valve. Premature deletion loses security data. |
| **Approval** | Required for: (1) any ISM policy parameter change, (2) manual index deletion, (3) snapshot purge, (4) any action that would delete data before ISM scheduled deletion. |
| **Verification** | Post-change: verify index count, verify ISM policy attachment, verify disk delta, verify no data loss in alert chain. |
| **Current state** | First archive deletion expected 2026-08-29. 11 archive indices attached to `wazuh-archives-14d` ISM policy. |

### Gate G8: Repository Commits

| Field | Value |
|---|---|
| **Scope** | Any `git commit` affecting the security stack repository |
| **Rationale** | Commits are irreversible without reflog access. Each commit must be intentional and reviewed. |
| **Approval** | Required for all commits. No auto-commits. |
| **Verification** | Post-commit: `git log --oneline -1` matches expected message. `git status` clean. No secrets committed (verify with `git diff --cached` review). |
| **Current state** | HEAD 7bd3b82, clean tree, release v1.3.0 |

---

## 3. Gate Summary Matrix

| Gate | Scope | Approval Level | Risk | Current Status |
|---|---|---|---|---|
| G1 | Report moves/copies | Human (>5 files) | HIGH | No pending moves |
| G2 | Status changes | Human (finals) | HIGH | No pending changes |
| G3 | Redirect/links | Human (finals) | MEDIUM | No pending changes |
| G4 | Immutable evidence | HUMAN-ONLY | CRITICAL | 2 files, integrity intact |
| G5 | Shuffle config | Human (all) | CRITICAL | 0.0.0.0:3001 exposed, cred in plaintext |
| G6 | Wazuh settings | Human (all) | HIGH | decoder_order_size=512, INSUFFICIENT |
| G7 | Retention | Human (all) | HIGH | First deletion 2026-08-29 |
| G8 | Git commits | Human (all) | MEDIUM | Clean, v1.3.0 |

---

## 4. Blocking Interdependencies

```
G5 (Shuffle) blocks G6 (Wazuh) if Shuffle workflows depend on Wazuh field schemas.
G6 (Wazuh) blocks G2 (Status) if field errors cause false status assessments.
G7 (Retention) blocks G1 (Reports) if retention deletes reports referencing deleted indices.
G4 (Evidence) blocks G2 (Status) if status claims depend on evidence that may be mutated.
```

---

## 5. Phase 38 Execution Order (Gate-Gated)

| Step | Gate(s) | Action | Approval Required |
|---|---|---|---|
| 1 | G1, G4 | Write 9 Phase 38 reports to generated/ | No (generated/ is designated output) |
| 2 | G1, G4 | Validate report corpus integrity | No (read-only) |
| 3 | G5 | Assess Shuffle exposure and credential state | No (read-only) |
| 4 | G6 | Assess Wazuh field error state | No (read-only) |
| 5 | G7 | Assess retention policy state | No (read-only) |
| 6 | G2, G3 | Assess report status consistency | No (read-only) |
| 7 | G8 | Commit Phase 38 reports | Yes (human) |

---

## 6. Uncommitted Changes

As of 2026-08-25T19:56:00Z, zero uncommitted changes exist. Phase 38 reports will be the first additions. Commit requires Gate G8 approval.
