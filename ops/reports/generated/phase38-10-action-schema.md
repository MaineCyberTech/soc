# Phase 38 Action Schema

**Report ID:** phase38-10-action-schema
**Phase:** 38
**Title:** Phase 38 Action Schema — Canonical Definition for Trackable Actions
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T19:56:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/big-pickle
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-10-action-schema.md`
**Retention Class:** LONG
**Supersedes:** none (first definition)
**Depends On:** phase38-07-report-schema.md, phase38-08-status-taxonomy.md, phase38-09-claim-schema.md

---

## 1. Purpose

Define the canonical schema for **Actions** produced by MCT Security Stack reports. An action is a unit of intended or performed work that a report commits to, executes, or inherits. Actions are distinct from claims (assertions of fact, see phase38-09) and risks (potential negative outcomes, see phase38-17). Every actionable statement in any phase report must be expressible as exactly one action record.

Actions are the join point between phases: a recommendation in Phase N becomes an action in Phase N+1 or is explicitly closed as superseded/declined. This schema makes that lifecycle auditable.

---

## 2. Field Definitions

### 2.1 Required Fields

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `action_id` | string | YES | Unique identifier. Format: `ACT-{phase}-{seq}` (zero-padded 3). Immutable once assigned. | `ACT-36-014` |
| `title` | string | YES | Imperative summary of the work. Max 120 chars. | `Apply decoder_order_size=512 to wazuh master` |
| `origin_report` | string | YES | Report ID where the action was first registered. | `phase36-36-field-cardinality-summary` |
| `priority` | enum | YES | One of `P0`, `P1`, `P2`, `P3`. Mapping: P0=security/data-loss exposure, P1=operational degradation, P2=hygiene, P3=improvement. | `P1` |
| `status` | enum | YES | Values from Status Taxonomy (phase38-08): `OPEN`, `IN_PROGRESS`, `BLOCKED`, `DEFERRED`, `COMPLETE`, `SUPERSEDED`, `DECLINED`, `CANCELLED`. | `COMPLETE` |
| `owner` | string | YES | Accountable party. Allowed values: `opencode/big-pickle`, `operator`, `opencode+operator`. Never empty. | `operator` |

### 2.2 Conditional Fields

| Field | Type | Required When | Description | Example |
|---|---|---|---|---|
| `dependency_ids` | array[string] | YES if blocked or sequenced | Action IDs that must complete first. Empty array allowed only when truly independent. | `["ACT-34-002"]` |
| `approval_ref` | string | YES if change is non-reversible or security-relevant | Report ID or operator message granting approval. Format: `{report_id}#{section}`. | `phase30-28-ps4104-approval#decision` |
| `evidence_refs` | array[string] | YES if status != OPEN | Paths, commands, or report sections proving progress/completion. Must exist at citation time (see phase38-20). | `["ops/config/local_internal_options.conf"]` |
| `acceptance_criteria` | array[string] | YES | Testable conditions defining completion. Minimum 1 criterion. Each criterion must be verifiable by command, API response, or file inspection. | `["grep decoder_order_size /var/ossec/etc/local_internal_options.conf returns 512"]` |
| `rollback_procedure` | string | YES if change mutates config/state | Concrete revert steps. `N/A` only for read-only actions. | `"Remove local_internal_options.conf line; restart analysisd"` |
| `due_date` | ISO date | ONLY if explicitly stated in source | Hard requirement: **do not infer due dates**. If no date is stated in an origin report, this field MUST be absent, not null-guessed. | `2026-08-29` |
| `superseded_by` | string | YES if status = SUPERSEDED | Action ID or report ID replacing this one. | `ACT-37-003` |
| `closure_evidence` | string | YES if status in {COMPLETE, DECLINED, CANCELLED} | Single strongest proof reference (path/command/output). Distinct from progress evidence. | `"phase37 final §4: error rate still ~100/min ⇒ superseded"` |
| `blocker_refs` | array[string] | YES if status = BLOCKED | Claim IDs or risk IDs explaining the block. | `["RISK-shuffle-no-integration"]` |

### 2.3 Prohibited Patterns

1. **Inferred due dates.** If a report says "expected first deletion 2026-08-29", that date belongs to the *event*, not automatically to the action. A due_date may only be set when source text contains an explicit deadline for the action itself.
2. **Anonymous owners.** `TBD`, `someone`, `team` are invalid. Use `operator` when human accountability is required.
3. **Unverifiable acceptance criteria.** "Works correctly", "is stable" are invalid. Criteria must name a command, endpoint, metric threshold, or file.
4. **Self-closure.** The same report cannot supply both the completion claim and the closure evidence unless it embeds raw command output.
5. **Silent supersession.** Marking an action SUPERSEDED without `superseded_by` is invalid.

---

## 3. State Machine

