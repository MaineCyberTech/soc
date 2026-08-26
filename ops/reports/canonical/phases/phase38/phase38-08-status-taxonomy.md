# Phase 38 Status Taxonomy

**Report ID:** phase38-08-status-taxonomy  
**Phase:** 38  
**Title:** Phase 38 Status Taxonomy — Normalized Status Values and Transition Rules  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T19:56:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-08-status-taxonomy.md`
**Retention Class:** LONG
**Author:** opencode/big-pickle  

---

## 1. Purpose

Define a normalized set of status values for the MCT Security Stack report corpus. Every report's `status` field MUST use one of these values. This taxonomy ensures consistent interpretation across phases.

---

## 2. Status Values

### 2.1 Terminal States (No further transitions expected)

| Status | Meaning | When to Use |
|---|---|---|
| **PASS** | All claims verified, no blockers, evidence complete | Final operator reports where all checks passed |
| **FAIL** | One or more claims contradicted by evidence, or critical blocker unresolved | Reports where investigation proved a claim false |
| **RETIRED** | No longer relevant, replaced by newer work, or superseded | Reports that have been superseded by later reports or are obsolete |
| **NOT APPLICABLE** | Scope does not apply to current system state | Reports written for scenarios that did not materialize |

### 2.2 Active States (Transitions expected)

| Status | Meaning | When to Use |
|---|---|---|
| **PARTIAL** | Some claims verified, some pending or contradicted | Most common intermediate state. Some checks passed, others need work. |
| **IN PROGRESS** | Actively being worked on, not yet complete | Reports being written or investigations in progress |
| **PENDING** | Awaiting external input, approval, or dependency | Reports blocked on human decision or upstream completion |

### 2.3 Advisory States (Informational)

| Status | Meaning | When to Use |
|---|---|---|
| **BLOCKED** | Cannot proceed due to external dependency or blocker | Reports where work is halted by an identified blocker |
| **DEFERRED** | Deliberately postponed to a future phase | Valid work that is acknowledged but not prioritized now |
| **UNKNOWN** | Insufficient information to determine status | Initial state for reports where investigation has not begun |

### 2.4 Verification States (Evidence-related)

| Status | Meaning | When to Use |
|---|---|---|
| **UNVERIFIED** | Claims exist but have not been checked against evidence | Reports with claims that lack verification |
| **CONTRADICTED** | At least one claim is contradicted by evidence | Reports where evidence disproves a claim |
| **STALE** | Once-valid status that may no longer reflect current state | Reports older than 7 days without re-verification |

### 2.5 Composite States

| Status | Meaning | When to Use |
|---|---|---|
| **NO-GO** | System-level assessment: deployment or restore is not safe | Deployability assessments, restore preflights |

---

## 3. Status Definitions (Detailed)

### PASS
```
Definition: All claims in the report have been verified against current evidence,
no active blockers exist, and the system state matches the expected state.
Prerequisites: All claims verified, evidence refs valid, blockers empty.
Confidence: HIGH — system state is validated.
```

### PARTIAL
```
Definition: Some claims are verified, others are pending, contradicted, or
cannot be verified due to missing evidence. This is the MOST COMMON status
for intermediate phase reports.
Prerequisites: At least one claim verified, at least one claim pending or contradicted.
Confidence: MEDIUM — partial validation achieved.
```

### FAIL
```
Definition: One or more critical claims are contradicted by evidence, or a
blocker prevents the report's objectives from being met.
Prerequisites: At least one claim contradicted, or critical blocker active.
Confidence: HIGH that the system does NOT meet the stated objectives.
```

### BLOCKED
```
Definition: Work cannot proceed due to an external dependency, missing access,
or unresolved prerequisite from another team or phase.
Prerequisites: Blocker identified, dependency documented.
Confidence: N/A — work has not been attempted.
```

### DEFERRED
```
Definition: Valid work that has been deliberately postponed. The report's
objectives are acknowledged but not prioritized for the current phase.
Prerequisites: Acknowledgment that the work is valid but not urgent.
Confidence: N/A — work deferred.
```

### PENDING
```
Definition: Report is complete but awaiting human approval, external validation,
or dependency resolution before status can be updated.
Prerequisites: Report written, awaiting action.
Confidence: PENDING — awaiting resolution.
```

### IN PROGRESS
```
Definition: Report is actively being written or investigation is ongoing.
Not yet complete.
Prerequisites: Work has started.
Confidence: N/A — work ongoing.
```

### UNKNOWN
```
Definition: Insufficient information to determine status. This is the initial
state for reports where investigation has not yet begun.
Prerequisites: Report exists but no investigation performed.
Confidence: N/A — no data.
```

### UNVERIFIED
```
Definition: Claims exist in the report but have not been checked against
current evidence. This is common for older reports whose claims have
not been re-validated.
Prerequisites: Claims defined, no verification performed.
Confidence: N/A — claims unverified.
```

### CONTRADICTED
```
Definition: At least one claim in the report is contradicted by current
evidence. The report's conclusions may be partially or fully invalid.
Prerequisites: Claim verification performed, contradiction found.
Confidence: HIGH that the contradicted claim is false.
```

### STALE
```
Definition: The report's status was once valid but may no longer reflect
current system state due to time elapsed or system changes.
Definition of "stale": Report older than 7 days without re-verification,
or system state has changed since last verification.
Prerequisites: Report was once PASS or PARTIAL, now outdated.
Confidence: LOW — status may be outdated.
```

### NO-GO
```
Definition: System-level assessment that a deployment, restore, or major
operation is not safe to execute. This is a compound status that implies
FAIL for the specific operation.
Prerequisites: Deployability assessment, restore preflight, or operational
readiness check.
Confidence: HIGH that the operation should not proceed.
```

### NOT APPLICABLE
```
Definition: The report's scope does not apply to the current system state.
This happens when the system configuration changed such that the report's
assumptions are no longer valid.
Prerequisites: System state change renders report irrelevant.
Confidence: N/A — report not relevant.
```

---

## 4. Transition Rules

### 4.1 Allowed Transitions

```
UNKNOWN → IN PROGRESS → PARTIAL → PASS
UNKNOWN → IN PROGRESS → PARTIAL → FAIL
UNKNOWN → IN PROGRESS → PENDING → PASS
UNKNOWN → IN PROGRESS → PENDING → FAIL
PARTIAL → PASS (all remaining claims verified)
PARTIAL → FAIL (contradiction found)
PARTIAL → BLOCKED (dependency identified)
PARTIAL → DEFERRED (deliberate postponement)
PARTIAL → STALE (time elapsed without re-verification)
BLOCKED → PARTIAL (blocker resolved, work resumes)
BLOCKED → DEFERRED (blocker won't be resolved soon)
DEFERRED → IN PROGRESS (work resumed)
PENDING → PASS (approval received, claims verified)
PENDING → FAIL (approval denied or claims contradicted)
PASS → STALE (time elapsed without re-verification)
PASS → FAIL (new evidence contradicts claims)
FAIL → PARTIAL (contradiction resolved, partial progress)
FAIL → RETIRED (report abandoned)
UNVERIFIED → PASS (verification performed, claims verified)
UNVERIFIED → FAIL (verification performed, claims contradicted)
UNVERIFIED → PARTIAL (verification performed, mixed results)
STALE → PASS (re-verification confirms status)
STALE → PARTIAL (re-verification shows partial validity)
STALE → FAIL (re-verification shows failure)
STALE → RETIRED (re-verification shows obsolescence)
CONTRADICTED → RETIRED (contradiction accepted, report retired)
CONTRADICTED → PARTIAL (contradiction resolved for some claims)
NO-GO → PASS (blockers resolved)
NO-GO → PARTIAL (some blockers resolved)
```

### 4.2 Forbidden Transitions

```
PASS → UNKNOWN (never "un-know" a passing status without evidence)
FAIL → UNKNOWN (never "un-know" a failing status)
RETIRIED → anything (retired is terminal)
NOT APPLICABLE → anything (N/A is terminal)
IN PROGRESS → PASS (must go through verification first)
BLOCKED → PASS (must go through PARTIAL first)
```

### 4.3 Auto-Transition Rules

| Trigger | Transition | Scope |
|---|---|---|
| Report age > 7 days without re-verification | PASS/PARTIAL → STALE | All reports |
| Report age > 30 days without re-verification | STALE → RETIRED (recommended) | Non-final reports |
| System state change (e.g., disk reclamation, agent reconnection) | STALE → IN PROGRESS | Affected reports |
| Empty file detected (0 bytes) | UNKNOWN → RETIRED | Empty stubs only |
| Hash mismatch detected | Any → CONTRADICTED | Reports with modified content |

---

## 5. Status Distribution (Current Corpus)

Based on the 1,831 report files:

| Status | Estimated Count | Notes |
|---|---|---|
| UNKNOWN | ~1,500 | Most phase reports lack verification metadata |
| PARTIAL | ~100 | Intermediate reports with partial validation |
| PASS | ~36 | Final operator reports (estimated) |
| STALE | ~200 | Reports older than 7 days without re-verification |
| RETIRED | ~0 | No reports formally retired yet |
| IN PROGRESS | 0 | No active writing sessions |
| BLOCKED | ~5 | Reports blocked on unresolved issues |
| DEFERRED | ~10 | Valid work postponed |
| FAIL | ~0 | No formal failures recorded |
| NO-GO | 1 | Deployability assessment |
| CONTRADICTED | 0 | No formal contradictions recorded |
| UNVERIFIED | ~80 | Reports with unverified claims |
| NOT APPLICABLE | 0 | No reports formally marked N/A |

**Note:** These are estimates. Actual status requires metadata migration of all 1,831 reports.

---

## 6. Usage in Phase 38 Reports

| Report | Status | Rationale |
|---|---|---|
| phase38-01-preflight | COMPLETE → mapped to PARTIAL | Preflight complete but not all claims verified |
| phase38-02-change-register | COMPLETE → mapped to PASS | Change gates defined and validated |
| phase38-03-report-root-discovery | COMPLETE → mapped to PASS | All roots discovered and documented |
| phase38-04-report-inventory | COMPLETE → mapped to PASS | Full inventory completed |
| phase38-05-report-hash-duplicates | COMPLETE → mapped to PASS | Hash analysis completed |
| phase38-06-report-near-duplicates | COMPLETE → mapped to PASS | Near-duplicate analysis completed |
| phase38-07-report-schema | COMPLETE → mapped to PASS | Schema defined |
| phase38-08-status-taxonomy | COMPLETE → mapped to PASS | Taxonomy defined |
| phase38-09-claim-schema | COMPLETE → mapped to PASS | Claim schema defined |
