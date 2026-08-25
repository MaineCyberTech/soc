# Phase 38 Report Schema

**Report ID:** phase38-07-report-schema  
**Phase:** 38  
**Title:** Phase 38 Report Schema — Required Metadata Definition  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T19:56:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-07-report-schema.md`
**Retention Class:** LONG
**Author:** opencode/big-pickle  

---

## 1. Purpose

Define the required metadata fields for every report in the MCT Security Stack report corpus. This schema ensures consistency, traceability, and machine-readability across all 1,831+ reports.

---

## 2. Schema Definition

Every report MUST contain the following metadata fields in its YAML frontmatter or markdown header block:

### 2.1 Core Fields (Required)

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `report_id` | string | YES | Unique identifier. Format: `phase{N}-{seq}-{slug}` or `final-phase{N}-operator-report-{timestamp}` | `phase38-01-preflight` |
| `phase` | integer/string | YES | Phase number. Use `31v2` for revision phases. Use `0` for pre-phase or meta-reports. | `38` |
| `title` | string | YES | Human-readable title. Max 120 chars. | `Phase 38 Preflight — System State Snapshot` |
| `date` | ISO 8601 date | YES | Report creation date (YYYY-MM-DD). | `2026-08-25` |
| `timestamp` | ISO 8601 datetime | YES | Report creation timestamp with timezone. | `2026-08-25T19:56:00Z` |
| `classification` | enum | YES | Security classification. Values: `PUBLIC`, `INTERNAL`, `CONFIDENTIAL`, `SECRET`. | `INTERNAL` |
| `scope` | string | YES | Description of what this report covers. Max 200 chars. | `Full-stack preflight for Phase 38 execution` |
| `status` | enum | YES | Current status. Values: see Status Taxonomy (phase38-08). | `COMPLETE` |
| `authoritative` | boolean | YES | Whether this report is the canonical source for its topic. `true` for finals, `false` for intermediate. | `true` |

### 2.2 Reference Fields (Required)

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `evidence_roots` | array[string] | YES | Paths to evidence files this report depends on. Empty array if none. | `["/opt/mct-security-stack/ops/evidence/p37-workflow-export/"]` |
| `supersedes` | string | NO | Report ID this report supersedes. `null` if none. | `phase31-79-repo-commit` |
| `superseded_by` | string | NO | Report ID that supersedes this report. `null` if none. | `final-phase37-operator-report-20260825-1943Z` |
| `source_path` | string | YES | Absolute path to this report file. | `/opt/mct-security-stack/ops/reports/generated/phase38-01-preflight.md` |
| `hash` | string | YES | SHA-256 hash of the file content. Computed at write time. | `a1b2c3d4...` |

### 2.3 Ownership Fields (Required)

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `owners` | array[string] | YES | Responsible parties. At least one required. | `["opencode/big-pickle", "human-operator"]` |
| `blockers` | array[string] | NO | Blocker IDs referenced by this report. Empty if none. | `["BLK-001", "BLK-002"]` |

### 2.4 Claim Fields (Required)

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `claims` | array[object] | YES | Claims made by this report. Each claim has: `claim_id`, `statement`, `evidence_refs`. | See Claim Schema (phase38-09) |

### 2.5 Retention Field (Required)

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `retention_class` | enum | YES | How long this report must be retained. Values: `PERMANENT`, `LONG` (2yr), `MEDIUM` (1yr), `SHORT` (90d), `TEMPORARY` (30d). | `LONG` |

---

## 3. Metadata Template

```yaml
---
report_id: "phase38-01-preflight"
phase: 38
title: "Phase 38 Preflight — System State Snapshot"
date: "2026-08-25"
timestamp: "2026-08-25T19:56:00Z"
classification: "INTERNAL"
scope: "Full-stack preflight for Phase 38 execution"
status: "COMPLETE"
authoritative: true
evidence_roots: []
supersedes: null
superseded_by: null
source_path: "/opt/mct-security-stack/ops/reports/generated/phase38-01-preflight.md"
hash: "COMPUTE_AT_WRITE_TIME"
owners:
  - "opencode/big-pickle"
blockers: []
claims: []
retention_class: "LONG"
---
```

---

## 4. Field Rules

### 4.1 report_id
- MUST be unique across the entire corpus
- MUST follow naming convention: `phase{N}-{seq}-{slug}` for phase reports
- MUST follow naming convention: `final-phase{N}-operator-report-{YYYYMMDD-HHMMSS}` for finals
- MUST NOT contain spaces, special characters, or uppercase letters
- Existing 1,831 reports are grandfathered but flagged for migration

### 4.2 phase
- MUST be a positive integer or integer+suffix (e.g., `31v2`)
- Use `0` for meta-reports (like this Phase 38 report)
- Phase 38 reports use `phase: 38`

### 4.3 status
- MUST use values from the Status Taxonomy (phase38-08)
- MUST be updated when claim verification changes the report's standing

### 4.4 authoritative
- MUST be `true` for: final operator reports, canonical references, scorecards
- MUST be `false` for: intermediate reports, drafts, working copies, superseded reports
- MUST be `false` for: empty stubs, templates, placeholder files

### 4.5 hash
- MUST be computed as SHA-256 of the file content (excluding the hash field itself)
- MUST be recomputed if the file is modified
- MUST match the hash in the hash manifest (phase38-05)

### 4.6 retention_class
- `PERMANENT`: Final operator reports, evidence files, claim verification records
- `LONG` (2yr): Scorecards, audit results, deployment records
- `MEDIUM` (1yr): Intermediate phase reports, health checks, status snapshots
- `SHORT` (90d): Working copies, temporary analyses, cron outputs
- `TEMPORARY` (30d): Empty stubs (before deletion), test outputs, scratch files

---

## 5. Backward Compatibility

Existing reports (1,831 files) do NOT have YAML frontmatter. This schema is forward-looking for Phase 38+ reports. Migration of existing reports is recommended but not required for Phase 38.

**Migration priority:**
1. Final operator reports (36 files) — add metadata headers
2. Empty stubs (8 files) — delete, no migration needed
3. Phase reports (1,650 files) — batch migration in Phase 39
4. Non-phase reports (181 files) — selective migration

---

## 6. Validation Rules

| Rule | Enforcement |
|---|---|
| All required fields present | Hard fail |
| report_id uniqueness | Hard fail |
| status enum validity | Hard fail |
| classification enum validity | Hard fail |
| retention_class enum validity | Hard fail |
| hash matches content | Hard fail (warn on mismatch) |
| supersedes/superseded_by reference existing reports | Soft warn |
| claims array non-empty | Soft warn |
| evidence_roots reference existing paths | Soft warn |
| owners non-empty | Hard fail |