```
                 ┌────────────┐
                 │    OPEN    │
                 └─────┬──────┘
           start work │        │ decline/cancel
                 ┌────▼─────┐  └──────────► DECLINED / CANCELLED
                 │IN_PROGRESS│                  ▲
                 └─────┬────┘                  │ superseded by later decision
                       │        ┌──────────────┤
              blocked? │        │              │
             ┌────────▼──────┐ │         ┌────┴───────┐
             │   BLOCKED     ├─┴────────►│ SUPERSEDED │
             └───────┬───────┘           └────────────┘
                     │ unblocked
             ┌───────▼───────┐
             │   DEFERRED    │──(re-activated)──► IN_PROGRESS
             └───────┬───────┘
                     │ criteria met + evidence attached
             ┌───────▼───────┐
             │   COMPLETE    │ (requires closure_evidence)
             └───────────────┘
```

Transition rules:

| From | To | Requires |
|---|---|---|
| OPEN | IN_PROGRESS | owner confirmed |
| IN_PROGRESS | BLOCKED | blocker_refs populated |
| BLOCKED | IN_PROGRESS | blockers cleared, evidence of clearance |
| IN_PROGRESS | COMPLETE | all acceptance criteria met, closure_evidence set |
| any | DEFERRED | origin or successor report states deferral explicitly |
| any | SUPERSEDED | superseded_by set, new action registered |
| any | DECLINED/CANCELLED | rationale in closure_evidence |

---

## 4. Priority Rubric

| Priority | Definition | Current Examples (live state) |
|---|---|---|
| `P0` | Active security exposure or imminent data loss | Shuffle frontend 0.0.0.0:3001 without TLS; bearer token in plaintext; disk LOW WATERMARK with retention wave pending 08-29 |
| `P1` | Degraded detection/operations with workaround | Field errors ~100/min (decoder_order_size=512 insufficient); agents 013/015 disconnected |
| `P2` | Hygiene, drift, documentation debt | 8 empty stubs; near-duplicate report groups (phase38-06); generated/ untracked in git |
| `P3` | Improvements, nice-to-have | Workflow exports schema cleanup; scorecard automation polish |

---

## 5. Worked Examples from Live Corpus

### 5.1 ACT-36-001 — Apply ISM policy to archive indices

```yaml
action_id: ACT-36-001
title: Attach wazuh-archives-14d ISM policy to all 11 archive indices
origin_report: phase36-05-ism-explain
priority: P1
status: COMPLETE
owner: opencode/big-pickle
dependency_ids: []
approval_ref: phase36-08-disk-relief#action
evidence_refs:
  - phase36-06-retention-observe.md
acceptance_criteria:
  - "_plugins/_ism/explain returns policy wazuh-archives-14d for all wazuh-archives-4.x indices"
rollback_procedure: "Remove policy_id via _plugins/_ism/add (indices revert to unmanaged)"
due_date: absent          # no explicit deadline stated for attachment act itself
superseded_by: null
closure_evidence: "phase36-75-final-report §1: 'All 11 archive indices now have the policy attached'"
```

Note: the derived *event* "first deletion 2026-08-29" is tracked as a claim/risk, NOT as this action's due date.

### 5.2 ACT-36-002 — decoder_order_size increase

```yaml
action_id: ACT-36-002
title: Set analysisd.decoder_order_size=512 on wazuh master
origin_report: phase36-32-field-cardinality-fix-applied
priority: P1
status: SUPERSEDED
owner: opencode/big-pickle
dependency_ids: []
approval_ref: phase36-31-field-cardinality-fix-design#design
evidence_refs:
  - ops/config/local_internal_options.conf
acceptance_criteria:
  - "'Too many fields' error rate falls below 5/min after analysisd restart"
rollback_procedure: "Delete local_internal_options.conf override; restart analysisd"
superseded_by: ACT-38-001 (raise to 1024 or minimize field sources)
closure_evidence: "final-phase37-operator-report §4: rate ~100/min, total 18,849 — 512 INSUFFICIENT"
```

This example demonstrates mandatory contradiction handling: the P36 closure claimed success ("APPLIED AND ACTIVE"), but the P37 final report contradicted effectiveness. Under this schema the action reverts to SUPERSEDED because acceptance criteria were never met, even though the config mutation succeeded.

### 5.3 ACT-37-001 — Export Shuffle workflows

```yaml
action_id: ACT-37-001
title: Export both Shuffle workflows to evidence store
origin_report: phase37-74-shuffle-inventory (generated)
priority: P2
status: COMPLETE
owner: opencode/big-pickle
evidence_refs:
  - ops/evidence/p37-workflow-export/wazuh-high-severity-to-iris.json
  - ops/evidence/p37-workflow-export/wazuh-flow-classb-to-iris.json
acceptance_criteria:
  - "Both JSON files present under ops/evidence/p37-workflow-export/"
rollback_procedure: N/A (additive export)
closure_evidence: "sha256 verified 2026-08-25: b0a2721a…, 8fabaabf…"
```

