# Phase 38 Report Templates

**Report ID:** phase38-65-templates
**Phase:** 38
**Title:** Phase 38 Templates — Normative Skeletons for All Report Types
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:15:00Z
**Classification:** INTERNAL
**Status:** PASS
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-65-templates.md`
**Retention Class:** canonical-current

---

## 1. Purpose

Create the normative template set for every report type in the corpus. Actual files written under `/opt/mct-security-stack/ops/reports/generated/templates/` (promoted to `schemas/templates/` at migration apply):

1. `phase-final.md.tmpl`
2. `audit.md.tmpl`
3. `incident.md.tmpl`
4. `change-register.md.tmpl`
5. `verification-ledger.md.tmpl`
6. `current-state.md.tmpl`
7. `decision-record.md.tmpl`
8. `scorecard.md.tmpl`
9. `client-safe-report.md.tmpl`

## 2. Common Frontmatter Contract

Every template carries YAML frontmatter; instantiation MUST replace all `{{placeholders}}` and delete nothing:

```yaml
---
report_id: {{report_id}}
phase: {{phase}}
title: {{title}}
date: {{YYYY-MM-DD}}
classification: INTERNAL | CLIENT-SAFE
status: <enum per phase38-08>
authority: AUTHORITATIVE-CURRENT | PHASE-FINAL | GENERATED-AUDIT | CLIENT-SAFE | TEMPLATE
evidence_refs: [path#sha256, ...]
source_path: {{absolute path of this instance}}
retention_class: <per phase38-58>
---
```

Required fields: all eight above plus `source_path`. Status enum values are exactly the taxonomy: PASS, PARTIAL, FAIL, BLOCKED, DEFERRED, PENDING, IN PROGRESS, RETIRED, NO-GO, UNKNOWN, UNVERIFIED, CONTRADICTED, STALE, NOT APPLICABLE.

## 3. Template Inventory and Section Skeletons

| Template | Key sections |
|---|---|
| phase-final | Execution Summary, Deliverables, Claims Verified, Blockers, Handoff |
| audit | Scope, Method, Findings (severity-ranked), Evidence, Remediation |
| incident | Timeline, Impact, Root Cause, Containment, Follow-ups |
| change-register | Gate table, Change rows (append-only), Approvals |
| verification-ledger | Claim rows: id / statement / method / evidence_ref / verdict |
| current-state | Domain truth tables, Known-broken list, Interim-truth note |
| decision-record | Context, Options, Decision, Consequences, Supersedes |
| scorecard | Metric table (value/target/trend), Internal + client-safe split |
| client-safe-report | Redaction log, Approved summary sections, Distribution list |

## 4. Instantiation Rules

1. Copy template → new file named per phase38-56 pattern.
2. Replace placeholders; no `{{...}} may survive (CI-enforced).
3. Fill evidence_refs with real path+hash pairs; empty list only for TEMPLATE/DRAFT class.
4. New file starts status PENDING or IN PROGRESS; transitions follow phase38-08.
5. The `.tmpl` files themselves are never edited to hold facts.

## 5. Files Created

9 template files (verified on disk after write):

```
generated/templates/phase-final.md.tmpl
generated/templates/audit.md.tmpl
generated/templates/incident.md.tmpl
generated/templates/change-register.md.tmpl
generated/templates/verification-ledger.md.tmpl
generated/templates/current-state.md.tmpl
generated/templates/decision-record.md.tmpl
generated/templates/scorecard.md.tmpl
generated/templates/client-safe-report.md.tmpl
```

Authority class of each `.tmpl`: TEMPLATE. Retention: permanent while normative.