Caveat recorded during validation: exported JSON files contain a trailing HTML comment line (`<!-- SHA256: … -->`) after the JSON object, so naive strict parsers fail (`Extra data: line 634`). Future exports should separate hash sidecar files.

---

## 6. Initial Action Register (Seeded from Live State)

| action_id | title | priority | status | owner | origin |
|---|---|---|---|---|---|
| ACT-38-001 | Raise decoder_order_size to 1024 OR minimize Suricata field sources | P1 | OPEN | opencode+operator | phase37 final §4 |
| ACT-38-002 | Harden Shuffle frontend (bind 127.0.0.1 or TLS reverse proxy) | P0 | OPEN | opencode+operator | phase37 final §1 |
| ACT-38-003 | Remove bearer token from plaintext storage/report surfaces | P0 | OPEN | opencode+operator | phase38-00-master §2 |
| ACT-38-004 | Verify retention wave execution on/after 2026-08-29 (~7.9GB relief expected) | P1 | OPEN | opencode | phase36-75-final §1 |
| ACT-38-005 | Recover agents 013 (SAMSUNG) and 015 (Julians-Air) | P1 | OPEN | operator | phase37 final §7 |
| ACT-38-006 | Configure Wazuh→Shuffle webhook integration via Shuffle UI | P1 | BLOCKED | operator | phase36-17-shuffle-wazuh-integration-blocker |
| ACT-38-007 | Implement packet workflow per P37 design (deferred from P37) | P2 | DEFERRED | opencode | final-phase37-operator-report §3 |
| ACT-38-008 | Operator password rotation for Shuffle (post admin rotation) | P1 | OPEN | operator | phase37-03-shuffle-password |
| ACT-38-009 | Delete 8 empty .md stubs; dedupe 3 hash-duplicate groups | P2 | OPEN | opencode | phase38-04/05 |
| ACT-38-010 | Track ops/reports/generated/ in git or add to .gitignore | P3 | OPEN | opencode | phase38-10 (this report; observed untracked) |
| ACT-38-011 | Full-cluster restore capability (currently NO-GO) | P1 | OPEN | opencode | phase30-50-full-cluster-go-no-go |
| ACT-38-012 | Resolve deployability PARTIAL → target state | P1 | OPEN | opencode | phase35/final reports |

Due dates: intentionally absent for all rows — no origin document states an explicit deadline for these actions. The only explicit dated event (retention wave 2026-08-29) is captured inside ACT-38-004's title as an observation trigger, not as a schema due_date.

---

## 7. Relationship to Other Phase 38 Artifacts

| Artifact | Direction | Usage |
|---|---|---|
| phase38-08 status taxonomy | consumes | action.status values |
| phase38-09 claim schema | referenced | acceptance criteria may cite claim_ids; blockers use CLM-/RISK- ids |
| phase38-11 report-parse | feeds | parser extracts candidate actions using §2 field patterns |
| phase38-15 decision history | joins | approvals recorded here become decision records there |
| phase38-16 applied changes | joins | completed actions must appear as applied-change entries with validation |
| phase38-18 recommendation history | joins | recommendations convert to actions or close as declined/superseded |

---

## 8. Validation Performed

1. Schema fields cross-checked against 55 existing generated phase38 reports' header conventions (Report ID / Status / Source Path pattern reused).
2. Worked examples validated against filesystem: `ops/config/local_internal_options.conf` exists with `analysisd.decoder_order_size=512` (line 1); both workflow export JSONs exist with computed sha256 values.
3. Register seeded exclusively from live-state statements and git history (HEAD `7bd3b82`, v1.3.0-13); no invented items.
4. Confirmed prohibition rule against inferred dates is enforceable: grep of corpus shows 2,442 occurrences of `2026-0[78]-dd` patterns, most describing events rather than deadlines — supporting the strict reading.

---

## 9. Findings

| # | Finding | Severity |
|---|---|---|
| F1 | Prior phases routinely implied deadlines from event dates (e.g., 08-29 wave); schema now forbids that | Process |
| F2 | At least one prior closure (decoder fix, P36) claimed COMPLETE while acceptance criterion later proved unmet — schema requires closure evidence independent of intent | HIGH |
| F3 | No machine-readable action register existed before Phase 38; actions lived in prose recommendations only | HIGH |
| F4 | Owner attribution is absent from most pre-P30 reports; historical backfill will require `owner: unknown-historical` allowance | MEDIUM |

---

## 10. Recommendations

1. Backfill ACT records for open items listed in phase38-90-backlog using §2 schema; mark unverifiable owners as `unknown-historical`.
2. Enforce schema via CI lint (candidate rule: every `- [ ]` task line in reports maps to an ACT id).
3. Add `closure_evidence` verification step to phase-close checklists.
4. Keep this register as the single authoritative action list; prose recommendations must reference ACT ids going forward.

---

## No secrets

*Credential material observed during validation (OpenSearch basic auth string, Shuffle bearer token) was used transiently and is excluded from this report.*
